package blostesoftware.blostefix.catalogo.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.CategoriaPostDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.models.Categoria;
import blostesoftware.blostefix.catalogo.repositories.CategoriaRepository;
import blostesoftware.blostefix.exceptions.CategoriaAlreadyExistsException;

@Service // Indica que esta clase es un componente de servicio de Spring (lógica de negocio).
public class CategoriaServiceIMPL implements CategoriaService {

    @Autowired // Inyección de dependencias del repositorio de categorías.
    CategoriaRepository categoriaRepository;

    /* @Override // EN DESUSO, USAR PAGEABLE
    public java.util.List<CategoriaPublicDTO> getAllCategorias() {
        List<Categoria> categorias = categoriaRepository.findAll();
        List<CategoriaPublicDTO> categoriasDTO = new java.util.ArrayList<>();
        for (Categoria categoria : categorias) {
            categoriasDTO.add(CategoriaPublicDTO.convertToDTO(categoria));
        }
        return categoriasDTO;
    } */

    @Override
    public Page<CategoriaPublicDTO> getAllCategoriasPageable(int page, int size) {
        // Crea un objeto PageRequest para solicitar una página específica, con un tamaño determinado, ordenada por ID de forma descendente.
        PageRequest pageable = PageRequest.of(page, size, Sort.by("id").descending());
        Page<Categoria> categoriasPage = categoriaRepository.findAll(pageable);
        // Convierte la página de entidades Categoria a una página de DTOs (CategoriaPublicDTO) usando Streams.
        return new PageImpl<>(categoriasPage.getContent().stream().map(CategoriaPublicDTO::convertToDTO).toList(), pageable, categoriasPage.getTotalElements());
    }

    @Override
    public CategoriaPublicDTO getCategoriaById(Long id) {
        // Optional se usa para manejar posibles valores nulos de forma segura (evita NullPointerException).
        Optional<Categoria> categoriaOpt = categoriaRepository.findById(id);
        if (categoriaOpt.isPresent()) {
            return CategoriaPublicDTO.convertToDTO(categoriaOpt.get());
        }
        return null;
    }

    @Override
    public CategoriaPublicDTO saveCategoria(CategoriaPostDTO dto) {
        // Lógica de negocio: Comprueba si ya existe una categoría con el mismo nombre (ignorando mayúsculas/minúsculas).
        if (categoriaRepository.existsByNombreIgnoreCase(dto.getNombre())) {
            // Lanza una excepción personalizada que será capturada por el @RestControllerAdvice en el controlador.
            throw new CategoriaAlreadyExistsException(
                "La\scategoria\sya\sexiste"
            );
        }

        // Mapea el DTO a Entidad, la guarda en la BD y devuelve la entidad guardada mapeada a DTO.
        Categoria categoria = CategoriaPostDTO.convertToEntity(dto);
        Categoria saved = categoriaRepository.save(categoria);

        return CategoriaPublicDTO.convertToDTO(saved);
    }

    @Override
    public CategoriaPrivateDTO updateCategoria(CategoriaPrivateDTO categoriaDTO) {
        // Busca la categoría existente por ID.
        Optional<Categoria> categoriaOpt = categoriaRepository.findById(categoriaDTO.getId());
        if (categoriaOpt.isPresent()) {
            Categoria categoria = categoriaOpt.get();
            // Actualiza los campos necesarios.
            categoria.setNombre(categoriaDTO.getNombre());
            // Guarda los cambios en la base de datos.
            categoriaRepository.save(categoria);
            return CategoriaPrivateDTO.convertToDTO(categoria);
        }
        return null;
    }

    @Override
    public CategoriaPrivateDTO deleteCategoria(Long id) {
        Optional<Categoria> categoriaOpt = categoriaRepository.findById(id);
        if (categoriaOpt.isPresent()) {
            Categoria categoria = categoriaOpt.get();
            categoriaRepository.deleteById(id);
            return CategoriaPrivateDTO.convertToDTO(categoria);
        }
        return null;
    }
    
}

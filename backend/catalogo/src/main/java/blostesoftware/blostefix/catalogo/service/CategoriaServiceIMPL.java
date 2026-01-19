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

@Service
public class CategoriaServiceIMPL implements CategoriaService {

    @Autowired
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
        PageRequest pageable = PageRequest.of(page, size, Sort.by("id").descending());
        Page<Categoria> categoriasPage = categoriaRepository.findAll(pageable);
        return new PageImpl<>(categoriasPage.getContent().stream().map(CategoriaPublicDTO::convertToDTO).toList(), pageable, categoriasPage.getTotalElements());
    }

    @Override
    public CategoriaPublicDTO getCategoriaById(Long id) {

        Optional<Categoria> categoriaOpt = categoriaRepository.findById(id);
        if (categoriaOpt.isPresent()) {
            return CategoriaPublicDTO.convertToDTO(categoriaOpt.get());
        }
        return null;
    }

    @Override
    public CategoriaPublicDTO saveCategoria(CategoriaPostDTO dto) {

        if (categoriaRepository.existsByNombreIgnoreCase(dto.getNombre())) {
            throw new CategoriaAlreadyExistsException(
                "La categoria ya existe"
            );
        }

        Categoria categoria = CategoriaPostDTO.convertToEntity(dto);
        Categoria saved = categoriaRepository.save(categoria);

        return CategoriaPublicDTO.convertToDTO(saved);
    }

    @Override
    public CategoriaPrivateDTO updateCategoria(CategoriaPrivateDTO categoriaDTO) {
        Optional<Categoria> categoriaOpt = categoriaRepository.findById(categoriaDTO.getId());
        if (categoriaOpt.isPresent()) {
            Categoria categoria = categoriaOpt.get();
            categoria.setNombre(categoriaDTO.getNombre());
            categoria.setDescripcion(categoriaDTO.getDescripcion());
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

package blostesoftware.blostefix.catalogo.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.models.Categoria;
import blostesoftware.blostefix.catalogo.repositories.CategoriaRepository;

@Service
public class CategoriaServiceIMPL implements CategoriaService {

    @Autowired
    CategoriaRepository categoriaRepository;

    /* @Override
    public void saveCategoria() {
        
    } */

    @Override
    public java.util.List<blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO> getAllCategorias() {
        List<Categoria> categorias = categoriaRepository.findAll();
        List<CategoriaPublicDTO> categoriasDTO = new java.util.ArrayList<>();
        for (Categoria categoria : categorias) {
            categoriasDTO.add(CategoriaPublicDTO.convertToDTO(categoria));
        }
        return categoriasDTO;
    }

    @Override
    public blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO getCategoriaById(Long id) {

        Optional<Categoria> categoriaOpt = categoriaRepository.findById(id);
        if (categoriaOpt.isPresent()) {
            return CategoriaPublicDTO.convertToDTO(categoriaOpt.get());
        }
        return null;
    }

    @Override
    public void saveCategoria(Categoria categoria) {
        categoriaRepository.save(categoria);
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

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
    public void saveCategoria(CategoriaPrivateDTO categoriaDTO) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'saveCategoria'");
    }

    @Override
    public CategoriaPrivateDTO updateCategoria(CategoriaPrivateDTO categoriaDTO) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'updateCategoria'");
    }

    @Override
    public CategoriaPrivateDTO deleteCategoria(Long id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'deleteCategoria'");
    }
    
}

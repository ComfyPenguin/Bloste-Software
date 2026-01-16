package blostesoftware.blostefix.catalogo.service;


import org.springframework.data.domain.Page;

import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.models.Categoria;

public interface CategoriaService {
    void saveCategoria(Categoria categoria);

    //List<CategoriaPublicDTO> getAllCategorias();

    Page<CategoriaPublicDTO> getAllCategoriasPageable(int page, int size);

    CategoriaPublicDTO getCategoriaById(Long id);

    CategoriaPrivateDTO updateCategoria(CategoriaPrivateDTO categoriaDTO);

    CategoriaPrivateDTO deleteCategoria(Long id);
}

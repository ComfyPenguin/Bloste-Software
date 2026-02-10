package blostesoftware.blostefix.catalogo.service;


import org.springframework.data.domain.Page;

import blostesoftware.blostefix.catalogo.dto.CategoriaPostDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;

public interface CategoriaService {
    CategoriaPublicDTO saveCategoria(CategoriaPostDTO categoriaPostDTO);

    //List<CategoriaPublicDTO> getAllCategorias();

    Page<CategoriaPublicDTO> getAllCategoriasPageable(int page, int size);

    CategoriaPublicDTO getCategoriaById(Long id);

    CategoriaPrivateDTO updateCategoria(CategoriaPrivateDTO categoriaDTO);

    CategoriaPrivateDTO deleteCategoria(Long id);
}

package blostesoftware.blostefix.catalogo.service;

import java.util.List;

import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.models.Categoria;

public interface CategoriaService {
    void saveCategoria(Categoria categoria);

    List<CategoriaPublicDTO> getAllCategorias();

    CategoriaPublicDTO getCategoriaById(Long id);

    CategoriaPrivateDTO updateCategoria(CategoriaPrivateDTO categoriaDTO);

    CategoriaPrivateDTO deleteCategoria(Long id);
}

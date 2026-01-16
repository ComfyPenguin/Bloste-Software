package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;

import blostesoftware.blostefix.catalogo.models.Categoria;
import lombok.Data;

@Data
public class CategoriaPostDTO implements Serializable {
    static final long serialVersionUID = 1L;
    private String nombre;
    private String descripcion;

    public static CategoriaPostDTO convertToDTO(Categoria categoria) {
        CategoriaPostDTO categoriaDTO = new CategoriaPostDTO();
        categoriaDTO.setNombre(categoria.getNombre());
        categoriaDTO.setDescripcion(categoria.getDescripcion());
        return categoriaDTO;
    }

    public static Categoria convertToEntity(CategoriaPostDTO categoriaDTO) {
        Categoria categoria = new Categoria();
        categoria.setNombre(categoriaDTO.getNombre());
        categoria.setDescripcion(categoriaDTO.getDescripcion());
        return categoria;
    }
}

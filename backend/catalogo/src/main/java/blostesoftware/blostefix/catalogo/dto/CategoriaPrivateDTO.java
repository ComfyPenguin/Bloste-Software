package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;

import blostesoftware.blostefix.catalogo.models.Categoria;
import lombok.Data;

@Data
public class CategoriaPrivateDTO implements Serializable{
    static final long serialVersionUID=1L;
    private Long id;
    private String nombre;
    private String descripcion;

    public static CategoriaPrivateDTO convertToDTO(Categoria categoria){
        CategoriaPrivateDTO categoriaDTO = new CategoriaPrivateDTO();
        categoriaDTO.setId(categoria.getId());
        categoriaDTO.setNombre(categoria.getNombre());
        categoriaDTO.setDescripcion(categoria.getDescripcion());
        return categoriaDTO;
    }

    public static Categoria convertToEntity(CategoriaPrivateDTO categoriaDTO){
        Categoria categoria = new Categoria();
        categoria.setId(categoriaDTO.getId());
        categoria.setNombre(categoriaDTO.getNombre());
        categoria.setDescripcion(categoriaDTO.getDescripcion());
        return categoria;
    }
}

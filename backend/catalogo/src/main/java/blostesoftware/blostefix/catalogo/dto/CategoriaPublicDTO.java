package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;

import blostesoftware.blostefix.catalogo.models.Categoria;
import lombok.Data;


@Data
public class CategoriaPublicDTO implements Serializable{
    static final long serialVersionUID=1L;
    private long id;
    private String nombre;
    private String descripcion;

    public static CategoriaPublicDTO convertToDTO(Categoria categoria){
        CategoriaPublicDTO categoriaDTO = new CategoriaPublicDTO();
        categoriaDTO.setId(categoria.getId());
        categoriaDTO.setNombre(categoria.getNombre());
        categoriaDTO.setDescripcion(categoria.getDescripcion());
        return categoriaDTO;
    }

    public static Categoria convertToEntity(CategoriaPublicDTO categoriaDTO){
        Categoria categoria = new Categoria();
        categoria.setNombre(categoriaDTO.getNombre());
        categoriaDTO.setDescripcion(categoria.getDescripcion());

        return categoria;
    }
}

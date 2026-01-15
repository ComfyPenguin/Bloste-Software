package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;

import blostesoftware.blostefix.catalogo.models.Categoria;
import lombok.Data;


@Data
public class CategoriaPublicDTO implements Serializable{
    static final long serialVersionUID=1L;
    private String nombre;

    public static CategoriaPublicDTO convertToDTO(Categoria categoria){
        CategoriaPublicDTO categoriaDTO = new CategoriaPublicDTO();
        categoriaDTO.setNombre(categoria.getNombre());
        return categoriaDTO;
    }

    public static Categoria convertToEntity(CategoriaPublicDTO categoriaDTO){
        Categoria categoria = new Categoria();
        categoria.setNombre(categoriaDTO.getNombre());

        return categoria;
    }
}

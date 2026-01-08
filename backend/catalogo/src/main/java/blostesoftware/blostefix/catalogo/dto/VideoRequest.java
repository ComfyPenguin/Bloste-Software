package blostesoftware.blostefix.catalogo.dto;

import java.util.Set;

public class VideoRequest {
    public String titulo;
    public String autor;
    public String descripcion;
    public int duracion;
    public String url;
    public String urlImg;
    public Set<Integer> categoriaIds;
}

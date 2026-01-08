package blostesoftware.blostefix.catalogo.dto;

import java.time.LocalDate;
import java.util.Set;

public class VideoResponse {
    public int id;
    public String titulo;
    public String descripcion;
    public String url;
    public LocalDate fechaSubida;
    public LocalDate fechaActualizacion;
    public Set<String> categorias;
}
package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;
import java.util.List;

import blostesoftware.blostefix.catalogo.models.Categoria;
import blostesoftware.blostefix.catalogo.models.Video;
import lombok.Data;



@Data
public class VideoPublicDTO implements Serializable {
    static final long serialVersionUID=1L;
    private String titulo;
    private String autor;
    private String descripcion;
    private int duracion;
    private String urlVideo;
    private String urlImagen;
    private java.time.LocalDate fechaSubida;
    private java.time.LocalDate fechaActualizacion;
    private List<String> categorias;

    public static VideoPublicDTO converToDTO(Video v){
        VideoPublicDTO videoDTO = new VideoPublicDTO();
        videoDTO.setTitulo(v.getTitulo());
        videoDTO.setAutor(v.getAutor());
        videoDTO.setDescripcion(v.getDescripcion());
        videoDTO.setDuracion(v.getDuracion());
        videoDTO.setUrlVideo("api/hls/"+v.getIdVideo());
        videoDTO.setUrlImagen("api/thumbnail/"+v.getIdVideo());
        videoDTO.setFechaSubida(v.getFechaSubida());
        videoDTO.setFechaActualizacion(v.getFechaActualizacion());
        videoDTO.setCategorias(
            v.getCategorias().stream()
                 .map(Categoria::getNombre)
                 .toList()
        );
        return videoDTO;
    }

    public static Video convertToEntity(VideoPublicDTO videoDTO){
        Video video = new Video();
        video.setTitulo(videoDTO.getTitulo());
        video.setAutor(videoDTO.getAutor());
        video.setDescripcion(videoDTO.getDescripcion());
        video.setDuracion(videoDTO.getDuracion());
        video.setIdVideo(videoDTO.getUrlVideo());
        video.setFechaSubida(videoDTO.getFechaSubida());
        video.setFechaActualizacion(videoDTO.getFechaActualizacion());
        video.setCategorias(
            videoDTO.getCategorias().stream()
                    .map(nombre -> {
                        Categoria c = new Categoria();
                        c.setNombre(nombre);
                        return c;
                    })
                    .toList()
        );
        return video;
    }

}

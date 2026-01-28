package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;
import java.util.Set;

import blostesoftware.blostefix.catalogo.models.Categoria;
import blostesoftware.blostefix.catalogo.models.Video;
import lombok.Data;



@Data
public class VideoPublicDTO implements Serializable {
    static final long serialVersionUID=1L;
    private Long id;
    private String idVideo;
    private String titulo;
    private String autor;
    private String descripcion;
    private int duracion;
    private String urlVideo;
    private String urlImagen;
    private java.time.LocalDate fechaSubida;
    private java.time.LocalDate fechaActualizacion;
    private Set<Categoria> categorias;

    public static VideoPublicDTO converToDTO(Video v){
        VideoPublicDTO videoDTO = new VideoPublicDTO();
        videoDTO.setId(v.getId());
        videoDTO.setIdVideo(v.getIdVideo());
        videoDTO.setTitulo(v.getTitulo());
        videoDTO.setAutor(v.getAutor());
        videoDTO.setDescripcion(v.getDescripcion());
        videoDTO.setDuracion(v.getDuracion());
        videoDTO.setUrlVideo(v.getUrlVideo());
        videoDTO.setUrlImagen(v.getUrlImagen());
        videoDTO.setFechaSubida(v.getFechaSubida());
        videoDTO.setFechaActualizacion(v.getFechaActualizacion());
        if (v.getCategorias() != null) {
            videoDTO.setCategorias(v.getCategorias());
        }
        return videoDTO;
    }

    /* public static Video convertToEntity(VideoPublicDTO videoDTO){
        Video video = new Video();
        video.setId(videoDTO.getId());
        video.setIdVideo(videoDTO.getIdVideo());
        video.setTitulo(videoDTO.getTitulo());
        video.setAutor(videoDTO.getAutor());
        video.setDescripcion(videoDTO.getDescripcion());
        video.setDuracion(videoDTO.getDuracion());
        video.setIdVideo(videoDTO.getUrlVideo());
        video.setFechaSubida(videoDTO.getFechaSubida());
        video.setFechaActualizacion(videoDTO.getFechaActualizacion());
        video.setCategorias(videoDTO.getCategorias());
        return video;
    } */

}

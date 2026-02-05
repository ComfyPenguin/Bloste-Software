package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Set;

import blostesoftware.blostefix.catalogo.models.Categoria;
import blostesoftware.blostefix.catalogo.models.Video;
import lombok.Data;

@Data
public class VideoPrivateDTO implements Serializable {
    static final long serialVersionUID = 1L;
    private Long id;
    private String titulo;
    private String autor;
    private String descripcion;
    private int duracion;
    private String idVideo;
    private LocalDateTime fechaSubida;
    private LocalDateTime fechaActualizacion;
    private boolean visible;
    private Set<Categoria> categorias;
    
    public static VideoPrivateDTO convertToDTO( Video video ){
        VideoPrivateDTO videoDTO = new VideoPrivateDTO();
        videoDTO.setId(video.getId());
        videoDTO.setTitulo(video.getTitulo());
        videoDTO.setAutor(video.getAutor());
        videoDTO.setDescripcion(video.getDescripcion());
        videoDTO.setDuracion(video.getDuracion());
        videoDTO.setIdVideo(video.getIdVideo());
        videoDTO.setFechaSubida(video.getFechaSubida());
        videoDTO.setFechaActualizacion(video.getFechaActualizacion());
        videoDTO.setVisible(video.isVisible());
        videoDTO.setCategorias(video.getCategorias());
        return videoDTO;
    }

    public static Video convertToEntity( VideoPrivateDTO videoDTO ){
        Video video = new Video();
        video.setId(videoDTO.getId());
        video.setTitulo(videoDTO.getTitulo());
        video.setAutor(videoDTO.getAutor());
        video.setDescripcion(videoDTO.getDescripcion());
        video.setDuracion(videoDTO.getDuracion());
        video.setIdVideo(videoDTO.getIdVideo());
        video.setFechaSubida(videoDTO.getFechaSubida());
        video.setFechaActualizacion(videoDTO.getFechaActualizacion());
        video.setVisible(videoDTO.isVisible());
        video.setCategorias(videoDTO.getCategorias());
        return video;
    }
}

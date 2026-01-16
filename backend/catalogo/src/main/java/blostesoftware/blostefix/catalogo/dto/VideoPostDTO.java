package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;

import blostesoftware.blostefix.catalogo.models.Video;
import lombok.Data;

@Data
public class VideoPostDTO implements Serializable{
    static final long serialVersionUID=1L;
    private String titulo;
    private String autor;
    private String descripcion;
    private int duracion;
    private String idVideo;
    private boolean visible;

    public static VideoPostDTO convertToDTO(String titulo, String autor, String descripcion, int duracion, String idVideo, boolean visible){
        VideoPostDTO videoDTO = new VideoPostDTO();
        videoDTO.setTitulo(titulo);
        videoDTO.setAutor(autor);
        videoDTO.setDescripcion(descripcion);
        videoDTO.setDuracion(duracion);
        videoDTO.setIdVideo(idVideo);
        videoDTO.setVisible(visible);
        return videoDTO;
    }

    public static Video convertToEntity(VideoPostDTO videoDTO){
        Video video = new Video();
        video.setTitulo(videoDTO.getTitulo());
        video.setAutor(videoDTO.getAutor());
        video.setDescripcion(videoDTO.getDescripcion());
        video.setDuracion(videoDTO.getDuracion());
        video.setIdVideo(videoDTO.getIdVideo());
        video.setVisible(videoDTO.isVisible());
        return video;
    }
}

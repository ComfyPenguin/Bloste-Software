package blostesoftware.blostefix.catalogo.dto;

import java.io.Serializable;
import java.util.Set;

import blostesoftware.blostefix.catalogo.models.Video;
import lombok.Data;

@Data
public class VideoPostDTO implements Serializable{
    static final long serialVersionUID=1L;
    private String titulo;
    private String autor;
    private String descripcion;
    private int duracion;
    private boolean visible;
    private String idVideo;
    private String urlVideo;
    private String urlImagen;
    // TODO: lista categorias?
    private Set<String> categorias;

        // Vamos a simplificar los convertTo, eliminando los que no se usan
/*     public static VideoPostDTO convertToDTO(String titulo, String autor, String descripcion, int duracion, boolean isVisible, String idVideo, String urlVideo, String urlImagen, Set<String> categorias){
        VideoPostDTO videoDTO = new VideoPostDTO();
        videoDTO.setTitulo(titulo);
        videoDTO.setAutor(autor);
        videoDTO.setDescripcion(descripcion);
        videoDTO.setDuracion(duracion);
        videoDTO.setVisible(isVisible);
        videoDTO.setIdVideo(idVideo);
        videoDTO.setUrlVideo(urlVideo);
        videoDTO.setUrlImagen(urlImagen);
        videoDTO.setCategorias(categorias);
        return videoDTO;
    } */

    public static Video convertToEntity(VideoPostDTO videoDTO){
        Video video = new Video();
        video.setTitulo(videoDTO.getTitulo());
        video.setAutor(videoDTO.getAutor());
        video.setDescripcion(videoDTO.getDescripcion());
        video.setDuracion(videoDTO.getDuracion());
        video.setVisible(videoDTO.isVisible());
        video.setIdVideo(videoDTO.getIdVideo());
        video.setUrlVideo(videoDTO.getUrlVideo());
        video.setUrlImagen(videoDTO.getUrlImagen());
        return video;
    }

}

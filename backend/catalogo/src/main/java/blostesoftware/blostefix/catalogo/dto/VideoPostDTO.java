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
    private Set<String> categorias;

    // Función de mapeo (Mapper): Convierte una entidad Video a un VideoPostDTO.
    // Extrae solo los nombres de las categorías (Set<String>) a partir de las entidades Categoria (Set<Categoria>).
    public static VideoPostDTO convertToDTO(Video v){
        VideoPostDTO videoDTO = new VideoPostDTO();
        videoDTO.setTitulo(v.getTitulo());
        videoDTO.setAutor(v.getAutor());
        videoDTO.setDescripcion(v.getDescripcion());
        videoDTO.setDuracion(v.getDuracion());
        videoDTO.setVisible(v.isVisible());
        videoDTO.setIdVideo(v.getIdVideo());
        videoDTO.setUrlVideo(v.getUrlVideo());
        videoDTO.setUrlImagen(v.getUrlImagen());
        // Mapeo de Set<Categoria> a Set<String> usando Streams.
        videoDTO.setCategorias(v.getCategorias().stream().map(c -> c.getNombre()).collect(java.util.stream.Collectors.toSet()));
        return videoDTO;
    }

    // Función de mapeo inversa: Convierte un DTO recibido del cliente a una entidad Video.
    // Nota: Las categorías no se mapean aquí porque requieren lógica de negocio (buscar en BD o crear nuevas),
    // lo cual se hace en el servicio (VideoServiceIMPL).
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

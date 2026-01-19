package blostesoftware.blostefix.catalogo.service;

import org.springframework.data.domain.Page;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

public interface VideoService {
    void saveVideo(VideoPostDTO videoDTO);

    Page<VideoPublicDTO> getVideos(Long categoriaID, int page, int size);

    VideoPublicDTO getVideoById(Long id);

    VideoPublicDTO updateVideo(Long id, VideoPostDTO videoDTO);

    //Page<VideoPublicDTO> getAllVideosPageable(int page, int size);

    //Page<VideoPublicDTO> getVideosByCategoriaPageable(int page, int size, Categoria categoria);

    boolean deleteVideo(Long id);
}

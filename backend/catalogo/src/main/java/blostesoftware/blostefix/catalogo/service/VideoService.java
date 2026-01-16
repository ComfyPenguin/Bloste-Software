package blostesoftware.blostefix.catalogo.service;

import org.springframework.data.domain.Page;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

public interface VideoService {
    void saveVideo(VideoPostDTO videoDTO);

    VideoPublicDTO getVideoById(Long id);

    VideoPublicDTO updateVideo(Long id, VideoPostDTO videoDTO);

    Page<VideoPublicDTO> getAllVideosPageable(int page, int size);

    boolean deleteVideo(Long id);
}

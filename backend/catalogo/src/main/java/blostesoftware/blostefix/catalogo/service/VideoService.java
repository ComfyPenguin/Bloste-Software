package blostesoftware.blostefix.catalogo.service;

import java.util.List;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

public interface VideoService {
    void saveVideo(VideoPostDTO videoDTO);

    VideoPublicDTO getVideoById(Long id);

    VideoPublicDTO updateVideo(Long id, VideoPostDTO videoDTO);

    List<VideoPublicDTO> getAllVideos();

    boolean deleteVideo(Long id);
}

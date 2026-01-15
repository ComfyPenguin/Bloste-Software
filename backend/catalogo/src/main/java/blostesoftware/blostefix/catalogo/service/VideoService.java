package blostesoftware.blostefix.catalogo.service;

import java.util.List;


import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

public interface VideoService {
    void saveVideo(VideoPublicDTO videoDTO);

    VideoPublicDTO getVideoById(Long id);

    //VideoPrivateDTO updateVideo();

    List<VideoPublicDTO> getAllVideos();

    void deleteVideo(Long id);
}

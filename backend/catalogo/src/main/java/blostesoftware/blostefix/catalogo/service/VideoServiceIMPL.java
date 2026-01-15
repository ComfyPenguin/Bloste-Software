package blostesoftware.blostefix.catalogo.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;
import blostesoftware.blostefix.catalogo.models.*;
import blostesoftware.blostefix.catalogo.repositories.VideoRepository;

@Service
public class VideoServiceIMPL implements VideoService {

    @Autowired
    private VideoRepository videoRepository;

    @Override
    public List<VideoPublicDTO> getAllVideos() {
        List<Video> videos = videoRepository.findAll();
        List<VideoPublicDTO> elsVideosDTO = new ArrayList<>();
        for (Video video : videos) {
            elsVideosDTO.add(VideoPublicDTO.converToDTO(video));
        }
        return elsVideosDTO;
    }

    @Override
    public void saveVideo(VideoPublicDTO videoDTO) {
        videoRepository.save(VideoPublicDTO.convertToEntity(videoDTO));
    }

    @Override
    public VideoPublicDTO getVideoById(Long id) {

        Optional<Video> videoOpt = videoRepository.findById(id);
        if (videoOpt.isPresent()) {
            return VideoPublicDTO.converToDTO(videoOpt.get());
        }
        return null;
    }

    /* @Override
    public VideoPublicDTO updateVideo(VideoPublicDTO videoDTO) {
        // TODO Auto-generated method stub
        return null;
    } */

    @Override
    public void deleteVideo(Long id) {
        videoRepository.deleteById(id);
    }
}


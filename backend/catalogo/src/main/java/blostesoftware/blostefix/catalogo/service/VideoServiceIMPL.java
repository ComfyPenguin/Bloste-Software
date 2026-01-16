package blostesoftware.blostefix.catalogo.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
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
    public void saveVideo(VideoPostDTO videoDTO) {
        videoRepository.save(VideoPostDTO.convertToEntity(videoDTO));
    }

    @Override
    public VideoPublicDTO getVideoById(Long id) {

        Optional<Video> videoOpt = videoRepository.findById(id);
        if (videoOpt.isPresent()) {
            return VideoPublicDTO.converToDTO(videoOpt.get());
        }
        return null;
    }

    @Override
    public VideoPublicDTO updateVideo(Long id, VideoPostDTO videoDTO) {
        Optional<Video> videoOpt = videoRepository.findById(id);
        if (videoOpt.isPresent()) {
            Video video = videoOpt.get();
            video.setTitulo(videoDTO.getTitulo());
            video.setAutor(videoDTO.getAutor());
            video.setDescripcion(videoDTO.getDescripcion());
            video.setDuracion(videoDTO.getDuracion());
            video.setIdVideo(videoDTO.getIdVideo());
            video.setVisible(videoDTO.isVisible());
            videoRepository.save(video);
            return VideoPublicDTO.converToDTO(video);
        }
        return null;
    }

    @Override
    public boolean deleteVideo(Long id) {
        if (videoRepository.existsById(id)) {
            videoRepository.deleteById(id);
            return true;
        }
        return false;
    }
}


package blostesoftware.blostefix.catalogo.service;

import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;
import blostesoftware.blostefix.catalogo.models.*;
import blostesoftware.blostefix.catalogo.repositories.CategoriaRepository;
import blostesoftware.blostefix.catalogo.repositories.VideoRepository;

@Service
public class VideoServiceIMPL implements VideoService {

    @Autowired
    private VideoRepository videoRepository;
    @Autowired
    private CategoriaRepository categoriaRepository;

    @Override

    public Page<VideoPublicDTO> getVideos(Long categoriaId, int page, int size){
        Pageable pageable = PageRequest.of(page,size,Sort.by("id").descending());

        Page<Video> result; 

        if(categoriaId != null ){
            result = videoRepository.findByCategorias_Id(categoriaId, pageable);
        } else {
            result = videoRepository.findAll(pageable);
        }
        return new PageImpl<>(result.getContent().stream().map(VideoPublicDTO::converToDTO).toList(),pageable,result.getTotalElements());
    }

    /* @Override
    public Page<VideoPublicDTO> getAllVideosPageable(int page, int size) {
        PageRequest pageable = PageRequest.of(page, size, Sort.by("id").descending());
        Page<Video> videosPage = videoRepository.findAll(pageable);
        return new PageImpl<>(videosPage.getContent().stream().map(VideoPublicDTO::converToDTO).toList(), pageable, videosPage.getTotalElements());
    } */

    /* @Override
    public Page<VideoPublicDTO> getVideosByCategoriaPageable(int page , int size, Categoria categoria){
        PageRequest pageable = PageRequest.of(page, size, Sort)
    } */

    @Override
    public void saveVideo(VideoPostDTO dto) {
        Video video = VideoPostDTO.convertToEntity(dto);
        Set<Categoria> categorias = dto.getCategorias().stream()
        .map(nombre -> {
            String normalizado = nombre.trim().toLowerCase();

            return categoriaRepository
                .findByNombre(normalizado)
                .orElseGet(() -> {
                    Categoria nueva = new Categoria();
                    nueva.setNombre(normalizado);
                    return categoriaRepository.save(nueva);
                });
        })
        .collect(Collectors.toSet());

    video.setCategorias(categorias);

    videoRepository.save(video);
        
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


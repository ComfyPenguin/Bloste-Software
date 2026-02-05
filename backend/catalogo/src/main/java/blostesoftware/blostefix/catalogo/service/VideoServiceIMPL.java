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
import jakarta.persistence.EntityNotFoundException;

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
    public VideoPostDTO updateVideo(Long id, VideoPostDTO videoDTO) {
        Video video = videoRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Video no encontrado"));

        // Actualizar campos básicos
        video.setTitulo(videoDTO.getTitulo());
        video.setAutor(videoDTO.getAutor());
        video.setDescripcion(videoDTO.getDescripcion());
        video.setDuracion(videoDTO.getDuracion());
        video.setVisible(videoDTO.isVisible());

        // Actualizar categorías si están presentes en el DTO
        if (videoDTO.getCategorias() != null && !videoDTO.getCategorias().isEmpty()) {
            Set<Categoria> categorias = videoDTO.getCategorias().stream()
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
        }

        // NO actualizar: idVideo, urlVideo, urlImagen (son generados por el sistema)

        videoRepository.save(video);
        return VideoPostDTO.convertToDTO(video);
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


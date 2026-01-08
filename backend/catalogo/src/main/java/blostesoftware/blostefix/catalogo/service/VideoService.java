package blostesoftware.blostefix.catalogo.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.VideoRequest;
import blostesoftware.blostefix.catalogo.dto.VideoResponse;
import blostesoftware.blostefix.catalogo.models.*;
import blostesoftware.blostefix.catalogo.repositories.CategoriaRepository;
import blostesoftware.blostefix.catalogo.repositories.VideoRepository;

@Service
public class VideoService {

    private final VideoRepository videoRepository;
    private final CategoriaRepository categoriaRepository;

    public VideoService(VideoRepository videoRepository, CategoriaRepository categoriaRepository) {
        this.videoRepository = videoRepository;
        this.categoriaRepository = categoriaRepository;
    }

    // Crear video
    public VideoResponse createVideo(VideoRequest request) {
        Video video = new Video();
        video.setTitulo(request.titulo);
        video.setAutor(request.autor);
        video.setDescripcion(request.descripcion);
        video.setDuracion(request.duracion);
        video.setUrlVideo(request.url);
        video.setUrlImagen(request.urlImg);
        video.setVisible(true);

        List<Categoria> categorias = request.categoriaIds.stream()
                .map(id -> categoriaRepository.findById(id)
                        .orElseThrow(() -> new RuntimeException("Categoria no encontrada: " + id)))
                .collect(Collectors.toList());

        video.setCategorias(categorias);
        Video saved = videoRepository.save(video);
        return toResponse(saved);
    }

    // Actualizar video
    public VideoResponse updateVideo(int id, VideoRequest request) {
        Video video = videoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Video no encontrado"));
        
        video.setTitulo(request.titulo);
        video.setAutor(request.autor);
        video.setDescripcion(request.descripcion);
        video.setDuracion(request.duracion);
        video.setUrlVideo(request.url);
        video.setUrlImagen(request.urlImg);

        List<Categoria> categorias = request.categoriaIds.stream()
                .map(categoriaId -> categoriaRepository.findById(categoriaId)
                        .orElseThrow(() -> new RuntimeException("Categoria no encontrada: " + categoriaId)))
                .collect(Collectors.toList());

        video.setCategorias(categorias);
        Video updated = videoRepository.save(video);
        return toResponse(updated);
    }

    // Listar todos los videos
    public List<VideoResponse> getAllVideos() {
        return videoRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // Obtener video por id
    public VideoResponse getVideoById(int id) {
        return videoRepository.findById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new RuntimeException("Video no encontrado"));
    }

    // Eliminar video
    public void deleteVideo(int id) {
        if (!videoRepository.existsById(id)) {
            throw new RuntimeException("Video no encontrado");
        }
        videoRepository.deleteById(id);
    }

    private VideoResponse toResponse(Video video) {
        VideoResponse dto = new VideoResponse();
        dto.id = video.getId();
        dto.titulo = video.getTitulo();
        dto.descripcion = video.getDescripcion();
        dto.url = video.getUrlVideo();
        dto.fechaSubida = video.getFechaSubida();
        dto.fechaActualizacion = video.getFechaActualizacion();
        dto.categorias = video.getCategorias().stream()
                .map(Categoria::getNombre)
                .collect(Collectors.toSet());
        return dto;
    }
}


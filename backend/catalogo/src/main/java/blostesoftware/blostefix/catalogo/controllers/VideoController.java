package blostesoftware.blostefix.catalogo.controllers;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import blostesoftware.blostefix.catalogo.dto.VideoRequest;
import blostesoftware.blostefix.catalogo.dto.VideoResponse;
import blostesoftware.blostefix.catalogo.service.VideoService;

@RestController
@RequestMapping("/api/videos")
public class VideoController {

    private final VideoService videoService;

    public VideoController(VideoService videoService) {
        this.videoService = videoService;
    }

    // POST - Crear un nuevo video
    @PostMapping
    public ResponseEntity<VideoResponse> createVideo(@RequestBody VideoRequest request) {
        VideoResponse response = videoService.createVideo(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // GET - Obtener todos los videos
    @GetMapping
    public ResponseEntity<List<VideoResponse>> getAllVideos() {
        List<VideoResponse> videos = videoService.getAllVideos();
        return ResponseEntity.ok(videos);
    }

    // GET - Obtener un video por ID
    @GetMapping("/{id}")
    public ResponseEntity<VideoResponse> getVideoById(@PathVariable int id) {
        VideoResponse video = videoService.getVideoById(id);
        return ResponseEntity.ok(video);
    }

    // PUT - Actualizar un video
    @PutMapping("/{id}")
    public ResponseEntity<VideoResponse> updateVideo(
            @PathVariable int id,
            @RequestBody VideoRequest request) {
        VideoResponse response = videoService.updateVideo(id, request);
        return ResponseEntity.ok(response);
    }

    // DELETE - Eliminar un video
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVideo(@PathVariable int id) {
        videoService.deleteVideo(id);
        return ResponseEntity.noContent().build();
    }
}

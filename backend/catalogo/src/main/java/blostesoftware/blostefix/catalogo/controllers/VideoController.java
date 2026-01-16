package blostesoftware.blostefix.catalogo.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

import blostesoftware.blostefix.catalogo.service.VideoServiceIMPL;

@RestController
@RequestMapping("/api")
public class VideoController {

    @Autowired
    VideoServiceIMPL videoService;

    @GetMapping("/catalogo")
    public ResponseEntity<List<VideoPublicDTO>> getAllVideos() {
        return ResponseEntity.ok(videoService.getAllVideos());
    }

    @GetMapping("/catalogo/{id}")
    public ResponseEntity<VideoPublicDTO> getVideoById(@PathVariable Long id) {
        VideoPublicDTO video = videoService.getVideoById(id);
        if (video != null) {
            return ResponseEntity.ok(video);
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/catalogo")
    public ResponseEntity<Void> saveVideo(@RequestBody VideoPostDTO videoDTO) {
        videoService.saveVideo(videoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PutMapping("/catalogo/{id}")
    public ResponseEntity<VideoPublicDTO> updateVideo(
            @PathVariable Long id,
            @RequestBody VideoPostDTO videoDTO) {
        VideoPublicDTO videoActualizado = videoService.updateVideo(id, videoDTO);
        if (videoActualizado != null) {
            return ResponseEntity.ok(videoActualizado);
        }
        return ResponseEntity.notFound().build();
    }

    @DeleteMapping("/catalogo/{id}")
    public ResponseEntity<Void> deleteVideo(@PathVariable Long id) {
        if (videoService.deleteVideo(id)) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<String> handleError(MethodArgumentTypeMismatchException e) {
        String message = String.format("El format de l'argument no és correcte: %s", e.getName());
        return new ResponseEntity<>(message, HttpStatus.BAD_REQUEST);
    }
}

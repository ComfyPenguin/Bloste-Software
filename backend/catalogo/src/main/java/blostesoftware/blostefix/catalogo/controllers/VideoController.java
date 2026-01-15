package blostesoftware.blostefix.catalogo.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

import blostesoftware.blostefix.catalogo.service.VideoServiceIMPL;

@RestController
@RequestMapping("/api")
public class VideoController {

    @Autowired
    VideoServiceIMPL videoService;

    @GetMapping("/catalogo")
    public List<VideoPublicDTO> getAllVideos() {
        return videoService.getAllVideos();
    }

    @GetMapping("/catalogo/{id}")
    public VideoPublicDTO getVideoById(@PathVariable Long id) {
        return videoService.getVideoById(id);
    }

    @PostMapping("/catalogo/newvideo")
    public void saveVideo(VideoPublicDTO videoDTO) {
        videoService.saveVideo(videoDTO);
    }

     @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<String> handleError(MethodArgumentTypeMismatchException e) {
        //myLog.warn("Method Argument Type Mismatch", e);
        String message = String.format("El format de l'argument no és correcte: %s", e.getName());
        return new ResponseEntity<>(message,HttpStatus.BAD_REQUEST);
    }
}

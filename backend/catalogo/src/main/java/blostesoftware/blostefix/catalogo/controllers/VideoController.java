package blostesoftware.blostefix.catalogo.controllers;



import org.springframework.data.domain.Page;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import blostesoftware.blostefix.catalogo.dto.VideoPostDTO;
import blostesoftware.blostefix.catalogo.dto.VideoPublicDTO;

import blostesoftware.blostefix.catalogo.service.VideoServiceIMPL;

@RestController // Indica que esta clase es un controlador REST. Spring se encarga de serializar las respuestas a JSON automáticamente.
@RequestMapping("/api") // Define la ruta base para todos los endpoints de este controlador.
public class VideoController {

    @Autowired // Inyección de dependencias: Spring proporciona automáticamente una instancia de VideoServiceIMPL.
    VideoServiceIMPL videoService;

    // Endpoint GET para obtener una lista paginada de videos.
    // @RequestParam permite recibir parámetros en la URL (ej. /api/catalogo?page=0&size=20).
    @GetMapping("/catalogo")
    public ResponseEntity<Page<VideoPublicDTO>> getAllVideos(
            @RequestParam(required = false) Long categoriaId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<VideoPublicDTO> videos = videoService.getVideos(categoriaId,page, size);
        return ResponseEntity.ok(videos); // Retorna un código 200 OK con el cuerpo de la respuesta.
    }

    // Endpoint GET para buscar videos por título.
    @GetMapping("/catalogo/search")
    public ResponseEntity<Page<VideoPublicDTO>> searchVideos(
            @RequestParam String titulo,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<VideoPublicDTO> videos = videoService.searchVideosByTitulo(titulo, page, size);
        return ResponseEntity.ok(videos);
    }

    // Endpoint GET para obtener un video específico por su ID.
    // @PathVariable extrae el valor de la URL (ej. /api/catalogo/1 -> id = 1).
    @GetMapping("/catalogo/{id}")
    public ResponseEntity<VideoPublicDTO> getVideoById(@PathVariable Long id) {
        VideoPublicDTO video = videoService.getVideoById(id);
        if (video != null) {
            return ResponseEntity.ok(video);
        }
        return ResponseEntity.notFound().build(); // Retorna un código 404 Not Found si no existe.
    }

    // Endpoint POST para crear un nuevo video.
    // @RequestBody mapea el cuerpo de la petición HTTP (JSON) al objeto VideoPostDTO.
    @PostMapping("/catalogo")
    public ResponseEntity<Void> saveVideo(@RequestBody VideoPostDTO videoDTO) {
        videoService.saveVideo(videoDTO);
        return ResponseEntity.status(HttpStatus.CREATED).build(); // Retorna un código 201 Created.
    }

    // Endpoint PUT para actualizar un video existente.
    @PutMapping("/catalogo/{id}")
    public ResponseEntity<VideoPostDTO> updateVideo(
            @PathVariable Long id,
            @RequestBody VideoPostDTO videoDTO) {
        try {
            VideoPostDTO videoActualizado = videoService.updateVideo(id, videoDTO);
            return ResponseEntity.ok(videoActualizado);
        } catch (jakarta.persistence.EntityNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Endpoint DELETE para eliminar un video.
    @DeleteMapping("/catalogo/{id}")
    public ResponseEntity<Void> deleteVideo(@PathVariable Long id) {
        if (videoService.deleteVideo(id)) {
            return ResponseEntity.noContent().build(); // Retorna un código 204 No Content si se eliminó con éxito.
        }
        return ResponseEntity.notFound().build();
    }

    // Manejador de excepciones global para este controlador.
    // Captura errores de tipo de argumento (ej. pasar una letra donde se espera un número).
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<String> handleError(MethodArgumentTypeMismatchException e) {
        String message = String.format("El format de l'argument no és correcte: %s", e.getName());
        return new ResponseEntity<>(message, HttpStatus.BAD_REQUEST); // Retorna un código 400 Bad Request.
    }
}

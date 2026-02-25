package blostesoftware.blostefix.catalogo.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
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
import org.springframework.web.bind.annotation.RestControllerAdvice;

import blostesoftware.blostefix.catalogo.dto.CategoriaPostDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.service.CategoriaServiceIMPL;
import blostesoftware.blostefix.exceptions.CategoriaAlreadyExistsException;

@RestController // Controlador REST: Combina @Controller y @ResponseBody.
@RequestMapping("/api") // Ruta base para los endpoints de categorías.
public class CategoriaController {
    @Autowired
    CategoriaServiceIMPL categoriaService;
    
    // Get con paginacion
    // Ejemplo de endpoint REST para obtener recursos (Categorías).
    @GetMapping("/categorias")
    public ResponseEntity<Page<CategoriaPublicDTO>> getAllCategoriasPageable(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        Page<CategoriaPublicDTO> categorias = categoriaService.getAllCategoriasPageable(page, size);
        return ResponseEntity.ok(categorias);
    }
    
    //Get por id
    // @PathVariable vincula el {id} de la URL al parámetro del método.
    @GetMapping("/categorias/{id}")
    public ResponseEntity<CategoriaPublicDTO> getCategoriaById(@PathVariable Long id) {
        CategoriaPublicDTO categoria = categoriaService.getCategoriaById(id);
        if (categoria != null) {
            return ResponseEntity.ok(categoria);
        }
        return ResponseEntity.notFound().build(); // 404 si no se encuentra.
    }
    
    // Post de una nueva categoria
    // @RequestBody deserializa el JSON entrante a un objeto Java (CategoriaPostDTO).
    @PostMapping("/categorias")
    public ResponseEntity<Void> createCategoria(@RequestBody CategoriaPostDTO categoriaDTO) {
        categoriaService.saveCategoria(categoriaDTO);
        return ResponseEntity.status(HttpStatus.CREATED).build(); // 201 Created.
    }
    
    // Put, modificar
    // Actualiza un recurso existente.
    @PutMapping("/categorias/{id}")
    public ResponseEntity<CategoriaPrivateDTO> updateCategoria(
            @PathVariable Long id,
            @RequestBody CategoriaPrivateDTO categoriaDTO) {
        categoriaDTO.setId(id);
        CategoriaPrivateDTO categoriaActualizada = categoriaService.updateCategoria(categoriaDTO);
        if (categoriaActualizada != null) {
            return ResponseEntity.ok(categoriaActualizada);
        }
        return ResponseEntity.notFound().build();
    }
    
    // Borrar por id
    @DeleteMapping("/categorias/{id}")
    public ResponseEntity<Void> deleteCategoria(@PathVariable Long id) {
        CategoriaPrivateDTO categoriaEliminada = categoriaService.deleteCategoria(id);
        if (categoriaEliminada != null) {
            return ResponseEntity.noContent().build(); // 204 No Content.
        }
        return ResponseEntity.notFound().build();
    }

    // @RestControllerAdvice permite manejar excepciones globalmente para todos los controladores.
    @RestControllerAdvice
    public class GlobalExceptionHandler {

        // Captura la excepción personalizada CategoriaAlreadyExistsException.
        @ExceptionHandler(CategoriaAlreadyExistsException.class)
        public ResponseEntity<String> handleCategoriaDuplicada(
                CategoriaAlreadyExistsException ex) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT) // 409 Conflict.
                    .body(ex.getMessage());
        }

        // Captura excepciones de integridad de datos (ej. violación de restricción UNIQUE en BD).
        @ExceptionHandler(DataIntegrityViolationException.class)
        public ResponseEntity<String> handleConstraint(
                DataIntegrityViolationException ex) {
            return ResponseEntity
                    .status(HttpStatus.CONFLICT)
                    .body("La categoría ya existe");
        }
    }
}

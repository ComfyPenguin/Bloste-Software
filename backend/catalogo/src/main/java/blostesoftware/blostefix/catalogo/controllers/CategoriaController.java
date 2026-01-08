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

import blostesoftware.blostefix.catalogo.dto.CategoriaRequest;
import blostesoftware.blostefix.catalogo.dto.CategoriaResponse;
import blostesoftware.blostefix.catalogo.service.CategoriaService;

@RestController
@RequestMapping("/api/categorias")
public class CategoriaController {

    private final CategoriaService categoriaService;

    public CategoriaController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    // POST - Crear una nueva categoria
    @PostMapping
    public ResponseEntity<CategoriaResponse> createCategoria(@RequestBody CategoriaRequest request) {
        CategoriaResponse response = categoriaService.createCategoria(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    // GET - Obtener todas las categorias
    @GetMapping
    public ResponseEntity<List<CategoriaResponse>> getAllCategorias() {
        List<CategoriaResponse> categorias = categoriaService.getAllCategorias();
        return ResponseEntity.ok(categorias);
    }

    // GET - Obtener una categoria por ID
    @GetMapping("/{id}")
    public ResponseEntity<CategoriaResponse> getCategoriaById(@PathVariable int id) {
        CategoriaResponse categoria = categoriaService.getCategoriaById(id);
        return ResponseEntity.ok(categoria);
    }

    // PUT - Actualizar una categoria
    @PutMapping("/{id}")
    public ResponseEntity<CategoriaResponse> updateCategoria(
            @PathVariable int id,
            @RequestBody CategoriaRequest request) {
        CategoriaResponse response = categoriaService.updateCategoria(id, request);
        return ResponseEntity.ok(response);
    }

    // DELETE - Eliminar una categoria
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCategoria(@PathVariable int id) {
        categoriaService.deleteCategoria(id);
        return ResponseEntity.noContent().build();
    }
}

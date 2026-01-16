package blostesoftware.blostefix.catalogo.controllers;

import org.springframework.beans.factory.annotation.Autowired;
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

import blostesoftware.blostefix.catalogo.dto.CategoriaPostDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPrivateDTO;
import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.service.CategoriaServiceIMPL;

@RestController
@RequestMapping("/api")
public class CategoriaController {
    @Autowired
    CategoriaServiceIMPL categoriaService;

    @GetMapping("/categorias")
    public ResponseEntity<java.util.List<CategoriaPublicDTO>> getAllCategorias() {
        return ResponseEntity.ok(categoriaService.getAllCategorias());
    }

    @GetMapping("/categorias/{id}")
    public ResponseEntity<CategoriaPublicDTO> getCategoriaById(@PathVariable Long id) {
        CategoriaPublicDTO categoria = categoriaService.getCategoriaById(id);
        if (categoria != null) {
            return ResponseEntity.ok(categoria);
        }
        return ResponseEntity.notFound().build();
    }

    @PostMapping("/categorias")
    public ResponseEntity<Void> createCategoria(@RequestBody CategoriaPostDTO categoriaDTO) {
        categoriaService.saveCategoria(CategoriaPostDTO.convertToEntity(categoriaDTO));
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

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

    @DeleteMapping("/categorias/{id}")
    public ResponseEntity<Void> deleteCategoria(@PathVariable Long id) {
        CategoriaPrivateDTO categoriaEliminada = categoriaService.deleteCategoria(id);
        if (categoriaEliminada != null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}

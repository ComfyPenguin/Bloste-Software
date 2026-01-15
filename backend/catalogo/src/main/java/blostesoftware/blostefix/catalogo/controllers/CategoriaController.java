package blostesoftware.blostefix.catalogo.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import blostesoftware.blostefix.catalogo.dto.CategoriaPublicDTO;
import blostesoftware.blostefix.catalogo.service.CategoriaServiceIMPL;

@RestController
@RequestMapping("/api")
public class CategoriaController {
    @Autowired
    CategoriaServiceIMPL categoriaService;

    @GetMapping("/categorias")
    public java.util.List<CategoriaPublicDTO> getAllCategorias() {
        return categoriaService.getAllCategorias();
    }

    @GetMapping("/categorias/{id}")
    public CategoriaPublicDTO getCategoriaById(@PathVariable Long id) {
        return categoriaService.getCategoriaById(id);
    }
}

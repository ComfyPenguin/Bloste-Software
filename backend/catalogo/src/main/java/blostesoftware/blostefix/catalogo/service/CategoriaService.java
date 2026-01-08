package blostesoftware.blostefix.catalogo.service;

import java.util.List;
import org.springframework.stereotype.Service;

import blostesoftware.blostefix.catalogo.dto.CategoriaRequest;
import blostesoftware.blostefix.catalogo.dto.CategoriaResponse;
import blostesoftware.blostefix.catalogo.models.Categoria;
import blostesoftware.blostefix.catalogo.repositories.CategoriaRepository;

@Service
public class CategoriaService {
    private final CategoriaRepository categoriaRepository;

    public CategoriaService(CategoriaRepository categoriaRepository) {
        this.categoriaRepository = categoriaRepository;
    }

    // Crear categoria
    public CategoriaResponse createCategoria(CategoriaRequest request) {
        Categoria categoria = new Categoria();
        categoria.setNombre(request.nombre);
        categoria.setDescripcion(request.descripcion);
        
        Categoria saved = categoriaRepository.save(categoria);
        return toResponse(saved);
    }

    // Obtener todas las categorias
    public List<CategoriaResponse> getAllCategorias() {
        return categoriaRepository.findAll()
                .stream()
                .map(this::toResponse)
                .toList();
    }

    // Obtener categoria por id
    public CategoriaResponse getCategoriaById(int id) {
        return categoriaRepository.findById((int) id)
                .map(this::toResponse)
                .orElseThrow(() -> new RuntimeException("Categoria no encontrada"));
    }

    // Actualizar categoria
    public CategoriaResponse updateCategoria(int id, CategoriaRequest request) {
        Categoria categoria = categoriaRepository.findById((int) id)
                .orElseThrow(() -> new RuntimeException("Categoria no encontrada"));
        
        categoria.setNombre(request.nombre);
        categoria.setDescripcion(request.descripcion);
        
        Categoria updated = categoriaRepository.save(categoria);
        return toResponse(updated);
    }

    // Eliminar categoria
    public void deleteCategoria(int id) {
        if (!categoriaRepository.existsById((int) id)) {
            throw new RuntimeException("Categoria no encontrada");
        }
        categoriaRepository.deleteById((int) id);
    }

    private CategoriaResponse toResponse(Categoria categoria) {
        CategoriaResponse dto = new CategoriaResponse();
        dto.id = categoria.getId();
        dto.nombre = categoria.getNombre();
        dto.descripcion = categoria.getDescripcion();
        return dto;
    }
}

package blostesoftware.blostefix.catalogo.repositories;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import blostesoftware.blostefix.catalogo.models.Video;

import java.util.Optional;

public interface VideoRepository extends JpaRepository<Video, Long> {
    
    // Spring Data JPA genera automáticamente la consulta SQL basada en el nombre del método.
    // Busca videos que pertenezcan a una categoría específica y devuelve resultados paginados.
     Page<Video> findByCategorias_Id(
        Long categoriaId,
        Pageable pageable
    );
    
    // Busca todos los videos que tengan el campo 'visible' a true.
    Page<Video> findByVisibleTrue(Pageable pageable);
    
    // Combina dos condiciones: pertenecer a una categoría y ser visible.
    Page<Video> findByCategorias_IdAndVisibleTrue(
        Long categoriaId,
        Pageable pageable
    );
    
    Optional<Video> findByIdAndVisibleTrue(Long id);
    
    // @Query permite definir consultas JPQL (Java Persistence Query Language) personalizadas.
    // Aquí se busca por título ignorando mayúsculas/minúsculas (LOWER) y usando LIKE para coincidencias parciales.
    @Query("SELECT v FROM Video v WHERE LOWER(v.titulo) LIKE LOWER(CONCAT('%', :titulo, '%'))")
    Page<Video> searchByTitulo(@Param("titulo") String titulo, Pageable pageable);
    
    // Consulta JPQL personalizada que además filtra por videos visibles.
    @Query("SELECT v FROM Video v WHERE LOWER(v.titulo) LIKE LOWER(CONCAT('%', :titulo, '%')) AND v.visible = true")
    Page<Video> searchByTituloAndVisibleTrue(@Param("titulo") String titulo, Pageable pageable);
}

package blostesoftware.blostefix.catalogo.repositories;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;

import blostesoftware.blostefix.catalogo.models.Video;

import java.util.Optional;

public interface VideoRepository extends JpaRepository<Video, Long> {
     Page<Video> findByCategorias_Id(
        Long categoriaId,
        Pageable pageable
    );
    
    Page<Video> findByVisibleTrue(Pageable pageable);
    
    Page<Video> findByCategorias_IdAndVisibleTrue(
        Long categoriaId,
        Pageable pageable
    );
    
    Optional<Video> findByIdAndVisibleTrue(Long id);
}

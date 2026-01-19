package blostesoftware.blostefix.catalogo.repositories;

import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;

import blostesoftware.blostefix.catalogo.models.Video;

public interface VideoRepository extends JpaRepository<Video, Long> {
     Page<Video> findByCategorias_Id(
        Long categoriaId,
        Pageable pageable
    );
}

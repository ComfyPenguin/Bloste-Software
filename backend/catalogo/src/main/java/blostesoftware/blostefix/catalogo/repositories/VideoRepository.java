package blostesoftware.blostefix.catalogo.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import blostesoftware.blostefix.catalogo.models.Video;

public interface VideoRepository extends JpaRepository<Video, Integer> {
   
}

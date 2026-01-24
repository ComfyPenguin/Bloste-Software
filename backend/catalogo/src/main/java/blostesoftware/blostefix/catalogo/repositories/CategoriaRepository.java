package blostesoftware.blostefix.catalogo.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import blostesoftware.blostefix.catalogo.models.Categoria;

public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    boolean existsByNombreIgnoreCase(String nombre);
    Optional<Categoria> findByNombre(String nombre);
}

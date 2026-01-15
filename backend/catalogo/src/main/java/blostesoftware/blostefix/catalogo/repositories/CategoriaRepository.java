package blostesoftware.blostefix.catalogo.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import blostesoftware.blostefix.catalogo.models.Categoria;

public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
}

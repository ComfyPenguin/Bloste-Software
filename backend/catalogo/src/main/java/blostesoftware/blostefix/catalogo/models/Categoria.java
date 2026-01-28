package blostesoftware.blostefix.catalogo.models;

import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.annotations.NaturalId;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@ToString
@Getter
@Setter

@Table( name = "categoria",
uniqueConstraints = {@UniqueConstraint(columnNames = "nombre")}
)
public class Categoria implements Serializable {
    @Serial
    private static final Long serialVersionUID=1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @NaturalId
    @Column(nullable = false)
    private String nombre;
    @ManyToMany( mappedBy = "categorias" , fetch = FetchType.LAZY)
    @JsonBackReference
    private List<Video> videos = new ArrayList<>();
}

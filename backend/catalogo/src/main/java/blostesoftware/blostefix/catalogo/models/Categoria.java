package blostesoftware.blostefix.catalogo.models;

import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToMany;
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

public class Categoria implements Serializable {
    @Serial
    private static final Long serialVersionUID=1L;
    @Id
    private int id;
    private String nombre;
    private String descripcion;
    @ManyToMany( mappedBy = "categorias" , fetch = FetchType.LAZY)
    private List<Video> videos = new ArrayList<>();
}

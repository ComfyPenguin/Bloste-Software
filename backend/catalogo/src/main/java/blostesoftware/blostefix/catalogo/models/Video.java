package blostesoftware.blostefix.catalogo.models;

import java.io.Serial;
import java.io.Serializable;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.PrePersist;
import jakarta.persistence.PreUpdate;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Entity
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Table( name = "videos")
public class Video implements Serializable{
    @Serial
    private static final long serialVersionUID=1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String titulo;
    private String autor;
    private String descripcion;
    private int duracion;
    private String idVideo;
    private String urlVideo;
    private String urlImagen;
    private LocalDate fechaSubida;
    private LocalDate fechaActualizacion;
    private boolean visible;

    @PrePersist
    protected void onCreate() {
        fechaSubida = LocalDate.now();
        fechaActualizacion = LocalDate.now();
    }

    @PreUpdate
    protected void onUpdate() {
        fechaActualizacion = LocalDate.now();
    }

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "video_categoria",
        joinColumns = @JoinColumn(name = "video_id"),
        inverseJoinColumns = @JoinColumn(name = "categoria_id")
    )
    private Set<Categoria> categorias = new HashSet<>();
}

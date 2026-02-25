package blostesoftware.blostefix.catalogo.config;

import blostesoftware.blostefix.catalogo.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.http.HttpMethod;

@Configuration // Indica que esta clase contiene configuración de beans para el contexto de Spring.
@EnableWebSecurity // Habilita la seguridad web de Spring Security en la aplicación.
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    // Configura la cadena de filtros de seguridad (SecurityFilterChain).
    // Define cómo se protegen las rutas y qué políticas de sesión se utilizan.
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Deshabilita CSRF (Cross-Site Request Forgery) ya que usamos tokens JWT (stateless).
                .cors(cors -> cors.configure(http)) // Configura CORS para permitir peticiones desde otros dominios (ej. frontend).
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)) // Política sin estado: no se guardan sesiones en el servidor.
                .authorizeHttpRequests(authz -> authz
                        // Permite todas las peticiones OPTIONS (preflight de CORS).
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()
                        // Permite acceso público (sin autenticación) a las peticiones GET de la API.
                        .requestMatchers(HttpMethod.GET, "/api/**").permitAll()
                        // Restringe las peticiones POST, PUT y DELETE solo a usuarios con el rol ADMIN.
                        .requestMatchers(HttpMethod.POST, "/api/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.PUT, "/api/**").hasRole("ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/**").hasRole("ADMIN")
                        // Cualquier otra petición requiere estar autenticado.
                        .anyRequest().authenticated()
                )
                // Añade nuestro filtro personalizado de JWT antes del filtro estándar de usuario/contraseña.
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}

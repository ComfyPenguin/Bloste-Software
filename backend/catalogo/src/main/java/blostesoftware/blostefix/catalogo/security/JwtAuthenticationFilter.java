package blostesoftware.blostefix.catalogo.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;

@Component // Registra este filtro como un bean de Spring para que pueda ser inyectado en SecurityConfig.
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    // Este método se ejecuta una vez por cada petición HTTP entrante.
    // Su propósito es interceptar la petición, extraer el token JWT, validarlo y establecer el contexto de seguridad.
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        // Extrae el encabezado 'Authorization' de la petición HTTP.
        String authHeader = request.getHeader("Authorization");
        System.out.println("DEBUG JWT Filter: Authorization header: " + authHeader);

        // Comprueba si el encabezado existe y comienza con "Bearer " (estándar para tokens JWT).
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7); // Extrae el token eliminando el prefijo "Bearer ".
            System.out.println("DEBUG JWT Filter: Token extracted");

            try {
                // Valida el token y extrae los "claims" (datos contenidos en el payload del JWT).
                Claims claims = jwtTokenProvider.validateAndGetClaims(token);

                String userId = claims.getSubject();
                String role = claims.get("role", String.class);
                
                System.out.println("DEBUG JWT Filter: UserId: " + userId + ", Role: " + role);

                // Create authority with ROLE_ prefix for Spring Security
                // Spring Security espera que los roles tengan el prefijo "ROLE_" por defecto.
                SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + (role != null ? role.toUpperCase() : "USER"));

                // Create authentication token
                // Crea un objeto de autenticación con el ID del usuario y sus roles/autoridades.
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(userId, null, Collections.singletonList(authority));

                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // Set authentication in SecurityContext
                // Establece la autenticación en el contexto de seguridad de Spring.
                // A partir de aquí, Spring sabe quién es el usuario y qué roles tiene para esta petición.
                SecurityContextHolder.getContext().setAuthentication(authentication);
                
                System.out.println("DEBUG JWT Filter: Authentication set in context with authorities: " + authentication.getAuthorities());

            } catch (ExpiredJwtException e) {
                logger.warn("JWT token has expired: " + e.getMessage());
                System.out.println("DEBUG JWT Filter: Token expired - proceeding with anonymous access");
            } catch (Exception e) {
                logger.error("JWT validation failed: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("DEBUG JWT Filter: No Bearer token found");
        }

        // Continúa con la cadena de filtros (pasa la petición al siguiente filtro o al controlador).
        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        // Apply filter to ALL requests to extract JWT from header
        return false;
    }
}

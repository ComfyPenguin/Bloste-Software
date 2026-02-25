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

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProvider jwtTokenProvider;

    public JwtAuthenticationFilter(JwtTokenProvider jwtTokenProvider) {
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String authHeader = request.getHeader("Authorization");
        System.out.println("DEBUG JWT Filter: Authorization header: " + authHeader);

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            String token = authHeader.substring(7);
            System.out.println("DEBUG JWT Filter: Token extracted");

            try {
                Claims claims = jwtTokenProvider.validateAndGetClaims(token);

                String userId = claims.getSubject();
                String role = claims.get("role", String.class);
                
                System.out.println("DEBUG JWT Filter: UserId: " + userId + ", Role: " + role);

                // Create authority with ROLE_ prefix for Spring Security
                SimpleGrantedAuthority authority = new SimpleGrantedAuthority("ROLE_" + (role != null ? role.toUpperCase() : "USER"));

                // Create authentication token
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(userId, null, Collections.singletonList(authority));

                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // Set authentication in SecurityContext
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

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        // Apply filter to ALL requests to extract JWT from header
        return false;
    }
}

package blostesoftware.blostefix.catalogo.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

@Slf4j
@Component
public class JwtTokenProvider {

    private PublicKey publicKey;

    public JwtTokenProvider(@Value("classpath:keys/public.pem") Resource publicKeyResource) {
        try {
            this.publicKey = loadPublicKey(publicKeyResource);
        } catch (Exception e) {
            log.error("Failed to load public key", e);
            throw new RuntimeException("Failed to initialize JwtTokenProvider", e);
        }
    }

    private PublicKey loadPublicKey(Resource resource) throws Exception {
        String keyContent = new String(Files.readAllBytes(Paths.get(resource.getURI())));
        
        // Remove PEM headers and whitespace
        String cleanKey = keyContent
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replaceAll("\\s+", "");

        // Decode from Base64
        byte[] decodedKey = Base64.getDecoder().decode(cleanKey);

        // Create PublicKey from bytes
        X509EncodedKeySpec spec = new X509EncodedKeySpec(decodedKey);
        KeyFactory kf = KeyFactory.getInstance("RSA");
        return kf.generatePublic(spec);
    }

    public Claims validateAndGetClaims(String token) throws JwtException {
        try {
            return Jwts.parser()
                    .verifyWith(publicKey)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (JwtException e) {
            log.error("JWT token validation failed: {}", e.getMessage());
            throw e;
        }
    }

    public String getRole(Claims claims) {
        return claims.get("role", String.class);
    }

    public boolean isAdmin(Claims claims) {
        String role = getRole(claims);
        return "admin".equals(role);
    }

    public String getUserId(Claims claims) {
        return claims.getSubject();
    }

    public String getLogin(Claims claims) {
        return claims.get("login", String.class);
    }
}

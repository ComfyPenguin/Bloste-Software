from enum import Enum

try:
    from enum import StrEnum
except ImportError:
    # Python < 3.11
    class StrEnum(str, Enum):
        """Enum where members are also instances of str."""
        pass

# Constantes del módulo de autenticación JWT
class Configuration(StrEnum):
    """Constantes del módulo"""
    NAME_MODULO = 'custom_auth_jwt'
    ALGORITHM_RS = 'RS256'
    DECODE = 'utf-8'

# Rutas de endpoint para autenticación JWT
class Endpoints(StrEnum):
    """Rutas de endoint"""
    AUTH_TOKEN = '/api/auth/token'
    AUTH_REGISTER = '/api/auth/register'
    USER_ME = '/api/users/me'
    AUTH_REFRESH = '/api/auth/refresh'

    @property
    def path(self):
        return self.value

# Token Expiration Times (in seconds)
ACCESS_TOKEN_EXPIRES_IN = 86400  # 5 minutes
LOGIN_TOKEN_EXPIRES_IN = 86400   # 5 minutes
REFRESH_TOKEN_EXPIRES_IN = 86400 # 7 days

# Token Types
TOKEN_TYPE_ACCESS = 'access'
TOKEN_TYPE_LOGIN = 'login'
TOKEN_TYPE_REFRESH = 'refresh'

abstract class HttpFailure {
  final String message;
  
  HttpFailure({required this.message});

  factory HttpFailure.fromStatusCode(int statusCode, {String? message}) {
    switch (statusCode) {
      case 400:
        return BadRequestFailure(message: message ?? 'Bad Request');
      case 401:
        return UnauthorizedFailure(message: message ?? 'Unauthorized');
      case 403:
        return ForbiddenFailure(message: message ?? 'Forbidden');
      case 404:
        return NotFoundFailure(message: message ?? 'Not Found');
      case 409:
        return ConflictFailure(message: message ?? 'Conflict');
      case 500:
        return InternalServerErrorFailure(message: message ?? 'Internal Server Error');
      case 503:
        return ServiceUnavailableFailure(message: message ?? 'Service Unavailable');
      default:
        return UnknownFailure(message: message ?? 'Unknown Error');
    }
  }
}

class BadRequestFailure extends HttpFailure {
  BadRequestFailure({super.message = 'Bad Request'});
}

class UnauthorizedFailure extends HttpFailure {
  UnauthorizedFailure({super.message = 'Unauthorized'});
}

class ForbiddenFailure extends HttpFailure {
  ForbiddenFailure({super.message = 'Forbidden'});
}

class NotFoundFailure extends HttpFailure {
  NotFoundFailure({super.message = 'Not Found'});
}

class ConflictFailure extends HttpFailure {
  ConflictFailure({super.message = 'Conflict'});
}

class InternalServerErrorFailure extends HttpFailure {
  InternalServerErrorFailure({super.message = 'Internal Server Error'});
}

class ServiceUnavailableFailure extends HttpFailure {
  ServiceUnavailableFailure({super.message = 'Service Unavailable'});
}

class NetworkFailure extends HttpFailure {
  NetworkFailure({super.message = 'Network Error'});
}

class UnknownFailure extends HttpFailure {
  UnknownFailure({super.message = 'Unknown Error'});
}
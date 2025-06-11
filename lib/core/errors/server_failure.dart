import 'package:car_seek/core/errors/failure.dart';

class ServerFailure extends Failure {
  @override
  String get defaultMessage => 'Error en el servidor. Inténtalo de nuevo más tarde.';

  const ServerFailure({
    super.customMessage,
    super.errorCode = 'server_error',
    super.statusCode = 500,
  });
}

class MaintenanceFailure extends ServerFailure {
  @override
  String get defaultMessage => 'Servicio en mantenimiento. Por favor, inténtalo más tarde.';

  const MaintenanceFailure({
    super.customMessage,
    super.errorCode = 'maintenance_mode',
    super.statusCode = 503,
  });
}

class NetworkFailure extends Failure {
  @override
  String get defaultMessage => 'Error de conexión. Verifica tu internet.';

  const NetworkFailure({
    super.customMessage,
    super.errorCode = 'network_error',
    super.statusCode = 502,
  });
}

class TimeoutFailure extends Failure {
  @override
  String get defaultMessage => 'Tiempo de espera agotado. Intenta nuevamente.';

  const TimeoutFailure({
    super.customMessage,
    super.errorCode = 'request_timeout',
    super.statusCode = 408,
  });
}
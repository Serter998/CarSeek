import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';

class CerrarSesionUseCase {
  final AuthRepository repository;

  CerrarSesionUseCase({required this.repository});

  Future<void> call() {
    return repository.cerrarSesion();
  }
}
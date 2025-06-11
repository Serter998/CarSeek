import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetCurrentUserUseCase {
  final UsuarioRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<Either<Failure, User>> call() {
    return repository.getCurrentUser();
  }
}

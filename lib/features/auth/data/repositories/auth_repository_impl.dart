import 'package:car_seek/core/errors/failures.dart';
import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:car_seek/features/auth/data/sources/auth_source.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthSource authSource;
  final UsuarioSource userSource;

  AuthRepositoryImpl({required this.authSource, required this.userSource});

  @override
  Future<Either<Failure, Usuario>> register(
    String email,
    String password,
    String nombre,
    String? telefono,
    String? ubicacion,
  ) async {
    try {
      final AuthResponse response = await authSource.register(email, password);
      final user = response.user;

      if (user != null) {
        final usuarioModel = UsuarioModel(
          id: user.id,
          userId: user.id,
          nombre: nombre,
          tipoUsuario: TipoUsuario.cliente,
        );

        await userSource.createUser(usuarioModel);
        return Right(usuarioModel);
      } else {
        throw ServerFailure();
      }
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      debugPrint("Error desconocido: ${e.toString()}");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Usuario>> login(String email, String password) async {
    try {
      final AuthResponse response = await authSource.login(email, password);
      final user = response.user;

      if (user != null) {
        final userData = await userSource.getUserById(user.id);
        if (userData != null) {
          return Right(userData);
        } else {
          throw ServerFailure();
        }
      } else {
        throw ServerFailure();
      }
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      debugPrint("Error desconocido: ${e.toString()}");
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> cerrarSesion() async {
    await authSource.cerrarSesion();
  }

  @override
  Future<Either<Failure, Usuario>> getCurrentUser() async {
    try {
      final user = authSource.getCurrentUser();
      if (user != null) {
        final usuarioModel = await userSource.getUserById(user.id);
        if(usuarioModel != null) {
          return Right(usuarioModel);
        } else {
          throw ServerFailure();
        }
      } else {
        throw ServerFailure();
      }
    } on ServerFailure {
      return Left(ServerFailure());
    } catch (e) {
      debugPrint("Error desconocido: ${e.toString()}");
      return Left(ServerFailure());
    }
  }
}

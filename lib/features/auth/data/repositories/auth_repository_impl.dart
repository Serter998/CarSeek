import 'dart:async';
import 'dart:io';

import 'package:car_seek/core/errors/auth_failure.dart';
import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/core/errors/validation_failures.dart';
import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:car_seek/features/auth/data/sources/auth_source.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/features/auth/domain/repositories/auth_repository.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';
import 'package:dartz/dartz.dart';
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

      if (user == null) {
        return Left(
          AuthFailure(errorCode: 'user_creation_failed', statusCode: 500),
        );
      }

      final usuarioModel = UsuarioModel(
        id: user.id,
        userId: user.id,
        nombre: nombre,
        tipoUsuario: TipoUsuario.cliente,
        telefono: telefono,
        ubicacion: ubicacion,
      );

      await userSource.createUser(usuarioModel);
      return Right(usuarioModel);
    } on AuthException catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        return const Left(
          NetworkFailure(errorCode: 'no_internet', statusCode: 503),
        );
      }

      return Left(switch (e.code) {
        'email_in_use' => const EmailAlreadyInUseFailure(),
        'weak_password' => const WeakPasswordFailure(),
        'invalid_email' => const InvalidEmailFailure(),
        _ => AuthFailure(customMessage: "Error al registrarse."),
      });
    } on TimeoutException catch (_) {
      return const Left(TimeoutFailure());
    } on PostgrestException catch (e) {
      if(e.code == "23503") {
        return Left(EmailAlreadyInUseFailure());
      }
      return Left(
        DatabaseFailure(
          errorCode: 'database_error',
          statusCode: 500,
          customMessage: 'Error al guardar los datos del usuario',
        ),
      );
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, Usuario>> login(String email, String password) async {
    try {
      final response = await authSource.login(email, password);

      final user = response.user;
      if (user == null) {
        return Left(UserNotFoundFailure());
      } else {
        final usuario = await userSource.getUserById(user.id);
        if (usuario == null) {
          return Left(UserNotFoundFailure());
        } else {
          return Right(usuario);
        }
      }
    } on AuthException catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        return const Left(
          NetworkFailure(errorCode: 'no_internet', statusCode: 503),
        );
      }

      return Left(switch (e.code) {
        'invalid_credentials' => const InvalidCredentialsFailure(),
        'user_not_found' => const UserNotFoundFailure(),
        'account_locked' => const AccountLockedFailure(),
        'email_not_confirmed' => const EmailNotConfirmedFailure(),
        _ => AuthFailure(customMessage: e.message),
      });
    } on TimeoutException {
      return const Left(TimeoutFailure());
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> cerrarSesion() async {
    try {
      await authSource.cerrarSesion();
      return const Right(null);
    } on SocketException catch (_) {
      return const Left(
        NetworkFailure(errorCode: 'no_internet', statusCode: 503),
      );
    } on TimeoutException catch (_) {
      return const Left(
        TimeoutFailure(errorCode: 'logout_timeout', statusCode: 408),
      );
    } on AuthException catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        return const Left(
          NetworkFailure(errorCode: 'no_internet', statusCode: 503),
        );
      }
      return Left(AuthFailure(customMessage: 'Error al cerrar la sesión'));
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, Usuario?>> getCurrentUser() async {
    try {
      final user = authSource.getCurrentUser();

      if (user == null) {
        return const Right(null);
      }

      final usuario = await userSource.getUserById(user.id);

      if (usuario == null) {
        return Left(
          UserNotFoundFailure(
            customMessage: 'Perfil de usuario no encontrado',
            errorCode: 'profile_not_found',
            statusCode: 404,
          ),
        );
      }
      return Right(usuario);
    } on AuthException catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        return const Left(
          NetworkFailure(errorCode: 'no_internet', statusCode: 503),
        );
      }
      return Left(AuthFailure(customMessage: 'Error al obtener el usuario'));
    } on PostgrestException catch (e) {
      return Left(
        DatabaseFailure(
          customMessage: 'Error al obtener datos del usuario',
          errorCode: 'user_query_failed',
          statusCode: 500,
        ),
      );
    } on SocketException catch (_) {
      return const Left(
        NetworkFailure(errorCode: 'no_internet', statusCode: 503),
      );
    } on TimeoutException catch (_) {
      return const Left(
        TimeoutFailure(errorCode: 'user_fetch_timeout', statusCode: 408),
      );
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCredentials() async {
    try {
      final resp = await authSource.deleteCredentials();
      return Right(resp);
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500, customMessage: 'Error al eliminar las credenciales'));
    }
  }

  @override
  Future<Either<Failure, Map<String, String?>>> loadCredentials() async {
    try {
      final resp = await authSource.loadCredentials();
      return Right(resp);
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500, customMessage: 'Error al cargar las credenciales'));
    }
  }

  @override
  Future<Either<Failure, void>> saveCredentials(String email, String password) async {
    try {
      final resp = await authSource.saveCredentials(email, password);
      return Right(resp);
    } catch (e) {
      return Left(ServerFailure(errorCode: 'unknown_error', statusCode: 500, customMessage: 'Error al guardar las credenciales'));
    }
  }
}

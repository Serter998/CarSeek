import 'dart:async';
import 'dart:io';

import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/core/errors/validation_failures.dart';
import 'package:car_seek/share/data/models/usuario_model.dart';
import 'package:car_seek/share/data/source/usuario_source.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/repositories/usuario_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/auth_failure.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioSource userSource;

  UsuarioRepositoryImpl({required this.userSource});

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      return Right(await userSource.deleteUser(id));
    } on AuthException catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        return const Left(
          NetworkFailure(errorCode: 'no_internet', statusCode: 503),
        );
      }
      return Left(AuthFailure(customMessage: 'Error al borrar el usuario'));
    } on PostgrestException catch (e) {
      return Left(
        DatabaseFailure(
          customMessage: 'Error al borrar el usuario',
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
  Future<Either<Failure, List<Usuario>>> getAllUsers() async {
    try {
      List<UsuarioModel>? usuarios = await userSource.getAllUsers();
      if(usuarios == null) {
        return const Left(
          UserNotFoundFailure(
            customMessage: 'No existe ningun usuario',
            errorCode: 'profile_not_found',
            statusCode: 404,
          ),
        );
      } else {
        return Right(usuarios);
      }
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
  Future<Either<Failure, Usuario>> getUserById(String id) async {
    try {
      UsuarioModel? usuario = await userSource.getUserById(id);

      if (usuario == null) {
        return const Left(
          UserNotFoundFailure(
            customMessage: 'Perfil de usuario no encontrado',
            errorCode: 'profile_not_found',
            statusCode: 404,
          ),
        );
      } else {
        return Right(usuario);
      }
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
  Future<Either<Failure, void>> updateUser(Usuario usuario) async {
    try {
      return Right(await userSource.updateUser(UsuarioModel.fromEntity(usuario)));
    } on AuthException catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('Failed host lookup')) {
        return const Left(
          NetworkFailure(errorCode: 'no_internet', statusCode: 503),
        );
      }
      return Left(AuthFailure(customMessage: 'Error al modificar el usuario'));
    } on PostgrestException catch (e) {
      return Left(
        DatabaseFailure(
          customMessage: 'Error al modificar el usuario',
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
  Future<Either<Failure, void>> cerrarSesion() async {
    try {
      await userSource.cerrarSesion();
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
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      User? user = await userSource.getCurrentUser();

      if (user == null) {
        return const Left(
          UserNotFoundFailure(
            customMessage: 'Perfil de usuario no encontrado',
            errorCode: 'profile_not_found',
            statusCode: 404,
          ),
        );
      } else {
        return Right(user);
      }
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
  Future<Either<Failure, Usuario>> getCurrentUsuario() async {
    try {
      UsuarioModel? usuario = await userSource.getCurrentUsuario();

      if (usuario == null) {
        return const Left(
          UserNotFoundFailure(
            customMessage: 'Perfil de usuario no encontrado',
            errorCode: 'profile_not_found',
            statusCode: 404,
          ),
        );
      } else {
        return Right(usuario);
      }
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
}

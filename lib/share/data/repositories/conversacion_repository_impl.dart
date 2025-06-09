import 'dart:async';
import 'dart:io';

import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/validation_failures.dart';
import 'package:car_seek/share/data/models/conversacion_model.dart';
import 'package:car_seek/share/data/source/conversacion_source.dart';
import 'package:car_seek/share/domain/repositories/conversacion_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../core/errors/server_failure.dart';

class ConversacionRepositoryImpl implements ConversacionRepository {
  final ConversacionSource conversacionSource;

  ConversacionRepositoryImpl({required this.conversacionSource});

  @override
  Future<Either<Failure, void>> createConversacion(ConversacionModel conversacion) async {
    try {
      await conversacionSource.createConversacion(conversacion);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al crear la conversación: ${e.toString()}',
        errorCode: 'conversation_creation_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversacion(String id) async {
    try {
      if (id.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID de conversacion requerido',
          errorCode: 'missing_conversation_id',
        ));
      }
      await conversacionSource.deleteConversacion(id);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al borrar la conversación',
        errorCode: 'conversation_delete_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, List<ConversacionModel>?>> getAllConversacionesByCurrentUser() async {
    try {
      final conversaciones = await conversacionSource.getAllConversacionesByCurrentUser();
      return Right(conversaciones);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener lista de conversaciones',
        errorCode: 'conversation_list_error',
      ));
    }
  }

  @override
  Future<Either<Failure, ConversacionModel?>> getConversacionByUsuariosYNombre({
    required String usuario1,
    required String usuario2,
    required String nombre,
  }) async {
    try {
      final conversacion = await conversacionSource.getConversacionByUsuariosYNombre(
        usuario1: usuario1,
        usuario2: usuario2,
        nombre: nombre,
      );
      return Right(conversacion);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al buscar conversación',
        errorCode: 'conversation_search_error',
      ));
    }
  }
}
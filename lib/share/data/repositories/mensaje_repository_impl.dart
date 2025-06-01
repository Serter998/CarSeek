import 'dart:async';
import 'dart:io';

import 'package:car_seek/core/errors/failure.dart';
import 'package:car_seek/core/errors/server_failure.dart';
import 'package:car_seek/core/errors/validation_failures.dart';
import 'package:car_seek/share/data/models/mensaje_model.dart';
import 'package:car_seek/share/data/source/mensaje_source.dart';
import 'package:car_seek/share/domain/repositories/mensaje_repository.dart';
import 'package:dartz/dartz.dart';

class MensajeRepositoryImpl implements MensajeRepository {
  final MensajeSource mensajeSource;

  MensajeRepositoryImpl({required this.mensajeSource});

  @override
  Future<Either<Failure, void>> createMensaje(MensajeModel mensaje) async {
    try {
      await mensajeSource.createMensaje(mensaje);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al crear el mensaje',
        errorCode: 'message_creation_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMensaje(String id) async {
    try {
      if (id.isEmpty) {
        return Left(ValidationFailure(
          customMessage: 'ID de mensaje requerido',
          errorCode: 'missing_message_id',
        ));
      }
      await mensajeSource.deleteMensaje(id);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al borrar el mensaje',
        errorCode: 'message_delete_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, void>> updateMensaje(MensajeModel mensaje) async {
    try {
      await mensajeSource.updateMensaje(mensaje);
      return const Right(null);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al actualizar el mensaje',
        errorCode: 'message_update_failed',
      ));
    }
  }

  @override
  Future<Either<Failure, List<MensajeModel>?>> getAllMensajesByConversacion(String idConversacion) async {
    try {
      List<MensajeModel>? mensajes = await mensajeSource.getAllMensajesByConversacion(idConversacion);
      return Right(mensajes);
    } on TimeoutException {
      return Left(TimeoutFailure());
    } on SocketException {
      return Left(NetworkFailure());
    } catch (e) {
      return Left(DatabaseFailure(
        customMessage: 'Error al obtener los mensajes',
        errorCode: 'message_get_failed',
      ));
    }
  }
}
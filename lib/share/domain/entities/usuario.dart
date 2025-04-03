import 'package:car_seek/share/domain/enums/tipo_usuario.dart';

class Usuario {
  final String id;
  final String userId;
  final String nombre;
  final String? telefono;
  final String? ubicacion;
  final int? reputacion;
  final DateTime? fechaRegistro;
  final DateTime? fechaActualizacion;
  final TipoUsuario tipoUsuario;

  Usuario({
    required this.id,
    required this.userId,
    required this.nombre,
    this.telefono,
    this.ubicacion,
    this.reputacion,
    this.fechaRegistro,
    this.fechaActualizacion,
    required this.tipoUsuario,
  });
}
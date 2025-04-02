import 'package:car_seek/share/domain/enums/tipo_usuario.dart';

class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String? telefono;
  final String? ubicacion;
  final double reputacion;
  final DateTime fechaRegistro;
  final TipoUsuario tipoUsuario;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    this.telefono,
    this.ubicacion,
    required this.reputacion,
    required this.fechaRegistro,
    required this.tipoUsuario,
  });
}
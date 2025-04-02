import 'package:car_seek/share/domain/entities/usuario.dart';
import 'package:car_seek/share/domain/enums/tipo_usuario.dart';

class UsuarioModel extends Usuario{
  UsuarioModel({
    required super.id,
    required super.nombre,
    required super.email,
    super.telefono,
    super.ubicacion,
    required super.reputacion,
    required super.fechaRegistro,
    required super.tipoUsuario,
  });
  
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id_usuario'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      ubicacion: json['ubicacion'],
      reputacion: json['reputacion']?.toDouble() ?? 0.0,
      fechaRegistro: DateTime.parse(json['fecha_registro']),
      tipoUsuario: TipoUsuarioExtension.fromString(json['tipo_usuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario' : id,
      'nombre' : nombre,
      'email' : email,
      'telefono' : telefono,
      'ubicacion' : ubicacion,
      'reputacion' : reputacion,
      'fecha_registro' : fechaRegistro.toIso8601String(),
      'tipo_usuario' : tipoUsuario.name,
    };
  }

  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
        id: usuario.id,
        nombre: usuario.nombre,
        email: usuario.email,
        telefono: usuario.telefono,
        ubicacion: usuario.ubicacion,
        reputacion: usuario.reputacion,
        fechaRegistro: usuario.fechaRegistro,
        tipoUsuario: usuario.tipoUsuario);
  }
}

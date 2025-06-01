import 'package:car_seek/share/domain/entities/conversacion.dart';

class ConversacionModel extends Conversacion {
  ConversacionModel({
    required super.id,
    required super.nombre,
    required super.usuario1,
    required super.usuario2,
    required super.createdAt,
  });

  factory ConversacionModel.fromJson(Map<String, dynamic> json) {
    return ConversacionModel(
      id: json['id'],
      nombre: json['nombre'],
      usuario1: json['usuario1'],
      usuario2: json['usuario2'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'usuario1': usuario1,
      'usuario2': usuario2,
    };

    // Solo incluir la ID si no es nula
    if (id != null) {
      data['id'] = id;
    }

    // Incluir createdAt si no es nulo (formato ISO8601 en UTC)
    if (createdAt != null) {
      data['created_at'] = createdAt!.toUtc().toIso8601String();
    }

    return data;
  }

  factory ConversacionModel.fromEntity(Conversacion conversacion) {
    return ConversacionModel(
        id: conversacion.id,
        nombre: conversacion.nombre,
        usuario1: conversacion.usuario1,
        usuario2: conversacion.usuario2,
        createdAt: conversacion.createdAt,);
  }
}

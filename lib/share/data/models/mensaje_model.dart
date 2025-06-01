import 'package:car_seek/share/domain/entities/mensaje.dart';

class MensajeModel extends Mensaje {
  MensajeModel({
    super.id,
    required super.conversacionId,
    required super.senderId,
    required super.context,
    super.createdAt,
  });

  factory MensajeModel.fromJson(Map<String, dynamic> json) {
    return MensajeModel(
      id: json['id'],
      conversacionId: json['conversacion_id'],
      senderId: json['sender_id'],
      context: json['context'],
      createdAt: DateTime.parse(json['created_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'conversacion_id': conversacionId,
      'sender_id': senderId,
      'context': context,
    };

    // Solo incluir la ID si no es nula
    if (id != null) {
      data['id'] = id;
    }

    // Incluir createdAt si no es nulo (opcional)
    if (createdAt != null) {
      data['created_at'] = createdAt!.toUtc().toIso8601String();
    }

    return data;
  }

  factory MensajeModel.fromEntity(Mensaje mensaje) {
    return MensajeModel(
      id: mensaje.id,
      conversacionId: mensaje.conversacionId,
      senderId: mensaje.senderId,
      context: mensaje.context,
      createdAt: mensaje.createdAt,);
  }
}

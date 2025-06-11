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
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      conversacionId: json['conversacion_id'] as String,
      context: json['context'] as String,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'conversacion_id': conversacionId,
      'sender_id': senderId,
      'context': context,
    };
    if (id != null) data['id'] = id!;
    if (createdAt != null) data['created_at'] = createdAt!.toUtc().toIso8601String();
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

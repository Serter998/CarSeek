class Mensaje {
  final String? id;
  final String conversacionId;
  final String senderId;
  final String context;
  final DateTime? createdAt;

  Mensaje({
    this.id,
    required this.conversacionId,
    required this.senderId,
    required this.context,
    this.createdAt,
  });
}

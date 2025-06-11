class Conversacion {
  final String id;
  final String nombre;
  final String usuario1;
  final String usuario2;
  final DateTime? createdAt;

  Conversacion({
    required this.id,
    required this.nombre,
    required this.usuario1,
    required this.usuario2,
    this.createdAt,
  });
}

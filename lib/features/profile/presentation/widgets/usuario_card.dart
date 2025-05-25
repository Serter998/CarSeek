import 'package:flutter/material.dart';
import 'package:car_seek/share/domain/entities/usuario.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onTap;

  const UsuarioCard({super.key, required this.usuario, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.person, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usuario.nombre, style: Theme.of(context).textTheme.titleMedium),
                    if (usuario.ubicacion != null)
                      Text(usuario.ubicacion!, style: Theme.of(context).textTheme.bodySmall),
                    Text(
                      'Tipo: ${usuario.tipoUsuario.nombre}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
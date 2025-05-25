import 'package:flutter/material.dart';

class FiltroVerificacionMenu extends StatelessWidget {
  final bool mostrarVerificados;
  final ValueChanged<bool> onChanged;

  const FiltroVerificacionMenu({
    super.key,
    required this.mostrarVerificados,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<bool>(
      icon: Icon(
        mostrarVerificados ? Icons.verified : Icons.verified_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      onSelected: onChanged,
      itemBuilder: (context) => [
        const PopupMenuItem(value: false, child: Text('No verificados')),
        const PopupMenuItem(value: true, child: Text('Verificados')),
      ],
      tooltip: 'Filtrar verificación',
    );
  }
}

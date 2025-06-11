import 'package:flutter/material.dart';

class BuscadorVehiculo extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BuscadorVehiculo({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Buscar por título...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onChanged: onChanged,
    );
  }
}
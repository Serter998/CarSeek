import 'package:flutter/material.dart';
import 'package:car_seek/core/constants/app_colors.dart';

class VehicleInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const VehicleInfoChip({Key? key, required this.icon, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      avatar: Icon(icon, size: 18, color: AppColors.primary),
      label: Text(text, style: const TextStyle(color: Colors.black87)),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

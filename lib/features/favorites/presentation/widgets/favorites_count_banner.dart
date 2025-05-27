import 'package:flutter/material.dart';
import 'package:car_seek/core/constants/app_colors.dart';

class FavoritesCountWidget extends StatelessWidget {
  final int count;

  const FavoritesCountWidget({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return count == 0
        ? const SizedBox.shrink()
        : Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            border: Border.all(color: AppColors.primary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'Mostrando $count vehículo(s) favorito(s)',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

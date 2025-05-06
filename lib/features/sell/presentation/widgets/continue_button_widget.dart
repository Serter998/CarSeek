import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;

  const ContinueButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height = 52,
    this.borderRadius = 16,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: width ?? double.infinity, // Ancho infinito por defecto
          height: height,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              padding: padding ?? const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              text,
              style: textStyle ?? const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
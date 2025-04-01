import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final bool isPassword;
  final String placeholder;

  const InputText({
    super.key,
    required this.isPassword,
    required this.placeholder,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
      child: TextField(
        obscureText: widget.isPassword,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String placeholder;
  final TextEditingController? controller;

  const InputText({
    super.key,
    required this.placeholder,
    required this.controller,
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
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PasswordInputText extends StatefulWidget {
  final String placeholder;

  const PasswordInputText({super.key, required this.placeholder});

  @override
  State<PasswordInputText> createState() => _PasswordInputTextState();
}

class _PasswordInputTextState extends State<PasswordInputText> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
      child: TextField(
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }
}

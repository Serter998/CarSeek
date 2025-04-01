import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {
  final Function()? function;
  final String text;

  const ActionButton({super.key, required this.function, required this.text});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.function ?? () {},
      child: Text(widget.text),
    );
  }
}

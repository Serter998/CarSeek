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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        onPressed: widget.function ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: Color.fromARGB(180, 255, 255, 255),
              width: 1.5,
            ),
          ),
        ),
        child: Text(widget.text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

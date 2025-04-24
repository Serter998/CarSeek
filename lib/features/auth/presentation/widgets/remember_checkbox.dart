import 'package:car_seek/core/themes/text_styles.dart';
import 'package:flutter/material.dart';

class RememberMeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = "Recuérdame",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
          ),
          Text(label, style: TextStyles.defaultText,),
        ],
      ),
    );
  }
}

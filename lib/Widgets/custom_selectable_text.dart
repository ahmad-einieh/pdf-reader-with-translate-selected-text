import 'package:flutter/material.dart';

class CustomSelectableText extends StatelessWidget {
  const CustomSelectableText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: const TextStyle(fontSize: 24),
      textDirection: TextDirection.rtl,
    );
  }
}

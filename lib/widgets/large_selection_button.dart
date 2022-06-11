import 'package:flutter/material.dart';

class LargeSelectionButton extends StatelessWidget {
  final String buttonTitle;
  final Function() onPressed;

  const LargeSelectionButton({
    Key? key,
    required this.buttonTitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(0, 80)),
      onPressed: onPressed,
      child: Center(
        child: Text(buttonTitle),
      ),
    );
  }
}

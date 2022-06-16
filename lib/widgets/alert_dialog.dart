import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {

  final String titleText;
  final Function() onConfirmAction;
  final Function() onCancelAction;

  const CustomAlertDialog({
    Key? key, required this.onConfirmAction, required this.onCancelAction, required this.titleText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure want to $titleText?'),
      actions: [
        ElevatedButton(
            onPressed: onConfirmAction,
            child: const Text('Yes')),
        TextButton(
            onPressed: onCancelAction,
            child: const Text('No'))
      ],
    );
  }
}
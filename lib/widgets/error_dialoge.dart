import 'package:flutter/material.dart';

class ErroDialog extends StatelessWidget {
  final String? message;
  ErroDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: (() => Navigator.of(context).pop()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Center(
            child: Text('oK'),
          ),
        )
      ],
    );
  }
}

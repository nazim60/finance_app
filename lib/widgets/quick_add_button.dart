import 'package:flutter/material.dart';

class QuickAddButton extends StatelessWidget {
  final VoidCallback onPressed;
  const QuickAddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.add),
      backgroundColor: Colors.teal,
    );
  }
}

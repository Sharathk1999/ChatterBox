import 'package:flutter/material.dart';

class ErrorDisplayScreen extends StatelessWidget {
  final String error;
  const ErrorDisplayScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
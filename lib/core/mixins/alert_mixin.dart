import 'package:flutter/material.dart';

mixin AlertMixin {
  void showSuccessSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, Theme.of(context).primaryColor);
  }

  void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(context, message, Colors.redAccent);
  }

  void _showSnackBar(BuildContext context, String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
      ),
    );
  }

}

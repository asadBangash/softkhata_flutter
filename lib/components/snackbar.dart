import 'package:flutter/material.dart';

successSnackBar(BuildContext context, {String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 4),
    ),
  );
}

errorSnackBar(BuildContext context, {String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.redAccent..shade400,
      duration: const Duration(seconds: 4),
    ),
  );
}

snackBar(BuildContext context, {String message}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.fixed,
      duration: const Duration(seconds: 2),
    ),
  );
}
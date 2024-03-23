import 'package:flutter/material.dart';

class RegisterButtonTasker extends StatelessWidget {
  final Function()? onTap;

  const RegisterButtonTasker({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).colorScheme.tertiary;
    Color buttonTextColor = Theme.of(context).colorScheme.secondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Register as Tasker",
            style: TextStyle(
              color: buttonTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
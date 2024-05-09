import 'package:flutter/material.dart';

class RegisterButtonCustomer extends StatelessWidget {
  final Function()? onTap;

  const RegisterButtonCustomer({super.key, required this.onTap});

  // create button for customer register
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
            "Register as Customer",
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
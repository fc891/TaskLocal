import 'package:flutter/material.dart';

class LoginButtonCustomer extends StatelessWidget {
  final Function()? onTap;

  const LoginButtonCustomer({super.key, required this.onTap});

  // create button for customer login
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            "Log In",
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
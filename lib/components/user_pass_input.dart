import 'package:flutter/material.dart';

class UserPassInput extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const UserPassInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  // create input box for username and password
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
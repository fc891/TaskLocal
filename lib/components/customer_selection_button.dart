import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionButtonCustomer extends StatelessWidget {
  final Function()? onTap;

  const SelectionButtonCustomer({super.key, required this.onTap});

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
            "Login As a Customer",
            style: GoogleFonts.lato(
              color: buttonTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

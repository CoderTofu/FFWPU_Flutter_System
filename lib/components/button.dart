import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFullWidth;
  final String buttonText; // Added text parameter

  const Button({
    super.key,
    required this.onPressed,
    required this.buttonText,
    this.isFullWidth = false, // Default to not full width
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null, // Full width if true
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(1, 118, 178, 1), // Custom color
          foregroundColor: Colors.white, // Text color
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14), // Button padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
          elevation: 5, // Shadow effect
        ),
        child: Text(
          buttonText, 
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}


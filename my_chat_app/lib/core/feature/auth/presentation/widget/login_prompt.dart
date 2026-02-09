import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback onPressed;
  final String subtitle;
  final String title;
  const LoginPrompt({super.key, required this.onPressed, required this.subtitle, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector( 
        onTap: onPressed,
        child: RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: subtitle,
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
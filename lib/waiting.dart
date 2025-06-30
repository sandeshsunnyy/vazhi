import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {
  const Waiting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF818C78),
      body: Center(
        child: CircularProgressIndicator(
          value: 30.0,
          color: Colors.white70,
          strokeWidth: 4.0,
        ),
      ),
    );
  }
}

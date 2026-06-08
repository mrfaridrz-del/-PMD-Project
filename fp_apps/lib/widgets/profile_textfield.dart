//==========PROFILE TEXT FIELD

import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {

  final String label;
  final IconData icon;
  final TextEditingController controller;
  final int maxLines;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {

    return TextField(

      controller: controller,

      maxLines: maxLines,

      decoration: InputDecoration(

        labelText: label,

        prefixIcon: Icon(
          icon,
          color: const Color(0xFF4F46E5),
        ),

        filled: true,

        fillColor:
            const Color(0xFFF8FAFC),

        border:
            OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
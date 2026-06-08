//===============STAT CARD================

import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {

  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 90,

      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),

      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.15),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(

        children: [

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 22,

              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(

            label,

            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
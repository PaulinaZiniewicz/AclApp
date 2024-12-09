import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String level;
  final String infoText; // Zmieniamy na infoText
  final VoidCallback onArrowTap;

  const InfoCard({
    super.key,
    required this.level,
    required this.infoText, // Zmieniamy nazwę na infoText
    required this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF3C536C),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome to $level Training Plan",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            infoText, // Wyświetlamy infoText
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onArrowTap,
            child: const Icon(
              Icons.arrow_forward,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

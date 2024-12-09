import 'package:flutter/material.dart';

class SleepRecommendationsPage extends StatelessWidget {
  const SleepRecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final recommendations = [
      "Go to bed at the same time every day.",
      "Avoid screens (phones, TVs, computers) 1-2 hours before bedtime.",
      "Create a relaxing bedtime routine.",
      "Ensure your bedroom is dark, quiet, and cool.",
      "Avoid caffeine and heavy meals before bedtime.",
      "Exercise regularly, but not close to bedtime.",
    ];

  return SafeArea(
    child: Scaffold(
      body: Stack(
        children: [
          // Tło z logo
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/images/logo.png',
                width: 400,
                height: 400,
              ),
            ),
          ),
          // Główna zawartość
          Column(
            children: [
              // Nagłówek
              AppBar(
                title: const Text("Sleep Recommendations"),
              ),
              // Lista rekomendacji
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.separated(
                    itemCount: recommendations.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.nightlight_round, color: Colors.blue),
                        title: Text(recommendations[index]),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
  }
}


  
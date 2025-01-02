import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../theme/theme_helper.dart';

class SleepTrendChart extends StatelessWidget {
  const SleepTrendChart({super.key});

  Future<List<Map<String, dynamic>>> _fetchLast7DaysSleepData() async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return []; // Jeśli użytkownik nie jest zalogowany, zwracamy pustą listę
    }

    final today = DateTime.now();

    final last7Days = List.generate(
      7,
      (index) => today.subtract(Duration(days: index)).toIso8601String().split('T')[0],
    ).reversed.toList();

    final snapshot = await firestore
        .collection('sleepData')
        .doc(user.uid) // Pobieramy dane zalogowanego użytkownika
        .collection('records')
        .where(FieldPath.documentId, whereIn: last7Days)
        .get();

    final Map<String, Map<String, dynamic>> fetchedData = {
      for (var doc in snapshot.docs) doc.id: doc.data()
    };

    return last7Days.map((date) {
      final data = fetchedData[date];
      final durationHours = data?['durationHours'] ?? 0;
      final durationMinutes = data?['durationMinutes'] ?? 0;
      return {
        'date': date,
        'totalHours': durationHours + (durationMinutes / 60.0),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchLast7DaysSleepData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No sleep data available for the last 7 days.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          );
        }

        final sleepData = snapshot.data!;

        final spots = sleepData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final totalHours = data['totalHours'];
          return FlSpot(index.toDouble(), totalHours.clamp(0, 12));
        }).toList();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sleep Duration (Last 7 Days)",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 240,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                        drawVerticalLine: true,
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: Colors.grey.shade300,
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          axisNameWidget: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Hours",
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12, color: Colors.black),
                                ),
                              );
                            },
                          ),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          axisNameWidget: const Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Text(
                              "Days",
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ),
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index >= 0 && index < sleepData.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    sleepData[index]['date'].split('-').last,
                                    style: const TextStyle(fontSize: 12, color: Colors.black),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: theme.colorScheme.primary,
                          barWidth: 4,
                          isStrokeCapRound: true,
                          belowBarData: BarAreaData(
                            show: true,
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              final value = spot.y;
                              final isOptimal = value >= 8 && value <= 10;
                              return FlDotCirclePainter(
                                radius: 4,
                                color: isOptimal ? Colors.green : Colors.red,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                        ),
                      ],
                      minY: 0,
                      maxY: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

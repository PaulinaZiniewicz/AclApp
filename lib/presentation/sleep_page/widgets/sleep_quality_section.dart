import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import 'package:acl_application/core/utils/size_utils.dart';

class SleepQualitySection extends StatefulWidget {
  final String sleepQuality;
  final bool isDataSaved;
  final Function(String) onQualityChanged;

  const SleepQualitySection({
    super.key,
    required this.sleepQuality,
    required this.isDataSaved,
    required this.onQualityChanged,
  });

  @override
  _SleepQualitySectionState createState() => _SleepQualitySectionState();
}

class _SleepQualitySectionState extends State<SleepQualitySection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quality of Sleep",
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQualityButton('Very Good', Icons.sentiment_very_satisfied),
                const SizedBox(width: 10),
                _buildQualityButton('Good', Icons.sentiment_satisfied),
                const SizedBox(width: 10),
                _buildQualityButton('Average', Icons.sentiment_neutral),
                const SizedBox(width: 10),
                _buildQualityButton('Poor', Icons.sentiment_dissatisfied),
                const SizedBox(width: 10),
                _buildQualityButton('Very Poor', Icons.sentiment_very_dissatisfied),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Center(
            child: Text(
              "Selected Quality: ${widget.sleepQuality}",
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector _buildQualityButton(String quality, IconData icon) {
    return GestureDetector(
      onTap: widget.isDataSaved
          ? null
          : () {
              setState(() {
                widget.onQualityChanged(quality);
              });
            },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getBackgroundColorForQuality(quality, widget.sleepQuality == quality),
        ),
        child: Icon(icon, color: Colors.grey, size: 40),
      ),
    );
  }

  Color getBackgroundColorForQuality(String quality, bool isSelected) {
    switch (quality) {
      case 'Very Good':
        return isSelected ? const Color(0xFF388E3C) : const Color(0xFFD4EED1);
      case 'Good':
        return isSelected ? const Color(0xFF66BB6A) : const Color(0xFFE8F5E9);
      case 'Average':
        return isSelected ? const Color(0xFFFFA726) : const Color(0xFFFFF3E0);
      case 'Poor':
        return isSelected ? const Color(0xFFE57373) : const Color(0xFFFFEBEE);
      case 'Very Poor':
        return isSelected ? const Color(0xFFD32F2F) : const Color(0xFFFFCDD2);
      default:
        return Colors.grey.shade200;
    }
  }
}

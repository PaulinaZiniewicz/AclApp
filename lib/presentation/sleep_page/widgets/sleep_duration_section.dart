import 'package:flutter/material.dart';
import '../../../theme/theme_helper.dart';
import 'package:acl_application/core/utils/size_utils.dart';

class SleepDurationSection extends StatefulWidget {
  final int durationHours;
  final int durationMinutes;
  final bool isDataSaved;
  final Function(int, int) onDurationChanged;

  const SleepDurationSection({
    super.key,
    required this.durationHours,
    required this.durationMinutes,
    required this.isDataSaved,
    required this.onDurationChanged,
  });

  @override
  _SleepDurationSectionState createState() => _SleepDurationSectionState();
}

class _SleepDurationSectionState extends State<SleepDurationSection> {
  late int durationHours;
  late int durationMinutes;

  @override
  void initState() {
    super.initState();
    durationHours = widget.durationHours;
    durationMinutes = widget.durationMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 17.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: _buildHourSpinner()),
              Flexible(child: _buildMinuteSpinner()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourSpinner() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: widget.isDataSaved
              ? null
              : () {
                  setState(() {
                    if (durationHours > 0) durationHours--;
                    widget.onDurationChanged(durationHours, durationMinutes);
                  });
                },
        ),
        Text(
          "$durationHours h",
          style: theme.textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.isDataSaved
              ? null
              : () {
                  setState(() {
                    durationHours++;
                    widget.onDurationChanged(durationHours, durationMinutes);
                  });
                },
        ),
      ],
    );
  }

  Widget _buildMinuteSpinner() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: widget.isDataSaved
              ? null
              : () {
                  setState(() {
                    if (durationMinutes > 0) durationMinutes-=10;
                    widget.onDurationChanged(durationHours, durationMinutes);
                  });
                },
        ),
        Text(
          "$durationMinutes min",
          style: theme.textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: widget.isDataSaved
              ? null
              : () {
                  setState(() {
                    durationMinutes += 10;
                    widget.onDurationChanged(durationHours, durationMinutes);
                  });
                },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/theme_helper.dart';

class InjuryDropdown extends StatelessWidget {
  final String selectedInjury;
  final Function(String?) onChanged;

  const InjuryDropdown({
    super.key,
    required this.selectedInjury,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: appTheme.blueGray50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Injury history",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButton<String>(
            value: selectedInjury,
            icon: const Icon(Icons.arrow_drop_down),
            items: const [
              DropdownMenuItem<String>(
                value: 'No injury',
                child: Text('No injury'),
              ),
              DropdownMenuItem<String>(
                value: 'ACL surgery',
                child: Text('ACL surgery'),
              ),
            ],
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

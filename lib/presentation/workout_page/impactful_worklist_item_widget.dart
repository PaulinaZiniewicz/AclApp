import 'package:acl_application/core/utils/size_utils.dart';
import 'package:acl_application/presentation/workout_page/workout_plan.dart';
import 'package:flutter/material.dart';
import 'package:acl_application/theme/theme_helper.dart';

import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/custom_elevated_button.dart';


class ImpactfulWorkListItemWidget extends StatefulWidget {
  final WorkoutPlan trainingPlan;
  final VoidCallback onGoToPlan;

  const ImpactfulWorkListItemWidget({
    super.key,
    required this.trainingPlan,
    required this.onGoToPlan,
  });

  @override
  _ImpactfulWorkListItemWidgetState createState() => _ImpactfulWorkListItemWidgetState();
}

class _ImpactfulWorkListItemWidgetState extends State<ImpactfulWorkListItemWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.blueGray50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appTheme.blueGray700,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.fitness_center, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          widget.trainingPlan.level,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: appTheme.blueGray700,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 10),
            Text(
              widget.trainingPlan.description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            CustomElevatedButton(
              height: 30.h,
              width: 250.h,
              text: "Go to Plan",
              buttonStyle: CustomButtonStyles.fillPrimary,
              buttonTextStyle: CustomTextStyles.titleSmallBold,
              onPressed: widget.onGoToPlan,
            )
          ],
        ],
      ),
    );
  }
}

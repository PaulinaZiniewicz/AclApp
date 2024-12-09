import 'package:acl_application/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../../../theme/app_decoration.dart';
import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';

class DailyGoalSectionItemWidget extends StatelessWidget {
  const DailyGoalSectionItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

      color: appTheme.blueGray50,
      borderRadius: BorderRadiusStyle.roundedBorder16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 22.h,
                vertical: 16.h,
              ),
              decoration: BoxDecoration(
              color: appTheme.blueGray700,
              borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "07", // Represents the day
                    style: CustomTextStyles.titleLargePoppins,
                  ),
                  Text(
                    "Day",
                    style: CustomTextStyles.bodySmallGray50,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 176.h,
            margin: EdgeInsets.only(
              left: 10.h,
              top: 18.h,
            ),
            child: Text(
              "Coming through your work on this project has been really impactful",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

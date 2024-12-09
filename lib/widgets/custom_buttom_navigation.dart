import 'package:flutter/material.dart';
import 'package:acl_application/core/utils/image_constant.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../routes/app_routes.dart'; // Import flutter_svg

enum BottomBarEnum { Sleep, Trainings, Home, Workouts, Profile }

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(BottomBarEnum) onTap;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        BottomBarEnum type = BottomBarEnum.values[index];
        _navigateToScreen(context, type);
      },
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(ImageConstant.imgNavSleep),
          activeIcon: SvgPicture.asset(ImageConstant.imgNavSleepPrimary),
          label: "Sleep",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(ImageConstant.imgNavTrainings),
          activeIcon: SvgPicture.asset(ImageConstant.imgNavTrainingsPrimary),
          label: "Trainings",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(ImageConstant.imgHome),
          activeIcon: SvgPicture.asset(ImageConstant.imgHomePrimary),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(ImageConstant.imgNavWorkouts),
          activeIcon: SvgPicture.asset(ImageConstant.imgNavWorkoutsPrimary),
          label: "Workouts",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(ImageConstant.imgNavProfile),
          activeIcon: SvgPicture.asset(ImageConstant.imgNavProfilePrimary),
          label: "Profile",
        ),
      ],
    );
  }


  void _navigateToScreen(BuildContext context, BottomBarEnum type) {
    switch (type) {
      case BottomBarEnum.Sleep:
        Navigator.of(context).pushReplacementNamed(AppRoutes.sleepPage);
        break;
      case BottomBarEnum.Trainings:
        Navigator.of(context).pushReplacementNamed(AppRoutes.trainingsPage);
        break;
      case BottomBarEnum.Home:
        Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
        break;
      case BottomBarEnum.Workouts:
        Navigator.of(context).pushReplacementNamed(AppRoutes.choosePlanPage);
        break;
      case BottomBarEnum.Profile:
        Navigator.of(context).pushReplacementNamed(AppRoutes.profilepagePage);
        break;
    }
  }
}

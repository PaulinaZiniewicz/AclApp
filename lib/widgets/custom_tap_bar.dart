import 'package:acl_application/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../../theme/theme_helper.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.h),
      decoration: BoxDecoration(
        color: appTheme.blueGray50,
        borderRadius: BorderRadius.circular(30.h),
      ),
      height: 40.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.h),
        child: TabBar(
          controller: tabController,
          labelPadding: EdgeInsets.zero,
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: 13.0.fSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelColor: appTheme.blueGray700,
          unselectedLabelStyle: TextStyle(
            fontSize: 13.0.fSize,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(30.h),
          ),
          dividerHeight: 0.0,
          tabs: tabs.map((tabText) {
            return Tab(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0.h,
                  vertical: 10.h,
                ),
                child: Text(tabText),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

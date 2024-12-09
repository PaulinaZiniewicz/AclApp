import 'package:acl_application/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/utils/image_constant.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../profile_page/profile_page.dart';
import 'profile_analysis.dart';
import 'profile_recommendations.dart';
import 'sleep_analysis.dart';
import 'sleep_recommendation_page.dart';
import 'training_recommendations_page.dart';
import 'traning_analysis.dart';
import 'widgets/dailygoalsection_item_widget.dart';
import 'widgets/globesection_item_widget.dart';

class DashBoardInitialPage extends StatefulWidget {
  const DashBoardInitialPage({super.key});

  @override
  DashBoardInitialPageState createState() => DashBoardInitialPageState();
}

class DashBoardInitialPageState extends State<DashBoardInitialPage> {
  String sleepSummary = "Loading sleep data...";
  String trainingSummary = "Loading training data...";
  String profileSummary = "Loading profile data...";

  @override
  void initState() {
    super.initState();
    _fetchData(); // Pobranie wszystkich danych
  }

  Future<void> _fetchData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        sleepSummary = "User not logged in.";
        trainingSummary = "User not logged in.";
        profileSummary = "User not logged in.";
      });
      return;
    }

    await Future.wait([
      _fetchSleepSummary(user.uid),
      _fetchTrainingSummary(user.uid),
      _fetchProfileSummary(user.uid),
    ]);
  }

  Future<void> _fetchSleepSummary(String userId) async {
    final analysis = SleepAnalysis();
    final result = await analysis.getSleepSummary(userId);
    setState(() {
      sleepSummary = result;
    });
  }

  Future<void> _fetchTrainingSummary(String userId) async {
    final analysis = TrainingAnalysis();
    final result = await analysis.getTrainingSummary(userId);
    setState(() {
      trainingSummary = result;
    });
  }

  Future<void> _fetchProfileSummary(String userId) async {
    final analysis = ProfileAnalysis();
    final result = await analysis.getProfileSummary();
    setState(() {
      profileSummary = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildGlobeSection(context, user),
                    SizedBox(height: 16.h),
                    //Padding(
                      //padding: EdgeInsets.only(left: 8.h),
                      //child: Text(
                       // "Daily Goal",
                       // style: theme.textTheme.titleMedium,
                     // ),
                    //),
                    SizedBox(height: 16.h),
                    //_buildDailyGoalSection(context),
                    //SizedBox(height: 44.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return const CustomAppBar(
      centerTitle: true,
      title: AppBarTitle(
        text: "Summary",
      ),
      styleType: Style.bgFill,
    );
  }

  Widget _buildGlobeSection(BuildContext context, User? user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: SingleChildScrollView(
        child: GridView.builder(
          shrinkWrap: true, // Ensures the grid adjusts to content
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200, // Adjust max width per grid item
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Allow taller widgets
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return GlobeSectionItemWidget(
                  iconPath: ImageConstant.imgBallIcon,
                  analysisText: trainingSummary,
                  onInfoPressed: () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TrainingRecommendationsPage(userId: user.uid),
                        ),
                      );
                    }
                  },
                );
              case 1:
                return GlobeSectionItemWidget(
                  iconPath: ImageConstant.imgWorkoutIcon,
                  analysisText: "Workout Analysis Coming Soon...",
                );
              case 2:
                return GlobeSectionItemWidget(
                  iconPath: ImageConstant.imgSleepIcon,
                  analysisText: sleepSummary,
                  onInfoPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SleepRecommendationsPage(),
                      ),
                    );
                  },
                );
              case 3:
                return GlobeSectionItemWidget(
                  iconPath: ImageConstant.imgProfileIcon,
                  analysisText: profileSummary,
                  onInfoPressed: () {
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileRecommendationsPage(userId: user.uid),
                        ),
                      );
                    }
                  },
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildDailyGoalSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h, right: 12.h),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 14.h);
        },
        itemCount: 1,
        itemBuilder: (context, index) {
          return const DailyGoalSectionItemWidget();
        },
      ),
    );
  }
}

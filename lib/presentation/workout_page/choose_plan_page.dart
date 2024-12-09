import 'package:flutter/material.dart';
import 'package:acl_application/presentation/workout_page/workout_plan.dart';
import 'package:acl_application/presentation/workout_page/workout_plan_detail_page.dart';
import 'package:acl_application/widgets/app_bar/appbar_title.dart';
import 'package:acl_application/widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_buttom_navigation.dart';
import 'impactful_worklist_item_widget.dart';
import 'exercises_data.dart'; // Import the new exercises data file

class ChoosePlanPage extends StatefulWidget {
  const ChoosePlanPage({super.key});

  @override
  _ChoosePlanPageState createState() => _ChoosePlanPageState();
}

class _ChoosePlanPageState extends State<ChoosePlanPage> {
  late final List<WorkoutPlan> trainingPlans;

  @override
  void initState() {
    super.initState();
    trainingPlans = getTrainingPlans(); // Fetch training plans from the new file
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
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
            Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: trainingPlans.length,
                      itemBuilder: (context, index) {
                        return ImpactfulWorkListItemWidget(
                          trainingPlan: trainingPlans[index],
                          onGoToPlan: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutPlanDetailPage(trainingPlan: trainingPlans[index]),
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) => const SizedBox(height: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: 3,
          onTap: (BottomBarEnum type) {
            // Handle bottom navigation tap
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return const CustomAppBar(
      centerTitle: true,
      title: AppBarTitle(
        text: "Choose your workout set!",
      ),
      styleType: Style.bgFill,
    );
  }
}

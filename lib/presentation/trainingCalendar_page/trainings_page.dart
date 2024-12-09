import 'package:acl_application/presentation/trainingCalendar_page/trainingCalendar_page.dart';
import 'package:acl_application/presentation/trainingCalendar_page/treningsListPage.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_tap_bar.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_buttom_navigation.dart';

class TrainingsPage extends StatefulWidget {
  const TrainingsPage({super.key});

  @override
  _TrainingsPageState createState() => _TrainingsPageState();
}

class _TrainingsPageState extends State<TrainingsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _onBottomNavTap(BottomBarEnum type) {
    setState(() {
      _selectedIndex = type.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildAppBar(context),
            CustomTabBar(
              tabController: _tabController,
              tabs: const ["Add training", "Trainings List"],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  TrainingCalendarPage(),
                  TrainingsListPage(), // Ta strona będzie nasłuchiwać na zmiany
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: _selectedIndex,
          onTap: _onBottomNavTap,
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return const CustomAppBar(
      centerTitle: true,
      title: AppBarTitle(
        text: "Trainings Tracker",
      ),
      styleType: Style.bgFill,
    );
  }
}

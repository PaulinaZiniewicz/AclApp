import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_buttom_navigation.dart';
import 'sleep_input_form.dart';
import 'sleep_summary_view.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  bool isDataSaved = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTodaySleepData();
  }

  Future<void> _fetchTodaySleepData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final date = DateTime.now().toIso8601String().split('T')[0];
    final doc = await FirebaseFirestore.instance
        .collection('sleepData')
        .doc(user.uid)
        .collection('records')
        .doc(date)
        .get();

    setState(() {
      isDataSaved = doc.exists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Tło
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Zawartość
            Column(
              children: [
                const CustomAppBar(
                  centerTitle: true,
                  title: AppBarTitle(text: 'Sleep Tracker'),
                  styleType: Style.bgFill,
                ),
                Expanded(
                  child: isDataSaved
                      ? SleepSummaryView(
                          onEdit: () {
                            setState(() {
                              isDataSaved = false;
                            });
                          },
                        )
                      : SleepInputForm(
                          onSave: () {
                            setState(() {
                              isDataSaved = true;
                              _fetchTodaySleepData(); // Odśwież dane
                            });
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: selectedIndex,
          onTap: (type) {
            setState(() {
              selectedIndex = BottomBarEnum.values.indexOf(type);
            });
          },
        ),
      ),
    );
  }
}

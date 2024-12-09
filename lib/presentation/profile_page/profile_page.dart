import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../routes/app_routes.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_buttom_navigation.dart';
import '../../widgets/custom_elevated_button.dart';
import 'custom_data_field.dart';
import 'injury_dropdown.dart';
import 'notification_time_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isSelectedSwitch = false;
  int selectedIndex = 4;

  int age = 18;
  int weight = 60;
  int height = 160;
  String selectedInjury = 'No injury';
  int notificationHour = 8;
  int notificationMinute = 0;
  String userName = "Profile";

  @override
  void initState() {
    super.initState();
    _loadUserParameters();
    _loadUserName();
  }

  Future<void> _loadUserParameters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }

    final parametersRef =
        FirebaseFirestore.instance.collection('usersParam').doc(user.uid);
    final docSnapshot = await parametersRef.get();

    if (docSnapshot.exists) {
      setState(() {
        age = docSnapshot['age'] ?? age;
        weight = docSnapshot['weight'] ?? weight;
        height = docSnapshot['height'] ?? height;
        selectedInjury = docSnapshot['selectedInjury'] ?? selectedInjury;
        isSelectedSwitch = docSnapshot['isNotificationEnabled'] ?? false;
        notificationHour = docSnapshot['notificationHour'] ?? notificationHour;
        notificationMinute = docSnapshot['notificationMinute'] ?? notificationMinute;
      });
    }
  }

  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }

    final userDataRef = FirebaseFirestore.instance.collection('usersData').doc(user.uid);

    try {
      final snapshot = await userDataRef.get();
      if (snapshot.exists) {
        setState(() {
          userName = snapshot.data()?['name'] ?? "Profile";
        });
      }
    } catch (e) {
      print("Failed to load user name from Firebase: $e");
    }
  }

  Future<void> saveUserParameters() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }

    final parametersRef =
        FirebaseFirestore.instance.collection('usersParam').doc(user.uid);

    await parametersRef.set({
      'age': age,
      'weight': weight,
      'height': height,
      'selectedInjury': selectedInjury,
      'isNotificationEnabled': isSelectedSwitch,
      'notificationHour': notificationHour,
      'notificationMinute': notificationMinute,
    }, SetOptions(merge: true));
  }

  @override
  void dispose() {
    saveUserParameters();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          title: AppBarTitle(
            text: "$userName's Profile",
          ),
          styleType: Style.bgFill,
        ),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          "Account",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 18),
                        _buildAccountColumn(context),
                        const SizedBox(height: 20),
                        Text(
                          "Notifications",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 18),
                        _buildNotificationsColumn(context),
                        Center(
                          child: CustomElevatedButton(
                            height: 40,
                            width: 300,
                            text: "Logout",
                            buttonStyle: CustomButtonStyles.fillPrimary,
                            buttonTextStyle: CustomTextStyles.titleSmallBold,
                            onPressed: () => _onTapLogout(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  Widget _buildAccountColumn(BuildContext context) {
    return Column(
      children: [
        CustomDataField(
          label: "Age",
          value: age.toString(),
          onIncrement: () => setState(() => age++),
          onDecrement: () => setState(() => age--),
        ),
        CustomDataField(
          label: "Weight",
          value: "$weight kg",
          onIncrement: () => setState(() => weight++),
          onDecrement: () => setState(() => weight--),
        ),
        CustomDataField(
          label: "Height",
          value: "$height cm",
          onIncrement: () => setState(() => height++),
          onDecrement: () => setState(() => height--),
        ),
        InjuryDropdown(
          selectedInjury: selectedInjury,
          onChanged: (String? newValue) {
            setState(() {
              selectedInjury = newValue!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNotificationsColumn(BuildContext context) {
    return NotificationTimePicker(
      isNotificationEnabled: isSelectedSwitch,
      initialHours: notificationHour,
      initialMinutes: notificationMinute,
      onToggleNotifications: (isEnabled) async {
        setState(() {
          isSelectedSwitch = isEnabled;
        });

        await FirebaseFirestore.instance
            .collection('usersParam')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'isNotificationEnabled': isEnabled,
        }, SetOptions(merge: true));
      },
      onTimeChanged: (time) async {
        setState(() {
          notificationHour = time.hour;
          notificationMinute = time.minute;
        });

        await FirebaseFirestore.instance
            .collection('usersParam')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set({
          'notificationHour': time.hour,
          'notificationMinute': time.minute,
        }, SetOptions(merge: true));
      },
    );
  }

  void _onTapLogout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, AppRoutes.startPage);
  }
}
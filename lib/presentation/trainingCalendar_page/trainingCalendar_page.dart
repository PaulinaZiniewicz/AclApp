import 'package:acl_application/core/utils/size_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';

class TrainingCalendarPage extends StatefulWidget {
  const TrainingCalendarPage({super.key});

  @override
  _TrainingCalendarPageState createState() => _TrainingCalendarPageState();
}

class _TrainingCalendarPageState extends State<TrainingCalendarPage> {
  List<DateTime?> selectedDatesFromCalendar = [];
  String _selectedTrainingType = "Stability";
  String _selectedDuration = "30 Minutes";
  bool _isCompleted = false; // Nowa zmienna do przechowywania statusu completed

  final List<String> trainingTypes = [
    "Stability",
    "Mobility",
    "Football",
    "Game",
    "Gym",
    "Stretching",
    "Beginner workout plan",
  ];
  final List<String> durations = [
    "15 Minutes",
    "30 Minutes",
    "45 Minutes",
    "1 Hour",
    "1.5 Hours"
  ];

  void _addTraining() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User is not logged in."),
      ));
      return;
    }

    if (selectedDatesFromCalendar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select a date."),
      ));
      return;
    }

    DateTime selectedDate = selectedDatesFromCalendar.first!;
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

    try {
      await FirebaseFirestore.instance
          .collection('trainings')
          .doc(user.uid)
          .collection('records')
          .doc(formattedDate)
          .set({
        'type': _selectedTrainingType,
        'duration': _selectedDuration,
        'completed': _isCompleted, // Dodano pole completed
        'date': formattedDate,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Training added successfully!"),
      ));

      setState(() {
        _selectedTrainingType = "Stability";
        _selectedDuration = "30 Minutes";
        _isCompleted = false; // Reset statusu completed
        selectedDatesFromCalendar.clear();
      });
    } catch (e) {
      print("Error adding training: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to add training."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              _buildCalendarSection(context),
              SizedBox(height: 28.h),
              _buildSelectedDateSection(context),
              SizedBox(height: 20.h),
              _buildTrainingTypeSection(context),
              SizedBox(height: 20.h),
              _buildDurationSection(context),
              SizedBox(height: 20.h),
              _buildCompletedSwitch(context), // Dodano sekcję przełącznika
              SizedBox(height: 20.h),
              _buildAddTrainingButton(context),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Container(
      height: 214.h,
      width: 298.h,
      margin: EdgeInsets.symmetric(horizontal: 12.h),
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.single,
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
          selectedDayHighlightColor: const Color(0xFFFF5582),
          firstDayOfWeek: 1,
          weekdayLabelTextStyle: TextStyle(
            color: theme.colorScheme.secondaryContainer,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          selectedDayTextStyle: const TextStyle(
            color: Color(0xFFFCFCFC),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          dayTextStyle: TextStyle(
            color: theme.colorScheme.secondaryContainer,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
          weekdayLabels: ["SU", "MO", "TU", "WE", "TH", "FR", "SA"],
        ),
        value: selectedDatesFromCalendar,
        onValueChanged: (dates) {
          setState(() {
            selectedDatesFromCalendar = dates;
          });
        },
      ),
    );
  }

  Widget _buildSelectedDateSection(BuildContext context) {
    String selectedDate = selectedDatesFromCalendar.isNotEmpty &&
            selectedDatesFromCalendar.first != null
        ? "${selectedDatesFromCalendar.first!.day}/${selectedDatesFromCalendar.first!.month}/${selectedDatesFromCalendar.first!.year}"
        : "No Date Selected";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Text(
        "Selected Date: $selectedDate",
        style: theme.textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildTrainingTypeSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Training Type:",
            style: theme.textTheme.bodyLarge,
          ),
          DropdownButton<String>(
            value: _selectedTrainingType,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTrainingType = newValue!;
              });
            },
            items: trainingTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Duration:",
            style: theme.textTheme.bodyLarge,
          ),
          DropdownButton<String>(
            value: _selectedDuration,
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _selectedDuration = newValue!;
              });
            },
            items: durations.map((String duration) {
              return DropdownMenuItem<String>(
                value: duration,
                child: Text(duration),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSwitch(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Completed:",
            style: theme.textTheme.bodyLarge,
          ),
          Switch(
            value: _isCompleted,
            onChanged: (value) {
              setState(() {
                _isCompleted = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddTrainingButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: CustomElevatedButton(
        height: 44.h,
        width: 200.h,
        text: "Add Training",
        buttonStyle: CustomButtonStyles.fillPrimary,
        buttonTextStyle: CustomTextStyles.titleSmallBold,
        onPressed: _addTraining,
      ),
    );
  }
}

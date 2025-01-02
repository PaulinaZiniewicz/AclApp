import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:async';

class NotificationTimePicker extends StatefulWidget {
  final bool isNotificationEnabled;
  final int initialHours;
  final int initialMinutes;
  final ValueChanged<bool> onToggleNotifications;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const NotificationTimePicker({
    super.key,
    required this.isNotificationEnabled,
    required this.initialHours,
    required this.initialMinutes,
    required this.onToggleNotifications,
    required this.onTimeChanged,
  });

  @override
  _NotificationTimePickerState createState() => _NotificationTimePickerState();
}

class _NotificationTimePickerState extends State<NotificationTimePicker> {
  bool isLoading = true;
  late bool isNotificationsEnabled;
  late int hours;
  late int minutes;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    isNotificationsEnabled = widget.isNotificationEnabled;
    hours = widget.initialHours;
    minutes = widget.initialMinutes;
    _loadPreferencesFromFirebase();
  }

  Future<void> _loadPreferencesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      setState(() => isLoading = false);
      return;
    }

    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('usersParam')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          isNotificationsEnabled = doc['isNotificationEnabled'] ?? isNotificationsEnabled;
          hours = doc['notificationHour'] ?? hours;
          minutes = doc['notificationMinute'] ?? minutes;
        });
      }
    } catch (e) {
      print("Failed to load notification preferences from Firebase: $e");
    }

    setState(() => isLoading = false);

    if (isNotificationsEnabled) {
      _scheduleNotification();
    }
  }

  Future<void> _scheduleNotification() async {
    if (!isNotificationsEnabled) return;

    await AwesomeNotifications().cancelAllSchedules();

    DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, hours, minutes);

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: "ACL women's prevention",
          body: 'Stay on track! Update your records regularly to monitor your progress effectively',
          notificationLayout: NotificationLayout.BigPicture,
        ),
        schedule: NotificationCalendar(
          year: scheduledTime.year,
          month: scheduledTime.month,
          day: scheduledTime.day,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: 0,
          repeats: true,
        ),
      );
      print("Notification scheduled for local time: $scheduledTime");
    } catch (e) {
      print("Failed to schedule notification: $e");
    }
  }

  Future<void> _cancelNotifications() async {
    try {
      await AwesomeNotifications().cancelAllSchedules();
      print("All notifications cancelled.");
    } catch (e) {
      print("Failed to cancel notifications: $e");
    }
  }

  void _toggleNotifications(bool value) async {
    setState(() => isNotificationsEnabled = value);
    widget.onToggleNotifications(value);

    if (value) {
      await _scheduleNotification();
    } else {
      await _cancelNotifications();
    }
    _savePreferencesToFirebase();
  }

  void _notifyTimeChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onTimeChanged(TimeOfDay(hour: hours, minute: minutes));
      if (isNotificationsEnabled) {
        _scheduleNotification();
      }
      _savePreferencesToFirebase();
    });
  }

  Future<void> _savePreferencesToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in.");
      return;
    }

    final parametersRef = FirebaseFirestore.instance.collection('usersParam').doc(user.uid);

    try {
      await parametersRef.set({
        'isNotificationEnabled': isNotificationsEnabled,
        'notificationHour': hours,
        'notificationMinute': minutes,
      }, SetOptions(merge: true));

      print("Notification preferences saved to Firebase: $hours:$minutes");
    } catch (e) {
      print("Failed to save notification preferences to Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Enable Notifications", style: Theme.of(context).textTheme.bodyLarge),
              Switch(
                value: isNotificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Notification Time", style: Theme.of(context).textTheme.bodyLarge),
              Row(
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up, size: 24),
                        onPressed: isNotificationsEnabled
                            ? () => setState(() {
                                  hours = (hours + 1) % 24;
                                  _notifyTimeChanged();
                                })
                            : null,
                      ),
                      Text(
                        hours.toString().padLeft(2, '0'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down, size: 24),
                        onPressed: isNotificationsEnabled
                            ? () => setState(() {
                                  hours = (hours - 1 + 24) % 24;
                                  _notifyTimeChanged();
                                })
                            : null,
                      ),
                    ],
                  ),
                  const Text(
                    ":",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up, size: 24),
                        onPressed: isNotificationsEnabled
                            ? () => setState(() {
                                  minutes = (minutes + 1) % 60;
                                  _notifyTimeChanged();
                                })
                            : null,
                      ),
                      Text(
                        minutes.toString().padLeft(2, '0'),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down, size: 24),
                        onPressed: isNotificationsEnabled
                            ? () => setState(() {
                                  minutes = (minutes - 1 + 60) % 60;
                                  _notifyTimeChanged();
                                })
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

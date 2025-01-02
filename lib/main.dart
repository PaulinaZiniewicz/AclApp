
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/utils/size_utils.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'theme/theme_helper.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
await AwesomeNotifications().initialize(

  'resource://drawable/res_app_icon',
  [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
      importance: NotificationImportance.High,
      channelShowBadge: true,
      defaultRingtoneType: DefaultRingtoneType.Notification,
      ledColor: Colors.white,
      defaultColor: const Color(0xFF9D50DD),
    )
  ],
  channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    )
  ],
);


  // Prośba o uprawnienia do powiadomień
  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Inicjalizacja Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          scaffoldMessengerKey: globalMessengerKey,
          theme: theme,
          title: 'zpo2_applications',
          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.startPage,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}

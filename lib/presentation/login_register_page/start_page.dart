import 'package:acl_application/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../../widgets/custom_tap_bar.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import 'register_page.dart';
import 'login_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  StartPageState createState() => StartPageState();
}

class StartPageState extends State<StartPage> with TickerProviderStateMixin {
  late TabController tabViewController;

  @override
  void initState() {
    super.initState();
    tabViewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Smaller semi-transparent background logo
            Align(
              alignment: Alignment.center, // Position the logo at the top-center or adjust as needed
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  'assets/images/logo.png', // Path to the logo image
                  width: 400.h, // Adjust width as needed
                  height: 400.h, // Adjust height as needed
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildWelcomeSection(context),
                      SizedBox(
                        height: 424.h,
                        child: TabBarView(
                          controller: tabViewController,
                          children: const [
                            LoginPage(),
                            RegisterpagePage(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return SizedBox(
      height: 142.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              centerTitle: true,
              title: AppBarTitle(
                text: "Welcome !",
              ),
              styleType: Style.bgFill,
            ),
          ),
          CustomTabBar(
            tabController: tabViewController,
            tabs: const ["Log In", "Register"],
          ),
        ],
      ),
    );
  }
}

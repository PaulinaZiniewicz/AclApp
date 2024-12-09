import 'package:flutter/material.dart';
import '../../widgets/custom_buttom_navigation.dart';
import 'dash_board_initial_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Tło z logo
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
            // Treść strony
            const DashBoardInitialPage(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigation(
          selectedIndex: 2,
          onTap: (BottomBarEnum type) {
            // Akcja na tapnięcie w dolny pasek nawigacji
          },
        ),
      ),
    );
  }
}

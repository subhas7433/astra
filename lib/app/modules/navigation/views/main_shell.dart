import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/navigation_controller.dart';
import '../../home/views/home_tab_view.dart';
import '../../horoscope/views/horoscope_tab_view.dart';
import '../../daily_content/views/numerology_tab_view.dart';
import '../../settings/views/settings_tab_view.dart';

/// Main shell with bottom navigation bar.
///
/// Features:
/// - 4 tabs: Home, Horoscope, Numerology, Settings
/// - State preservation via IndexedStack
/// - Back button handling (non-home tabs return to home, home exits app)
class MainShell extends GetView<NavigationController> {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await controller.onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Obx(() => IndexedStack(
              index: controller.currentIndex.value,
              children: const [
                HomeTabView(),
                HoroscopeTabView(),
                NumerologyTabView(),
                SettingsTabView(),
              ],
            )),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.currentIndex.value,
              onTap: controller.changeTab,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 8,
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.stars_outlined),
                  activeIcon: Icon(Icons.stars),
                  label: 'Horoscope',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.numbers_outlined),
                  activeIcon: Icon(Icons.numbers),
                  label: 'Numerology',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )),
      ),
    );
  }
}

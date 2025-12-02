import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/bindings/initial_binding.dart';
import 'app/core/services/service_locator.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/utils/app_logger.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/ad_service.dart';
import 'app/data/services/storage_service.dart';
import 'generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(AppTheme.lightSystemUI);

  AppLogger.info('App starting in ${dotenv.env['APP_ENV']} mode');

  // Initialize services (use mocks if configured)
  final useMocks = dotenv.env['USE_MOCKS']?.toLowerCase() == 'true';
  await ServiceLocator.init(useMocks: useMocks);
  
  // Initialize AdService permanently
  // AdService is initialized in InitialBinding
  
  // Initialize StorageService
  await Get.putAsync(() => StorageService().init());

  runApp(const AstroGptApp());
}

class AstroGptApp extends StatelessWidget {
  const AstroGptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Astro GPT',
      debugShowCheckedModeBanner: false,
      // Initial binding for app-wide controllers
      initialBinding: InitialBinding(),
      // Theme configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      // Localization configuration
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
      ],
      // Routing configuration (Session 5)
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      defaultTransition: AppPages.defaultTransition,
      transitionDuration: AppPages.transitionDuration,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(
          body: Center(child: Text('Page not found')),
        ),
      ),
    );
  }
}

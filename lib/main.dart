import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:loccar_agency/utils/notifiers.dart';

import 'screens/onboarding/splash_screen.dart';
import 'utils/constants.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MultipleNotifier>(
        create: (_) => MultipleNotifier([], 0),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = const {
      50: Color.fromRGBO(50, 41, 117, .1),
      100: Color.fromRGBO(50, 41, 117, .2),
      200: Color.fromRGBO(50, 41, 117, .3),
      300: Color.fromRGBO(50, 41, 117, .4),
      400: Color.fromRGBO(50, 41, 117, .5),
      500: Color.fromRGBO(50, 41, 117, .6),
      600: Color.fromRGBO(50, 41, 117, .7),
      700: Color.fromRGBO(50, 41, 117, .8),
      800: Color.fromRGBO(50, 41, 117, .9),
      900: Color.fromRGBO(50, 41, 117, 1),
    };
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Constants.primaryColor,
      // systemNavigationBarDividerColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: Constants.appName,
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        fontFamily: Constants.currentFontFamily,
        primarySwatch: MaterialColor(0xff322975, color),
        primaryColor: Constants.primaryColor,
        useMaterial3: false,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Constants.primaryColor,
            ),
            shape: WidgetStateProperty.all(
              const StadiumBorder(),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(
              Constants.primaryColor,
            ),
          ),
        ),
      ),
      locale: const Locale('fr'),
      home: const SplashScreen(),
    );
  }
}

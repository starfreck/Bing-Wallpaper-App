import 'dart:ui';

import 'package:bing_wallpaper_app/pages/home_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.deepPurple, brightness: Brightness.dark);

  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Bing Wallpaper',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(title: 'Bing Wallpaper'),
      );
    });
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

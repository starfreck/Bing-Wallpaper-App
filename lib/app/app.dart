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

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        title: 'Bing Wallpaper',
        debugShowCheckedModeBanner: false,
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
        scrollBehavior: CustomScrollBehavior(),
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

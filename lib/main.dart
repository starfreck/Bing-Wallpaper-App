import 'package:bing_wallpaper_app/app/app.dart';
import 'package:bing_wallpaper_app/cli/cli.dart';
import 'package:flutter/material.dart';

void main(List<String> arguments) {
  _runAppOrCommandLine(arguments);
}

void _runAppOrCommandLine(List<String> arguments) {
  if (arguments.isNotEmpty) {
    CommandLineArgParser(arguments: arguments);
  } else {
    runApp(const App());
  }
}

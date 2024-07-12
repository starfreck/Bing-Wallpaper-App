import 'dart:io';
import 'package:args/args.dart';
import 'package:bing_wallpaper_app/helpers/image_helper.dart';
import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:bing_wallpaper_app/services/bing_wallpaper.dart';

class CommandLineArgParser {
  List<String> arguments;
  final parser = ArgParser();

  CommandLineArgParser({required this.arguments}) {
    parser.addFlag(
      'today',
      abbr: 't',
      negatable: false,
      help: 'Set today\'s bing wallpaper.',
    );

    final argResults = parser.parse(arguments);
    if (argResults['today']) {
      executeTodayCommand();
    } else {
      printUsage();
    }
  }

  void printUsage() {
    print('No valid command provided.');
    print('Usage:');
    print('\t${parser.usage}');
  }

  void executeTodayCommand() async {
    final dateTime = DateTime.now();
    List<Photo> wallpapers = await BingWallpaper(
      location: "",
      day: dateTime.day.toString(),
      month: dateTime.month.toString(),
      year: dateTime.year.toString(),
    ).getImages();

    await PhotoHelper.setAsWallpaper(wallpapers.first.url);
    print('Setting Wallpaper...\n\t${wallpapers.first.title}');
    exit(0);
  }
}

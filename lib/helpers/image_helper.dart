import 'dart:convert';

import 'dart:io';

import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:wallman/wallman.dart';

import 'package:http/http.dart' as http;

Future<Photo> getImage({String locationCode = 'us'}) async {
  // ignore: avoid_print
  print(locationCode);

  final response = await http
      .get(Uri.parse('https://example.com/wallpaper?location=$locationCode'));
  final parsed = jsonDecode(response.body);
  return Photo.fromJson(parsed);
}

Future<String> download(String url, [String? storagePath]) async {
  try {
    late String result;
    // Get an image name
    var filename = url.split(Platform.pathSeparator).last;
    // Save to filesystem
    if (storagePath != null) {
      result = await FileSaver.instance.saveFile(
        name: filename,
        link: LinkDetails(link: url),
        filePath: storagePath,
        ext: '',
        mimeType: MimeType.other,
      );
    } else {
      result = await FileSaver.instance.saveFile(
        name: filename,
        link: LinkDetails(link: url),
        ext: '',
        mimeType: MimeType.other,
      );
    }
    return result;
    // return File(result).existsSync();
  } catch (e) {
    return "An error occurred while saving the image";
    // return false;
  }
}

Future<String> downloadImage(String url) async {
  // Call different methods according to the platform
  return await download(url);
}

void setAsWallpaper(String url) {
  if (Platform.isAndroid) {
    setAsWallpaperOnAndroid(url);
  } else if (Platform.isLinux) {
    setAsWallpaperOnLinux(url);
  }
}

/// Download image from url on Linux
Future<String> downloadImageOnLinux(String url) async {
  // Custom download path
  return await download(url);
}

/// Set image as wallpaper on Linux
void setAsWallpaperOnLinux(String url) async {
  dynamic wall = getBackend();
  String wallpaper = await downloadImageOnLinux(url);
  wall.setWall(wallpaper);
}

/// Download image from url on Android
Future<String> downloadImageOnAndroid(String url) async {
  // Custom download path
  return await download(url, "/storage/emulated/0/Download");
}

/// Set image as wallpaper on Android
Future<bool> setAsWallpaperOnAndroid(String url) async {
  int location = WallpaperManager.HOME_SCREEN;
  String wallpaper = await download(url);
  bool result = await WallpaperManager.setWallpaperFromFile(
    wallpaper,
    location,
  );
  return result;
}

/// Add more platforms ( Platform.isIOS, Platform.isMacOS, Platform.isWindows)


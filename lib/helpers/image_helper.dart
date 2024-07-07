import 'dart:io';

import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallman/wallman.dart';

// Add more platforms (Platform.isIOS, Platform.isMacOS, Platform.isWindows) if needed.

class PhotoHelper {
  Photo photo;
  PhotoHelper({required this.photo});

  /// Downloads an image from the internet and returns its local path.
  static Future<String> _download(String url, Directory storagePath) async {
    final storageIO = InternetFileStorageIO();

    final path = storagePath.path;
    final fileName = url.split("/").last;

    await InternetFile.get(
      url,
      storage: storageIO,
      storageAdditional: storageIO.additional(
        filename: fileName,
        location: path,
      ),
    );

    return '$path/$fileName';
  }

  /// Downloads an image and returns its local path based on the platform.
  static Future<String> downloadImage(String url) async {
    late Directory? appDir;
    // Set Linux downloads directory
    if (Platform.isLinux) {
      appDir = await getDownloadsDirectory();
      appDir = await Directory('${appDir!.path}/../Pictures/BingWallpapers')
          .create(recursive: true);
    } else if (Platform.isAndroid) {
      appDir = await _requestStoragePermission();
      appDir = await Directory('${appDir!.path}/BingWallpapers')
          .create(recursive: true);
    }
    print('Storage Path ${appDir!.path}');
    return await _download(url, appDir);
  }

  static Future<void> setAsWallpaper(String url) async {
    if (Platform.isAndroid) {
      await _setAsWallpaperOnAndroid(url);
    } else if (Platform.isLinux) {
      _setAsWallpaperOnLinux(url);
    }
  }

  /// Sets the image as wallpaper on Linux.
  static void _setAsWallpaperOnLinux(String url) async {
    dynamic wall = getBackend();
    String wallpaper = await downloadImage(url);
    wall.setWall(wallpaper);
  }

  /// Sets the image as wallpaper on Android.
  static Future<bool> _setAsWallpaperOnAndroid(String url) async {
    int location = WallpaperManager.HOME_SCREEN;
    String wallpaper = await downloadImage(url);
    await Future.delayed(const Duration(seconds: 10));
    bool result = await WallpaperManager.setWallpaperFromFile(
      wallpaper,
      location,
    );
    return result;
  }

  static Future<Directory?> _requestStoragePermission() async {
    PermissionStatus permissionResult =
        await Permission.manageExternalStorage.request();
    if (permissionResult == PermissionStatus.granted) {
      // Permission granted, proceed with saving files.
      print("Permission granted");
      // await getExternalStorageDirectory();
      return Directory('/storage/emulated/0/Pictures');
    } else {
      // Handle permission denied.
      print("Permission denied");
      return await getApplicationDocumentsDirectory();
    }
  }
}

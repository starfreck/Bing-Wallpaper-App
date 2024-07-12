import 'dart:io';
import 'package:background_downloader/background_downloader.dart'
    hide PermissionStatus;
import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wallman/wallman.dart';

class Download {
  String url;
  Directory? storagePath;

  Download({required this.url, required this.storagePath});
}

class PhotoHelper {
  Photo photo;

  PhotoHelper({required this.photo});

  static Future<String?> downloadImage(String url) async {
    late Directory? appDir;
    if (Platform.isLinux) {
      appDir = await getDownloadsDirectory();
      appDir = await Directory('${appDir!.path}/../Pictures/BingWallpapers')
          .create(recursive: true);
    } else if (Platform.isAndroid) {
      appDir = await _requestStoragePermission();
      appDir = await Directory('${appDir!.path}/BingWallpapers')
          .create(recursive: true);
    }

    return await _download(Download(url: url, storagePath: appDir));
  }

  static Future<void> setAsWallpaper(String url) async {
    if (Platform.isAndroid) {
      await _setAsWallpaperOnAndroid(url);
    } else if (Platform.isLinux) {
      _setAsWallpaperOnLinux(url);
    }
  }

  static Future<Directory?> _requestStoragePermission() async {
    PermissionStatus permissionResult =
        await Permission.manageExternalStorage.request();
    if (permissionResult == PermissionStatus.granted) {
      return Directory('/storage/emulated/0/Pictures');
    } else {
      return await getApplicationDocumentsDirectory();
    }
  }

  static Future<String?> _download(Download downloadTask) async {
    final path = downloadTask.storagePath!.path;
    final url = downloadTask.url.replaceAll("_480", "");
    final fileName = downloadTask.url.split("/").last;
    final task = DownloadTask(
      url: url,
      filename: fileName,
      headers: {
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36'
      },
      directory: path,
      baseDirectory: BaseDirectory.root,
      updates: Updates.statusAndProgress,
      requiresWiFi: true,
      retries: 5,
      allowPause: true,
    );

    final result = await FileDownloader().download(task,
        onProgress: (progress) => print('Progress: ${progress * 100}%'),
        onStatus: (status) => print('Status: $status'));

    switch (result.status) {
      case TaskStatus.complete:
        return '$path/$fileName';
      default:
        return null;
    }
  }

  static void _setAsWallpaperOnLinux(String url) async {
    Backend wall = getBackend();
    String? wallpaper = await downloadImage(url);
    if (wallpaper != null) {
      await wall.setWall(wallpaper);
    }
  }

  static Future<bool> _setAsWallpaperOnAndroid(String url) async {
    int location = WallpaperManager.HOME_SCREEN;
    String? wallpaper = await downloadImage(url);
    if (wallpaper != null) {
      return await WallpaperManager.setWallpaperFromFile(wallpaper, location);
    }
    return false;
  }
}

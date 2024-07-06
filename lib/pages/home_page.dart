import 'package:bing_wallpaper_app/helpers/image_helper.dart';
import 'package:bing_wallpaper_app/helpers/toast_helper.dart';
import 'package:bing_wallpaper_app/services/bing_wallpaper.dart';
import 'package:bing_wallpaper_app/widgets/bing_card_widget.dart';

import 'package:flutter/material.dart';

import '../models/photo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoading;
  late bool isError;
  late String imageTitle;
  late String imageUrl;
  late List<Photo> photos;

  @override
  void initState() {
    _isLoading = true;
    isError = false;

    imageUrl = "";
    imageTitle = "Loading...";

    photos = <Photo>[];

    _loadImages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: BingCardWidget(
            title: imageTitle,
            url: imageUrl,
            isError: isError,
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _setLocation,
            tooltip: 'Set Location',
            child: const Icon(Icons.location_on_sharp),
          ),
          const SizedBox(
            height: 15,
            width: 100,
          ),
          if (!_isLoading && !isError)
            FloatingActionButton(
              onPressed: _setAsWallpaper,
              tooltip: 'Set as wallpaper',
              child: const Icon(Icons.now_wallpaper),
            ),
          if (!_isLoading && !isError)
            const SizedBox(
              height: 15,
              width: 100,
            ),
          if (!_isLoading && !isError)
            FloatingActionButton(
              onPressed: _downloadImage,
              tooltip: 'Download',
              child: const Icon(Icons.download),
            ),
          if (!_isLoading && !isError)
            const SizedBox(
              height: 70,
              width: 100,
            )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _setLocation() {}

  void _loadImages() async {
    // Photo pic = await getImage(locationCode: 'jp');
    final dateTime = DateTime.now();
    List<Photo> wallpapers = await BingWallpaper(
      bingStore: "",
      location: "",
      day: dateTime.day.toString(),
      month: dateTime.month.toString(),
      year: dateTime.year.toString(),
    ).getImages();

    setState(() {
      _isLoading = false;

      isError = false;

      if (isError) {
        isError = true;
        imageTitle = "Something went wrong !";
        imageUrl = "";
      } else {
        photos = wallpapers;
        imageTitle = wallpapers.first.title;
        imageUrl = wallpapers.first.url;
      }
    });
  }

  void _setAsWallpaper() async {
    setAsWallpaper(imageUrl);
    _showToast("Wallpaper set successfully...");
  }

  void _downloadImage() async {
    String message = await downloadImage(imageUrl);
    _showToast(message);
  }

  void _showToast(String message) {
    Toast(
      context: context,
      message: message,
    );
  }
}

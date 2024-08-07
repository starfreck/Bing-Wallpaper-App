import 'package:bing_wallpaper_app/helpers/image_helper.dart';
import 'package:bing_wallpaper_app/helpers/toast_helper.dart';
import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:bing_wallpaper_app/services/bing_wallpaper.dart';
import 'package:bing_wallpaper_app/widgets/bing_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoading;
  late bool isError;
  late List<Photo> photos = [
    Photo(title: "Loading...", url: "", location: ""),
  ];
  int currentIndex = 0;

  final CardSwiperController controller = CardSwiperController();

  @override
  void initState() {
    _isLoading = true;
    isError = false;
    _loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CardSwiper(
          controller: controller,
          onEnd: () {
            // Call function to load more images
          },
          onSwipe: (previousIndex, currentIndex, direction) {
            // if the swipe is right then do undo
            if (direction == CardSwiperDirection.right) {
              // Set State to previous index
              setState(() {
                this.currentIndex =
                    (this.currentIndex == 0) ? 0 : this.currentIndex - 1;
              });
              controller.undo();
              return false;
            }
            // Stop swipes if we reached at the start or end
            if (currentIndex == null) {
              return false;
            }
            // Set State currentIndex only if the swipe was successful
            setState(() {
              this.currentIndex = currentIndex;
            });
            return true;
          },
          isLoop: false,
          cardsCount: photos.length,
          numberOfCardsDisplayed: 1,
          maxAngle: 10,
          allowedSwipeDirection:
              const AllowedSwipeDirection.only(left: true, right: true),
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
            return BingCardWidget(
              title: photos[currentIndex].title,
              url: photos[currentIndex].url,
              isError: isError,
            );
          }),

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
    final dateTime = DateTime.now();
    List<Photo> wallpapers = await BingWallpaper(
      location: "",
      day: dateTime.day.toString(),
      month: dateTime.month.toString(),
      year: dateTime.year.toString(),
    ).getImages();

    setState(() {
      _isLoading = false;

      if (isError) {
        isError = true;
        photos = [
          Photo(title: "Something went wrong !", url: "", location: "")
        ];
      } else {
        isError = false;
        photos = wallpapers;
      }
    });
  }

  void _setAsWallpaper() async {
    _showToast("Setting as wallpaper...");
    await PhotoHelper.setAsWallpaper(photos[currentIndex].url);
    _showToast("Wallpaper set successfully...");
  }

  void _downloadImage() async {
    _showToast("Downloading wallpaper...");
    String? message = await PhotoHelper.downloadImage(photos[currentIndex].url);
    if (message != null) {
      _showToast(message);
    } else {
      _showToast("Something went wrong with download...");
    }
  }

  void _showToast(String message) {
    Toast(
      context: context,
      message: message,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

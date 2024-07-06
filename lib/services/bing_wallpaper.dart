import 'package:intl/intl.dart';
import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class BingWallpaper {
  final String PEAPIX_URL = "https://peapix.com/bing";

  String day;
  String month;
  String year;
  late String url;
  String location;
  String bingStore;

  BingWallpaper({
    required this.bingStore,
    required this.location,
    required this.year,
    required this.month,
    required this.day,
  }) {
    location = location.isEmpty ? "us" : location;
    url = "$PEAPIX_URL/$location/$year/$month";
  }

  Future<List<Photo>> getImages() async {
    final response = await http.get(Uri.parse(url));
    final html = html_parser.parse(response.body);
    final imagesListContainers =
        html.getElementsByClassName('image-list__container');

    final photos = <Photo>[];

    for (final container in imagesListContainers) {
      final imageTitleElement =
          container.getElementsByClassName("image-list__title").first;
      final imageDateElement =
          container.getElementsByClassName("text-gray").first;
      final image =
          container.getElementsByClassName("image-list__picture").first;

      DateFormat format = DateFormat('MMMM dd yyyy');
      final dateTime = format.parse('${imageDateElement.text} $year');

      final imageDate = '${dateTime.day}';
      final imageUrl = image.attributes["data-bgset"]!.replaceFirst("_480", "");
      final imageTitle = imageTitleElement.text;

      final photo = Photo(
        location: location,
        date: imageDate,
        title: imageTitle,
        url: imageUrl,
      );

      photos.add(photo);
    }

    return photos;
  }
}

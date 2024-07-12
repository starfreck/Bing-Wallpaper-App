import 'package:html/dom.dart';
import 'package:intl/intl.dart';
import 'package:bing_wallpaper_app/models/photo.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

class BingWallpaper {
  final String baseUrl = "https://peapix.com/bing";
  final String location;
  final String year;
  final String month;
  final String day;
  late final String url;

  BingWallpaper({
    required this.location,
    required this.year,
    required this.month,
    required this.day,
  }) {
    final locationOrDefault = location.isEmpty ? "us" : location;
    url = "$baseUrl/$locationOrDefault/$year/$month";
  }

  Future<List<Photo>> getImages() async {
    final response = await http.get(Uri.parse(url));
    final html = html_parser.parse(response.body);
    final imagesListContainers =
        html.getElementsByClassName('image-list__container');

    return imagesListContainers
        .map((container) => _createPhotoFromContainer(container))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  Photo _createPhotoFromContainer(Element container) {
    final imageTitleElement =
        container.getElementsByClassName("image-list__title").first;
    final imageDateElement =
        container.getElementsByClassName("text-gray").first;
    final image = container.getElementsByClassName("image-list__picture").first;

    final dateTime =
        DateFormat('MMMM dd yyyy').parse('${imageDateElement.text} $year');
    final imageUrl = image.attributes["data-bgset"]!;
    final imageTitle = imageTitleElement.text;

    return Photo(
      location: location,
      date: dateTime,
      title: imageTitle,
      url: imageUrl,
    );
  }
}

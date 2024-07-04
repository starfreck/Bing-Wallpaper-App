class Photo {
  final String date;
  final String location;
  final String title;
  final String url;

  const Photo({
    required this.title,
    required this.url,
    required this.date,
    required this.location,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    // ignore: avoid_print
    print(json);

    Map<String, dynamic> wallpaper = json['wallpaper'];
    return Photo(
      title: wallpaper['title'] as String,
      url: wallpaper['url'] as String,
      date: wallpaper['date'] as String,
      location: wallpaper['location'] as String,
    );
  }
}

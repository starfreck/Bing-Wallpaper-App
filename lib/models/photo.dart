class Photo {
  final DateTime date;
  final String location;
  final String title;
  final String url;

  Photo({
    required this.title,
    required this.url,
    required this.location,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();
}

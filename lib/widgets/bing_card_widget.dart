import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BingCardWidget extends StatelessWidget {
  final String title;
  final String url;
  final bool isError;

  const BingCardWidget({
    Key? key,
    required this.title,
    required this.url,
    required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height - 170;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildImage(screenHeight),
            const SizedBox(height: 15),
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(double screenHeight) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: isError
          ? _buildErrorImage(screenHeight)
          : _buildNetworkImage(screenHeight),
    );
  }

  Widget _buildNetworkImage(double screenHeight) {
    return url.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: url.replaceAll("_480", "_720"),
            fit: BoxFit.cover,
            height: screenHeight,
            width: double.infinity,
            placeholder: (context, url) => _defaultImage(screenHeight),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : _defaultImage(screenHeight);
  }

  Widget _buildErrorImage(double screenHeight) {
    return ColorFiltered(
      colorFilter:
          ColorFilter.mode(Colors.red.withOpacity(0.7), BlendMode.color),
      child: _defaultImage(screenHeight),
    );
  }

  Widget _defaultImage(double screenHeight) {
    return Image.asset(
      'assets/images/default_image.png',
      fit: BoxFit.cover,
      height: screenHeight,
      width: double.infinity,
    );
  }
}

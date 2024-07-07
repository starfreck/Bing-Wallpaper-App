import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BingCardWidget extends StatelessWidget {
  final String title;
  final String url;
  final bool isError;

  const BingCardWidget({
    super.key,
    required this.title,
    required this.url,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
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
            if (!isError)
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: url.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.fitHeight,
                        height: 835,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : _defaultImage(),
              ),
            if (isError)
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.red.withOpacity(0.7), BlendMode.color),
                  child: _defaultImage(),
                ),
              ),
            const SizedBox(
              height: 15,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultImage() {
    return Image.asset(
      'assets/images/default_image.png',
      fit: BoxFit.fitHeight,
      height: 835,
      width: double.infinity,
    );
  }
}

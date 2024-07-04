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
      child: Column(
        children: [
          if (!isError)
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: url.isNotEmpty
                  ? Image.network(
                      url,
                      fit: BoxFit.fitHeight,
                      height: 845,
                      loadingBuilder: imageLoader,
                    )
                  : Image.asset(
                      'assets/images/default_image.png',
                      fit: BoxFit.fitHeight,
                      height: 845,
                    ),
            ),
          if (isError)
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.red.withOpacity(0.7), BlendMode.color),
                child: Image.asset(
                  'assets/images/default_image.png',
                  fit: BoxFit.fitHeight,
                  height: 845,
                ),
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
    );
  }

  Widget imageLoader(context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return const SizedBox(
      height: 845,
      width: double.infinity,
      child: Center(
        child: CircularProgressIndicator(
            // value: loadingProgress.expectedTotalBytes != null
            //     ? loadingProgress.cumulativeBytesLoaded /
            //         loadingProgress.expectedTotalBytes!
            //     : null,
            ),
      ),
    );
  }
}

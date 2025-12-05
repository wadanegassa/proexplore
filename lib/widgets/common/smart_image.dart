import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SmartImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;

  const SmartImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        height: height,
        width: width,
        fit: fit,
        placeholder: placeholder ??
            (context, url) => Container(
                  height: height,
                  width: width,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
        errorWidget: errorWidget ??
            (context, url, error) => Container(
                  height: height,
                  width: width,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
      );
    } else {
      return Image.asset(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          if (errorWidget != null) {
            return errorWidget!(context, imageUrl, error);
          }
          return Container(
            height: height,
            width: width,
            color: Colors.grey[200],
            child: const Icon(Icons.error),
          );
        },
      );
    }
  }
}

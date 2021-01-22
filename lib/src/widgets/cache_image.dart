import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class CacheImage extends StatefulWidget {
  String url;
  CacheImage(this.url);
  @override
  _CacheImageState createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

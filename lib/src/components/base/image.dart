import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class BaseImage extends StatefulWidget {
  final String url;
  double? width;
  double? height;
  BoxFit? fit;
  BaseImage(this.url, {this.width, this.height, this.fit, super.key});

  @override
  State<BaseImage> createState() => _BaseImageState();
}

class _BaseImageState extends State<BaseImage> {
  @override
  Widget build(BuildContext context) {
    if (widget.url.isEmpty) {
      return Container();
    }

    if (widget.url.contains("//")) {
      return Image.network(
        widget.url,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    }
    
    return Image.asset(
      widget.url,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}

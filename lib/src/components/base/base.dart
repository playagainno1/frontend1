import 'package:drrr/src/components/base/button.dart';
import 'package:drrr/src/components/base/image.dart';
import 'package:drrr/src/components/base/web_browser.dart';
import 'package:flutter/material.dart' as material;

// ignore: must_be_immutable
class Image extends BaseImage {
  Image(String url,
      {double? width, double? height, material.BoxFit? fit, super.key})
      : super(url, width: width, height: height, fit: fit);
}

class ExactButton extends BaseExactButton {
  const ExactButton(
      {required material.Widget child,
      required void Function() onPressed,
      required material.Size size,
      super.key})
      : super(child: child, onPressed: onPressed, size: size);
}

class WebBrowser extends BaseWebBrowser {
  const WebBrowser({required String title, required String url, super.key})
      : super(title: title, url: url);
}

// ignore: non_constant_identifier_names
void Toast(material.BuildContext context, String message, {int duration = 3}) {
  material.ScaffoldMessenger.of(context).showSnackBar(
    material.SnackBar(
      content: material.Center(
        child: material.Text(
          message,
          style: const material.TextStyle(
            fontSize: 16,
            fontWeight: material.FontWeight.w500,
            color: material.Color(0xFF333333),
          ),
        ),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: const material.Color(0xFFFFD06D).withOpacity(0.95),
      shape: material.RoundedRectangleBorder(
        borderRadius: material.BorderRadius.circular(10),
      ),
      behavior: material.SnackBarBehavior.floating,
      margin: material.EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: material.MediaQuery.of(context).size.height - 350,
      ),
      dismissDirection: material.DismissDirection.up,
    ),
  );
}

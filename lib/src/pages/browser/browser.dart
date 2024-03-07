import 'package:drrr/src/components/base/base.dart';

class Browser extends WebBrowser {
  const Browser({required String title, required String url, super.key})
      : super(title: title, url: url);
}

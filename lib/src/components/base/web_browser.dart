import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BaseWebBrowser extends StatefulWidget {
  final String title;
  final String url;

  const BaseWebBrowser({required this.title, required this.url, super.key});

  @override
  State<BaseWebBrowser> createState() => _BaseWebBrowserState();
}

class _BaseWebBrowserState extends State<BaseWebBrowser> {
  late final WebViewController controller;
  var pageTitle = "";

  @override
  void initState() {
    super.initState();
    debugPrint('initState BaseWebBrowser');

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(
          "Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko); compatible; DRRR-AI/1.0")
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            controller.getTitle().then((title) {
              setState(() {
                pageTitle = title ?? "";
              });
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
        title: Text(
          pageTitle.isNotEmpty ? pageTitle : widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebView extends StatefulWidget {
  final String text;

  const MyWebView({super.key, required this.text});
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView Example'),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'about:blank', // Start with a blank page
        onWebViewCreated: (WebViewController webViewController) async {
          _controller.complete(webViewController);

          await webViewController.loadHtmlString(widget.text);
        },
      ),
    );
  }
}

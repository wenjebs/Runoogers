import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebTest extends StatefulWidget {
  const WebTest({super.key});

  @override
  State<WebTest> createState() => _WebTestState();
}

class _WebTestState extends State<WebTest> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    await _controller.loadFlutterAsset('lib/assets/iframe.html');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Avatar Test'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

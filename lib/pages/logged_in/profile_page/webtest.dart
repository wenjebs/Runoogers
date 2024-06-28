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
    // Use an asynchronous operation with mounted check
    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    await _controller.loadFlutterAsset('lib/assets/iframe.html');
    if (mounted) {
      setState(() {
        // Perform state updates or operations that require the widget to be in the tree.
        // Since there's no explicit state change needed after loading the asset,
        // this setState call might be unnecessary unless there are other state changes to make.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Test'),
      ),
      body: WebViewWidget(
          controller:
              _controller), // Assuming WebViewWidget is a custom widget you've defined.
    );
  }
}

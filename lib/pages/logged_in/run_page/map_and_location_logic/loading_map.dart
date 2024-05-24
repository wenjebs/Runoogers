import 'package:flutter/material.dart';

class LoadingMap extends StatelessWidget {
  const LoadingMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("Loading"),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  State createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  Image _image = new Image.network(
    'https://flutter.io/images/flutter-mark-square-100.png',
  );
  bool _loading = true;

  @override
  void initState() {
    _image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool syncCall) => Completer));
      if (mounted) {
        setState(() {
          _loading = false;
        });
    };
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: _loading ? new Text('Loading...') : _image,
        ),
      ),
    );
  }
}
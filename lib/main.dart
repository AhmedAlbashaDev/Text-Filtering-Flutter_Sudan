import 'package:flutter/material.dart';
import 'package:text_filtering_flutter_sudan/text_filtering/text_filtering_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Text Filtering',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TextFiltering(),
    );
  }
}

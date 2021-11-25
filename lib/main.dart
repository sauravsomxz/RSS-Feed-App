import 'package:flutter/material.dart';
import 'package:flutter_rss_feeds/demo_rss.dart';

void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RSSDemo(),
    );
  }
}

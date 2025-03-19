import 'package:flutter/material.dart';
import 'navigation/main_navigation.dart';
import 'services/api_service.dart';

void main() {
  runApp(LinksiesApp());
}

class LinksiesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Linksies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainNavigation(),
    );
  }
}

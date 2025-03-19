import 'package:flutter/material.dart';
import '../models/link_item.dart';

class LinkListItem extends StatelessWidget {
  final LinkItem link;

  const LinkListItem({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          // Handle link tap - maybe open the URL or show detail
        },
        child: Text(
          link.title,
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
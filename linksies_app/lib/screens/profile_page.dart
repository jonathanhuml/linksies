import 'package:flutter/material.dart';
import '../models/link_item.dart';
import '../widgets/link_list_item.dart';
import '../widgets/link_content_item.dart';
import '../screens/add_link_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _showTitles = true; // Toggle between titles and posts view
  List<LinkItem> _links = [
    LinkItem(
      id: '1',
      title: 'Deep Tweet About movies',
      url: 'https://example.com/tweet1',
      content: 'Content about movies',
    ),
    LinkItem(
      id: '2',
      title: 'Karl and Kendall Scene',
      url: 'https://example.com/scene1',
      content: 'Scene content description',
    ),
    LinkItem(
      id: '3',
      title: 'Etc',
      url: 'https://example.com/etc1',
      content: 'Etc content',
    ),
    LinkItem(
      id: '4',
      title: 'Etc',
      url: 'https://example.com/etc2',
      content: 'Another etc content',
    ),
  ];

  void _addNewLink() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLinkPage()),
    );
    
    if (result != null) {
      setState(() {
        _links.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rick's Cafe Americain",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                ElevatedButton(
                  onPressed: _addNewLink,
                  child: Text('Add Link'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showTitles = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _showTitles ? Colors.grey : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Titles',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: _showTitles ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showTitles = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_showTitles ? Colors.grey : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Posts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: !_showTitles ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _showTitles
                ? ListView.builder(
                    itemCount: _links.length,
                    itemBuilder: (ctx, index) {
                      return LinkListItem(link: _links[index]);
                    },
                  )
                : ListView.builder(
                    itemCount: _links.length,
                    itemBuilder: (ctx, index) {
                      return LinkContentItem(link: _links[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Archive functionality
                  },
                  child: Text('Archive'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    // Arrange functionality
                  },
                  child: Text('Arrange'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
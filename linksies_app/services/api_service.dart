import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? _token;
  final http.Client _client;

  ApiService(this.baseUrl) : _client = http.Client();

  Future<void> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Link>> getLinks() async {
    if (_token == null) throw Exception('Not authenticated');

    final response = await _client.get(
      Uri.parse('$baseUrl/api/links'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['links'] as List)
          .map((link) => Link.fromJson(link))
          .toList();
    } else {
      throw Exception('Failed to load links');
    }
  }

  Future<Link> createLink(String title, String url) async {
    if (_token == null) throw Exception('Not authenticated');

    final response = await _client.post(
      Uri.parse('$baseUrl/api/links'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'title': title, 'url': url}),
    );

    if (response.statusCode == 201) {
      return Link.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create link');
    }
  }

  Future<void> deleteLink(int linkId) async {
    if (_token == null) throw Exception('Not authenticated');

    final response = await _client.delete(
      Uri.parse('$baseUrl/api/links/$linkId'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete link');
    }
  }

  Future<void> updateLinkOrder(List<int> linkIds) async {
    if (_token == null) throw Exception('Not authenticated');

    final response = await _client.put(
      Uri.parse('$baseUrl/api/links/order'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'link_ids': linkIds}),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update link order');
    }
  }

  void dispose() {
    _client.close();
  }
}

class Link {
  final int id;
  final String title;
  final String url;
  final int position;

  Link({
    required this.id,
    required this.title,
    required this.url,
    required this.position,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      position: json['position'],
    );
  }
}

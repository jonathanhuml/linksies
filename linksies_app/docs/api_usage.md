# Link Collection API Documentation

## Authentication

The API uses Bearer token authentication. To obtain a token, first authenticate using the login endpoint.

### Base URL
All endpoints are relative to: `https://your-repl-domain.replit.app`
**Important:** Always use HTTPS in production. Replit automatically provides SSL/TLS encryption when deployed.

## Flutter HTTPS Setup

### Production
When your app is deployed on Replit, HTTPS is automatically handled. Your Flutter app should use the https:// URL:

```dart
final api = ApiService('https://your-repl-domain.replit.app');
```

### Development
When testing locally with Flutter, you have two options:

1. Use Replit's deployed HTTPS endpoint (recommended):
```dart
// Always use HTTPS in production
final api = ApiService('https://your-repl-domain.replit.app');
```

2. For local testing (not recommended for production):
```dart
// Only for local development
final api = ApiService('http://localhost:5000');
```

### HTTP Client Configuration
When using the http package in Flutter, ensure proper HTTPS handling:

```dart
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
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
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
      headers: {
        'Authorization': 'Bearer $_token',
      },
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
      body: jsonEncode({
        'title': title,
        'url': url,
      }),
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
      headers: {
        'Authorization': 'Bearer $_token',
      },
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
      body: jsonEncode({
        'link_ids': linkIds,
      }),
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
```

### Best Practices for HTTPS
1. Always use HTTPS in production
2. Never disable certificate verification
3. Handle network errors appropriately
4. Close the HTTP client when done

### Usage Example
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final api = ApiService('https://your-repl-domain.replit.app');

  try {
    // Login
    await api.login('your_username', 'your_password');

    // Get links
    final links = await api.getLinks();
    print('Your links: ${links.length}');

    // Create a new link
    final newLink = await api.createLink(
      'Flutter Docs',
      'https://flutter.dev',
    );
    print('Created new link: ${newLink.title}');

    // Update link order
    await api.updateLinkOrder([newLink.id, ...links.map((l) => l.id)]);

    api.dispose(); // Important: Close the client

  } catch (e) {
    print('Error: $e');
  }
}
```

## Testing the API

You can test the API using the provided test account:
- Username: `apitester`
- Password: `test1234`

Example curl command to get an authentication token:
```bash
curl -X POST https://your-repl-domain.replit.app/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"apitester","password":"test1234"}'
```

After obtaining the token, you can use it to access protected endpoints:
```bash
curl https://your-repl-domain.replit.app/api/links \
  -H "Authorization: Bearer your_token_here"
```

## Endpoints

### Login
```http
POST /api/login
Content-Type: application/json

{
    "username": "your_username",
    "password": "your_password"
}
```

**Response**
```json
{
    "token": "your_api_token",
    "username": "your_username"
}
```

### Get User Links
```http
GET /api/links
Authorization: Bearer your_api_token
```

**Response**
```json
{
    "links": [
        {
            "id": 1,
            "title": "Example Link",
            "url": "https://example.com",
            "position": 0
        }
    ]
}
```

### Create New Link
```http
POST /api/links
Authorization: Bearer your_api_token
Content-Type: application/json

{
    "title": "New Link Title",
    "url": "https://example.com"
}
```

**Response**
```json
{
    "id": 1,
    "title": "New Link Title",
    "url": "https://example.com",
    "position": 0
}
```

### Delete Link
```http
DELETE /api/links/{link_id}
Authorization: Bearer your_api_token
```

**Response**
- Status: 204 No Content

### Update Link Order
```http
PUT /api/links/order
Authorization: Bearer your_api_token
Content-Type: application/json

{
    "link_ids": [3, 1, 2]
}
```

**Response**
- Status: 204 No Content

### Get User Profile
```http
GET /api/profile
Authorization: Bearer your_api_token
```

**Response**
```json
{
    "username": "your_username",
    "email": "your_email@example.com",
    "page_title": "My Links",
    "bio": "Your bio text"
}
```

### Update User Profile
```http
PUT /api/profile
Authorization: Bearer your_api_token
Content-Type: application/json

{
    "page_title": "New Page Title",
    "bio": "New bio text"
}
```

**Response**
```json
{
    "username": "your_username",
    "email": "your_email@example.com",
    "page_title": "New Page Title",
    "bio": "New bio text"
}
```

## Error Responses

All error responses follow this format:
```json
{
    "error": "Error message description"
}
```

Common HTTP Status Codes:
- 200: Success
- 201: Created
- 204: No Content
- 400: Bad Request
- 401: Unauthorized
- 403: Forbidden
- 404: Not Found
- 500: Internal Server Error
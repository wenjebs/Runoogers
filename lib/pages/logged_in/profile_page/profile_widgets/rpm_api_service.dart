import 'dart:convert';
import 'package:http/http.dart' as http;

class RpmApiService {
  final String baseUrl;
  String? token;

  RpmApiService({required this.baseUrl});

  Future<Map<String, dynamic>> createAnonUser() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      token = data['token'];
      return data;
    } else {
      throw Exception('Failed to create anonymous user');
    }
  }

  Future<List<Map<String, dynamic>>> fetchTemplates() async {
    final response = await http.get(
      Uri.parse('https://api.readyplayer.me/v2/avatars/templates'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
    } else {
      throw Exception('Failed to fetch templates, ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> createDraftAvatar(String templateId) async {
    final response = await http.post(
      Uri.parse('https://api.readyplayer.me/v2/avatars/templates/$templateId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'partner': 'default',
        'bodyType': 'fullbody',
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception(
          'Failed to create draft avatar, ${response.statusCode}, $token');
    }
  }

  Future<void> saveAvatar(String avatarId) async {
    final response = await http.put(
      Uri.parse('https://api.readyplayer.me/v2/avatars/$avatarId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save avatar');
    }
  }

  Future<http.Response> fetchAvatar(String avatarId) async {
    return await http.get(
      Uri.parse('https://models.readyplayer.me/$avatarId.glb'),
    );
  }
}

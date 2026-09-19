import 'dart:convert';
import 'package:http/http.dart' as http;

class AudiusService {
  final String baseUrl = "https://api.audius.co/v1";
  final String appName = "ZYNC"; // Required by Audius

  Future<List<dynamic>> fetchTrendingTracks() async {
    final url = Uri.parse('$baseUrl/tracks/trending?app_name=$appName&offset=5&limit=15&time=month');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Returns a list of tracks with IDs and metadata
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<dynamic>> fetchLatestTracks() async {
    final url = Uri.parse('$baseUrl/tracks/latest?app_name=$appName&offset=5&limit=12');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Returns a list of tracks with IDs and metadata
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<dynamic>> fetchTrendingsInMonth() async {
    final url = Uri.parse('$baseUrl/playlists/trending?app_name=$appName&offset=5&limit=10&time=month&type=playlist&omit_tracks=false');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Returns a list of tracks with IDs and metadata
    } else {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<dynamic>> fetchPopularAlbumOfWeek() async {
    final url = Uri.parse('$baseUrl/playlists/trending?app_name=$appName&offset=4&limit=13&time=week&type=album&omit_tracks=false');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']; // Returns a list of tracks with IDs and metadata
    } else {
      throw Exception('Failed to load tracks');
    }
  }
}

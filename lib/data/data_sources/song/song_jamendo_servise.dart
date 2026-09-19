// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // class JamendoService {
 
  

// //   Future<List<dynamic>> fetchTrendingTracks() async {
 
// //      final String baseUrl = "https://api.jamendo.com/v3.0";
// //   final String clientId  = "09c2f572"; // Required by Jamendo

// //   //    Map<String, String> queryParameters = {
// //   //   'client_id': clientId, // 👈 Insert your Client ID here
// //   //   'format': 'json',
// //   //   'order': 'popularity_week',
// //   //   'limit': '10',
// //   // };

// //       try {
// //        final url = Uri.parse('$baseUrl/tracks?client_id=$clientId');
// //     final response = await http.get(url);
// //      final Map<String, dynamic> data = json.decode(response.body);

// //     if (data["headers"]["status"] == "success") {
// //       print("jjpk: $data");
// //       return data['results'];
// //     } else {
// //       print(data["headers"]["error_message"]);
// //       throw Exception(data["headers"]["error_message"]);
// //     }
// //   } catch (e) {
// //     throw Exception('Error fetching songs: $e');
// //   }
// // }

// //   }


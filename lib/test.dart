// // import 'package:dart_ytmusic_api/yt_music.dart';
// import 'package:flutter/material.dart';
// import 'package:ytmusicapi_dart/ytmusicapi_dart.dart';
// import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:just_audio/just_audio.dart';

// void main() => runApp(const MaterialApp(home: MusicHomePage()));

// class MusicHomePage extends StatefulWidget {
//   const MusicHomePage({super.key});

//   @override
//   State<MusicHomePage> createState() => _MusicHomePageState();
// }

// class _MusicHomePageState extends State<MusicHomePage> {

//   YTMusic? _ytMusic;
//   final YoutubeExplode _ytExplode = YoutubeExplode();
//   final AudioPlayer _audioPlayer = AudioPlayer();

//   final TextEditingController _searchController = TextEditingController();

//   List<dynamic> _homepageSongs = [];
//   List<dynamic> _searchResults = [];
//   bool _isSearching = false;
//   bool _isLoadingHome = true;
//   String? _currentlyPlayingId;

//   @override
//   void initState() {
//     super.initState();
//     _initializeMusic();
//   }

//   Future<void> _initializeMusic() async {
//     await _ytMusicInit();
//     await _loadFreshHomeFeed();
//   }

//   Future<void> _ytMusicInit() async {
//     try {
//       _ytMusic = await YTMusic.create();
//     } catch (e) {
//       debugPrint('Failed to communicate with YouTube Music: $e');
//     }
//   }

//   // Fetches fresh content from the YouTube Music homepage feed
//   Future<void> _loadFreshHomeFeed() async {
//     try {
//       if (_ytMusic == null) return;
//       setState(() => _isLoadingHome = true);

//       final homeSections = await _ytMusic!.getHome();
//       List<dynamic> collectedSongs = [];

//       // Extract songs safely out of the home response carousels
//       for (var section in homeSections) {
//         if (section['contents'] != null) {
//           for (var item in section['contents']) {
//             // Target tracks and videos specifically, ignoring playlists or albums
//             if (item['type'] == 'song' || item['type'] == 'video') {
//               collectedSongs.add(item);
//             }
//           }
//         }
//       }

//       // Fallback to trend charts if the direct home feed sections came back empty
//       if (collectedSongs.isEmpty) {
//         final charts = await _ytMusic!.getCharts();
//         collectedSongs = charts['songs']?['items'] ?? [];
//       }

//       setState(() {
//         _homepageSongs = collectedSongs;
//         _isLoadingHome = false;
//       });
//     } catch (e) {
//       debugPrint("Error auto-loading feed: $e");
//       setState(() => _isLoadingHome = false);
//     }
//   }

//   // Fires dynamically whenever a user types into the input box
//   Future<void> _searchMusic(String query) async {
//     if (query.trim().isEmpty) {
//       setState(() => _isSearching = false);
//       return;
//     }

//     if (_ytMusic == null) return;

//     setState(() => _isSearching = true);
//     try {
//       final results = await _ytMusic!.search(query, filter: .songs);
//       setState(() {
//         _searchResults = results;
//       });
//     } catch (e) {
//       debugPrint("Search execution failure: $e");
//     }
//   }

//   // Audio stream decoding + playback pipeline
//   Future<void> _playSong(String videoId) async {
//     try {
//       setState(() => _currentlyPlayingId = videoId);

//       debugPrint('Playing: $videoId');

//       final manifest = await _ytExplode.videos.streamsClient.getManifest("9udQlSp6iEQ",  
//       ytClients: [
//         //  YoutubeApiClient.androidSdkless,
//     // YoutubeApiClient.ios,
//     // YoutubeApiClient.safari,
//     // YoutubeApiClient.tv,
//     YoutubeApiClient.android
//       ],
//       );

//       debugPrint('Audio streams: ${manifest.audioOnly.length}');
      

//       print("manifest $manifest");

//       if (manifest.audioOnly.isEmpty) {
//       print('No audio streams available for this video ID.');
     
//     }

//     print("Audio streams:");
// for (final s in manifest.audioOnly) {
//   print(
//     "itag=${s.tag} "
//     "bitrate=${s.bitrate} "
//     "container=${s.container.name}"
//   );
// }

//       // final audioStream = manifest.audioOnly.withHighestBitrate();
//       final m4aStreams  = manifest.audioOnly.where((stream) => stream.tag == 140);
     
//   var audioStream = m4aStreams.firstOrNull;

//      if (audioStream == null) {
//       debugPrint('itag 140 not available');
//       return;
//     }

//       final streamUrl = audioStream.url;
//  print("streamUrl.path $streamUrl");
//       if (streamUrl.hasEmptyPath) {
//         debugPrint('No valid audio stream found for videoId: $videoId');
//         return;
//       }

//        await _audioPlayer.stop();

//       debugPrint('Playing audio stream for videoId: $videoId');
//     //   await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(streamUrl.path)));
//     print("Selected tag: ${audioStream.tag}");
// print("Container: ${audioStream.container.name}");
// print("Bitrate: ${audioStream.bitrate}");
// print("URL: ${audioStream.url}");
//       await _audioPlayer.setUrl(
//       streamUrl.toString(),
//     //   headers: {
//     //      "User-Agent":
//     //     "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
//     // "Referer": "https://music.youtube.com/",
//     // "Origin": "https://music.youtube.com",
//     //     // 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
//     //     //  "User-Agent":
//     //     // "com.google.android.apps.youtube.vr.oculus/1.60.19 (Linux; U; Android 12L; Quest 3 Build/SQ3A.220605.009.A1) gzip"
//     //   },
//     );
//       print("streamUrlll ${streamUrl.path}");
//       await _audioPlayer.play();
//     }  catch (e) {
//       debugPrint("Audio engine errorr: $e");
      
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _ytExplode.close();
//     _audioPlayer.dispose();
//     _ytMusic?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final activeList = _isSearching ? _searchResults : _homepageSongs;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Discover Music'),
//         backgroundColor: Colors.black87,
//       ),
//       body: Column(
//         children: [
//           // Persistent top search bar
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TextField(
//               controller: _searchController,
//               onChanged: _searchMusic,
//               style: const TextStyle(color: Colors.black87),
//               decoration: InputDecoration(
//                 hintText: "Search your songs here...",
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             ),
//           ),
          
//           // Section Title Banner
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 _isSearching ? "Search Results" : "Fresh Tracks For You",
//                 style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),

//           // Adaptive List Presentation Window
//           Expanded(
//             child: _isLoadingHome && !_isSearching
//                 ? const Center(child: CircularProgressIndicator())
//                 : activeList.isEmpty
//                     ? const Center(child: Text("No songs to display."))
//                     : ListView.builder(
//                         itemCount: activeList.length,
//                         itemBuilder: (context, index) {
//                           final song = activeList[index];
//                           final videoId = song['videoId'];
//                           final isCurrent = _currentlyPlayingId == videoId;

//                           return ListTile(
//                             leading: song['thumbnails'] != null && song['thumbnails'].isNotEmpty
//                                 ? Image.network(song['thumbnails'][0]['url'] ?? '', width: 50, height: 50, fit: BoxFit.cover)
//                                 : const Icon(Icons.music_note),
//                             title: Text(song['title'] ?? 'New Track', maxLines: 1, overflow: TextOverflow.ellipsis),
//                             subtitle: Text(song['artists'] is List && song['artists'].isNotEmpty 
//                                 ? song['artists'][0]['name'] ?? 'Unknown Artist'
//                                 : 'Various Artists'),
//                             trailing: isCurrent 
//                                 ? const Icon(Icons.volume_up, color: Colors.green)
//                                 : const Icon(Icons.play_circle_fill),
//                             onTap: () => _playSong(videoId),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// // class TestP extends StatefulWidget {
// //   const TestP({super.key});

// //   @override
// //   State<TestP> createState() => _TestPState();
// // }

// // class _TestPState extends State<TestP> {

// //   final controller = YoutubePlayerController.fromVideoId(videoId: "Nl8jRJJIySE",
// //   // initialVideoId: '<video-id>',
// //  autoPlay: true,
// //  params: YoutubePlayerParams(mute: false,)
// // );
// //   @override
// //   Widget build(BuildContext context) {
// //     return YoutubePlayer(
// //   controller: controller,
// //   // showVideoProgressIndicator: true,
// //   // progressIndicatorColor: Colors.red,
// // );
// //   }
// // }
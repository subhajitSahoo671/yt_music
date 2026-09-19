import 'package:audio_service/audio_service.dart';
  import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yt_music/core/services/my_audio_handler.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const justAudioChannel = MethodChannel('com.ryanheise.just_audio.methods');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(justAudioChannel, (call) async => null);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(justAudioChannel, null);
  });

  test('initSongs replaces the queue instead of duplicating it', () async {
    final handler = MyAudioHandler();
    final songs = [
      MediaItem(id: 'https://example.com/track1.mp3', title: 'Track 1', artist: 'Artist 1'),
      MediaItem(id: 'https://example.com/track2.mp3', title: 'Track 2', artist: 'Artist 2'),
    ];

    await handler.initSongs(songs: songs);
    await handler.initSongs(songs: songs);

    expect(handler.queue.value.length, equals(songs.length));
    expect(handler.mediaItem.value?.id, equals(songs.first.id));

    handler.dispose();
  });
}

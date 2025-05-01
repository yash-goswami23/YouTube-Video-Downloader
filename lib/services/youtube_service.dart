import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:native_youtube_download_manager/models/video_info_model.dart';

import 'package:native_youtube_download_manager/utils/custom_toast.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

  static Future<VideoInfoModel> fetchVideo(String url) async {
    try {
      final video = await _yt.videos.get(url);
      final videoInfo = VideoInfoModel(
        title: video.title,
        thumbnailUrl: video.thumbnails.highResUrl,
        videoId: video.id.value,
      );
      return videoInfo;
    } catch (e) {
      throw Exception("Failed to fetch video info: $e");
    }
  }

  static Future<List<String>> getResolutions(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);

      final muxedStreams = manifest.videoOnly;
      if (muxedStreams.isEmpty) {
        throw Exception("❌ No downloadable video streams found.");
      }

      final resolutions =
          muxedStreams
              .map((stream) {
                return stream.videoQualityLabel;
              })
              .toSet()
              .toList();

      return resolutions;
    } catch (e) {
      showToast("Error getting resolutions: $e");
      rethrow;
    }
  }

  static Future<void> downloadVideo({
    required String videoId,
    required String title,
    required String selectedResolution,
    required void Function(double) onProgress,
    required VoidCallback onDone,
    required void Function(String) onError,
  }) async {
    try {
      final outputDir = await FilePicker.platform.getDirectoryPath();
      if (outputDir == null) {
        onError("No folder selected.");
        return;
      }
      //  final outputDir = dir.path;
      await Directory(outputDir).create(recursive: true);

      final manifest = await _yt.videos.streamsClient.getManifest(videoId);

      final videoStreamInfo = manifest.videoOnly.firstWhere(
        (e) => e.videoQualityLabel == selectedResolution,
        orElse: () => throw Exception("Resolution not found"),
      );

      final safeTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final videoPath = '$outputDir/${safeTitle}_video.mp4';

      final file = File(videoPath).openWrite();
      final stream = _yt.videos.streamsClient.get(videoStreamInfo);

      final totalBytes = videoStreamInfo.size.totalBytes;
      int receivedBytes = 0;

      await for (final chunk in stream) {
        if (chunk.isEmpty) continue;
        file.add(chunk);
        receivedBytes += chunk.length;
        onProgress(receivedBytes / totalBytes);
      }

      await file.flush();
      await file.close();

      onDone();
    } catch (e) {
      onError("Download failed: $e");
    }
  }
}

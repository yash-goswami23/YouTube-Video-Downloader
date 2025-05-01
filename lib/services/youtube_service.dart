// import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:native_youtube_download_manager/models/video_info_model.dart';
// import 'package:native_youtube_download_manager/services/storage_service.dart';
import 'package:native_youtube_download_manager/utils/custom_toast.dart';
import 'package:native_youtube_download_manager/utils/merge_audio_video.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
// import 'package:path/path.dart' as p;

class YoutubeService {
  static final YoutubeExplode _yt = YoutubeExplode();

  static Future<VideoInfoModel> fetchVideo(String url) async {
    try {
      print("error Start");
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

      // Use muxed (video + audio) for user-friendly downloadable formats
      final muxedStreams = manifest.videoOnly;
      if (muxedStreams.isEmpty) {
        throw Exception("❌ No downloadable video streams found.");
      }

      // Extract unique resolution labels like 1080p, 720p
      final resolutions =
          muxedStreams
              .map((stream) {
                print("stream.videoQualityLabe ${stream.videoQualityLabel}");
                return stream.videoQualityLabel;
              })
              .toSet()
              .toList();

      print("✅ Available resolutions: $resolutions");
      return resolutions;
    } catch (e) {
      showToast("Error getting resolutions: $e");
      rethrow;
    }
  }

  //  static Future<void> downloadVideo({
  //     required String videoId,
  //     required String title,
  //     required String selectedResolution,
  //     required void Function(double) onProgress,
  //     required VoidCallback onDone,
  //     required void Function(String) onError,
  //   }) async {
  //     final outputDir = await FilePicker.platform.getDirectoryPath();
  //     if (outputDir == null) {
  //       onError("No folder selected.");
  //       return;
  //     }

  //     try {
  //       final manifest = await _yt.videos.streamsClient.getManifest(videoId);
  //       final videoStreamInfo = manifest.videoOnly.firstWhere(
  //         (e) => e.videoQualityLabel == selectedResolution,
  //         orElse: () => throw Exception("Selected resolution not found."),
  //       );
  //       final audioStreamInfo = manifest.audioOnly.withHighestBitrate();

  //       if (audioStreamInfo == null || audioStreamInfo.size.totalBytes == 0) {
  //         throw Exception("Audio stream not found or empty");
  //       }

  //       final safeTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '_');
  //       final videoPath = '$outputDir/${safeTitle}_video.mp4';
  //       final audioPath = '$outputDir/${safeTitle}_audio.mp4';
  //       final outputPath = '$outputDir/$safeTitle.mp4';

  //       final videoFile = File(videoPath).openWrite();
  //       final videoStream = _yt.videos.streamsClient.get(videoStreamInfo);
  //       final totalVideo = videoStreamInfo.size.totalBytes;
  //       int videoCount = 0;
  //       await for (final chunk in videoStream) {
  //         if (chunk.isEmpty) continue;
  //         videoFile.add(chunk);
  //         videoCount += chunk.length;
  //         onProgress((videoCount / totalVideo) * 0.5);
  //       }
  //       await videoFile.flush();
  //       await videoFile.close();

  //       final audioFile = File(audioPath).openWrite();
  //       final audioStream = _yt.videos.streamsClient.get(audioStreamInfo);
  //       final totalAudio = audioStreamInfo.size.totalBytes;
  //       int audioCount = 0;
  //       await for (final chunk in audioStream) {
  //         if (chunk.isEmpty) continue;
  //         audioFile.add(chunk);
  //         audioCount += chunk.length;
  //         onProgress(0.5 + (audioCount / totalAudio) * 0.5);
  //       }
  //       await audioFile.flush();
  //       await audioFile.close();

  //       final merged = await mergeAudioVideo(videoPath, audioPath, outputPath);
  //       if (!merged) throw Exception("Merging failed");

  //       await File(videoPath).delete();
  //       await File(audioPath).delete();

  //       onProgress(1.0);
  //       onDone();
  //     } catch (e) {
  //       try {
  //         final fallback = await _yt.videos.streamsClient.getManifest(videoId);
  //         final muxed = fallback.muxed.firstWhere(
  //           (s) => s.videoQualityLabel == selectedResolution,
  //           orElse: () => fallback.muxed.withHighestBitrate(),
  //         );

  //         final fallbackPath = '$outputDir/$title.mp4';
  //         final fallbackFile = File(fallbackPath).openWrite();
  //         final stream = _yt.videos.streamsClient.get(muxed);
  //         final total = muxed.size.totalBytes;
  //         int count = 0;

  //         await for (final chunk in stream) {
  //           if (chunk.isEmpty) continue;
  //           fallbackFile.add(chunk);
  //           count += chunk.length;
  //           onProgress(count / total);
  //         }
  //         await fallbackFile.flush();
  //         await fallbackFile.close();

  //         onProgress(1.0);
  //         onDone();
  //       } catch (err) {
  //         onError("Download failed: $err");
  //       }
  //     }
  //   }

  static Future<void> downloadVideo({
    required String videoId,
    required String title,
    required String selectedResolution,
    required void Function(double) onProgress,
    required VoidCallback onDone,
    required void Function(String) onError,
  }) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        onError("No valid directory");
        return;
      }

      final outputDir = dir.path;
      await Directory(outputDir).create(recursive: true);

      final manifest = await _yt.videos.streamsClient.getManifest(videoId);

      final videoStreamInfo = manifest.videoOnly.firstWhere(
        (e) => e.videoQualityLabel == selectedResolution,
        orElse: () => throw Exception("Resolution not found"),
      );

      // final audioStreamInfo = manifest.audioOnly.withHighestBitrate();

      final safeTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '_');
      final videoPath = '$outputDir/${safeTitle}_video.mp4';
      // final audioPath = '$outputDir/${safeTitle}_audio.mp4';
      // final outputPath = '$outputDir/$safeTitle.mp4';

      // final manifest = await _yt.videos.streamsClient.getManifest(videoId);

      // final videoStreamInfo = manifest.videoOnly.firstWhere(
      //   (stream) => stream.qualityLabel == selectedResolution,
      //   orElse: () => throw Exception("Selected resolution not found."),
      // );

      // final safeTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '_');
      // final filePath = '$outputDir/$safeTitle.mp4';

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

      /// ✅ FINAL callback — ONLY after writing fully completes
      // onProgress(1.0);
      onDone();
    } catch (e) {
      onError("Download failed: $e");
    }
  }
}

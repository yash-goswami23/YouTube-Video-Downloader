import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_youtube_download_manager/services/storage_service.dart';
import '../models/video_info_model.dart';
import '../services/youtube_service.dart';
// import '../services/storage_service.dart';
import '../utils/custom_toast.dart';

class HomeController extends GetxController {
  final isEmpty = true.obs;
  final isLoading = false.obs;
  var isDownloading = false.obs;
  var downloadProgress = 0.0.obs;
  var downloadMessage = "Preparing to download...".obs;
  var downloadingVideo = Rxn<VideoInfoModel>();
  var downloadedVideos = <VideoInfoModel>[].obs;
  final resolutions = <String>[].obs;
  final selectedResolution = ''.obs;

  final videoInfo = Rxn<VideoInfoModel>();
  final urlController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    downloadedVideos.assignAll(StorageService.getDownloadedVideos());
  }

  Future<void> pasteUrl() async {
    final pasteValue = await FlutterClipboard.paste();
    urlController.text = pasteValue;
    isEmpty.value = false;
    showToast(urlController.text.toString());
  }

  clearUrl() {
    urlController.clear();
    isEmpty.value = true;
  }

  Future<void> fetchVideoInfo() async {
    final url = urlController.text.trim();
    if (!url.contains('youtube.com') && !url.contains('youtu.be')) {
      showToast("Invalid YouTube URL");
      return;
    }

    isLoading.value = true;
    try {
      final info = await YoutubeService.fetchVideo(url);

      print("error info: ${info.toJson()}");
      videoInfo.value = info;
      selectedResolution.value = "Auto";
      await fetchResolutions(info.videoId);
    } catch (e) {
      print("error is: $e");
      showToast("Error fetching video: $e");
    }
    isLoading.value = false;
  }

  Future<void> fetchResolutions(String videoId) async {
    try {
      final available = await YoutubeService.getResolutions(videoId);
      if (available.isNotEmpty) {
        resolutions.assignAll(available);
        selectedResolution.value = available.first;
      } else {
        showToast("No resolutions found");
      }
    } catch (e) {
      showToast("Error fetching resolutions: $e");
    }
  }

  Future<void> startDownload(VideoInfoModel model) async {
    downloadingVideo.value = model;
    isDownloading.value = true;
    downloadProgress.value = 0.0;

    YoutubeService.downloadVideo(
      videoId: model.videoId,
      title: model.title,
      selectedResolution: selectedResolution.value,
      onProgress: (progress) => downloadProgress.value = progress,
      onDone: () {
        downloadProgress.value = 1.0;
        isDownloading.value = false;
        downloadingVideo.value = null;
        downloadedVideos.add(
          VideoInfoModel(
            title: model.title,
            thumbnailUrl: model.thumbnailUrl,
            videoId: model.videoId,
            path: model.path,
          ),
        );
        StorageService.saveDownloadedVideo(
          VideoInfoModel(
            title: model.title,
            thumbnailUrl: model.thumbnailUrl,
            videoId: model.videoId,
            path: model.path,
          ),
        );
        showToast("✅ Download Completed!");
      },
      onError: (msg) {
        showToast(msg);
        isDownloading.value = false;
      },
    );
  }
}

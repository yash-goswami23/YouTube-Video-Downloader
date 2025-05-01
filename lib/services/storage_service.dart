import 'package:get_storage/get_storage.dart';
import 'package:native_youtube_download_manager/models/video_info_model.dart';

class StorageService {
  static final _storage = GetStorage();
  static const _key = 'downloaded_videos';

  static Future<void> saveDownloadedVideo(VideoInfoModel video) async {
    final List saved = _storage.read<List>(_key) ?? [];
    saved.add(video.toJson());
    await _storage.write(_key, saved);
  }

  static List<VideoInfoModel> getDownloadedVideos() {
    final List saved = _storage.read<List>(_key) ?? [];
    return saved.map((e) => VideoInfoModel.fromJson(e)).toList();
  }
}

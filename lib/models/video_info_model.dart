class VideoInfoModel {
  final String title;
  final String thumbnailUrl;
  final String videoId;
  final String? path;

  VideoInfoModel({
    required this.title,
    required this.thumbnailUrl,
    required this.videoId,
    this.path,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      
      'videoId': videoId,
      'path': path,
    };
  }

  factory VideoInfoModel.fromMap(Map<String, dynamic> map) {
    return VideoInfoModel(
      title: map['title'],
      thumbnailUrl: map['thumbnailUrl'],
      videoId: map['videoId'],
      path: map['path'],
    );
  }
  Map<String, dynamic> toJson() => {
  "title": title,
  "thumbnailUrl": thumbnailUrl,
  "videoId": videoId,
  "path": path,
};

factory VideoInfoModel.fromJson(Map<String, dynamic> json) {
  return VideoInfoModel(
    title: json['title'],
    thumbnailUrl: json['thumbnailUrl'],
    videoId: json['videoId'],
    path: json['path'],
  );
}

}

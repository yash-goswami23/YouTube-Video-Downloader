import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';

Future<bool> mergeAudioVideo(String videoPath, String audioPath, String outputPath) async {
  final command = '-i "$videoPath" -i "$audioPath" -c:v copy -c:a aac -strict experimental "$outputPath"';

  final session = await FFmpegKit.execute(command);
  final returnCode = await session.getReturnCode();

  if (ReturnCode.isSuccess(returnCode)) {
    print("✅ Merge successful");
    return true;
  } else {
    final log = await session.getAllLogsAsString();
    print("❌ FFmpeg merge failed: $log");
    return false;
  }
}

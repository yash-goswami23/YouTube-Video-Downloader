import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import '../controllers/home_controllers.dart';

class DownloadHistoryScreen extends StatelessWidget {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download Status"),
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      body: Obx(() {
        final downloading = controller.downloadingVideo.value;
        final progress = controller.downloadProgress.value;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (downloading != null)
              Card(
                elevation: 3,
                child: ListTile(
                  leading: CircularProgressIndicator(value: progress),
                  title: Text(downloading.title),
                  subtitle: Text(
                    "Downloading... ${(progress * 100).toStringAsFixed(1)}%",
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text("📂 No current download in progress."),
              ),

            const SizedBox(height: 20),
            if (controller.downloadedVideos.isNotEmpty)
              const Text(
                "Downloaded Videos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

            ...controller.downloadedVideos.map(
              (video) => GestureDetector(
                onTap: () {
                  OpenFile.open(video.path);
                },

                child: Card(
                  color: Colors.green.shade50,
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text(video.title),
                    subtitle: const Text("Status: Completed"),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

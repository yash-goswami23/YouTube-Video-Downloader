import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_youtube_download_manager/controllers/home_controllers.dart';
import 'package:native_youtube_download_manager/screens/download_list_screen.dart';
import 'package:native_youtube_download_manager/widgets/btn.dart';
import 'package:native_youtube_download_manager/widgets/video_card.dart';

class HomeScreenNew extends StatelessWidget {
  HomeScreenNew({super.key});

  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Youtube Downloader'),
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          IconButton(
            onPressed: () => Get.to(DownloadHistoryScreen()),
            icon: Icon(Icons.download),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: TextField(
                          controller: controller.urlController,

                          decoration: InputDecoration(
                            labelText: 'Enter YouTube URL',
                            suffixIcon: IconButton(
                              onPressed: () async {
                                if (controller.isEmpty.value) {
                                  controller.pasteUrl();
                                } else {
                                  controller.clearUrl();
                                }
                              },
                              icon:
                                  controller.isEmpty.value
                                      ? Icon(Icons.paste)
                                      : Icon(Icons.clear),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.amber),
                            ),
                          ),
                        ),
                      ),

                      if (controller.isLoading.value)
                        CircularProgressIndicator.adaptive()
                      else if (controller.videoInfo.value != null)
                        VideoCard(
                          thumbnailUrl:
                              controller.videoInfo.value!.thumbnailUrl,
                          title: controller.videoInfo.value!.title,
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  btn(onTap: controller.fetchVideoInfo, txt: "Search Video"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

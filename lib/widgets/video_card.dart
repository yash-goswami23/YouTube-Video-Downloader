import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:native_youtube_download_manager/controllers/home_controllers.dart';
import 'package:native_youtube_download_manager/screens/download_list_screen.dart';

class VideoCard extends StatelessWidget {
  final String thumbnailUrl;
  final String title;

  const VideoCard({super.key, required this.thumbnailUrl, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(thumbnailUrl),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          ResolutionCard(),
        ],
      ),
    );
  }
}

class ResolutionCard extends StatefulWidget {
  const ResolutionCard({super.key});

  @override
  State<ResolutionCard> createState() => _ResolutionCardState();
}

class _ResolutionCardState extends State<ResolutionCard> {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Resolution:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Obx(
              () => DropdownButton<String>(
                value:
                    controller.selectedResolution.value.isEmpty
                        ? null
                        : controller.selectedResolution.value,

                items:
                    controller.resolutions
                        .map(
                          (res) =>
                              DropdownMenuItem(value: res, child: Text(res)),
                        )
                        .toList(),
                onChanged: (value) {
                  controller.selectedResolution.value = value ?? '';
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap:
              controller.selectedResolution.value.isEmpty
                  ? null
                  : () async {
                    controller.startDownload(controller.videoInfo.value!);
                    await Future.delayed(Duration(milliseconds: 100));
                    Get.to(DownloadHistoryScreen());
                  },
          child: Container(
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color:
                  controller.selectedResolution.value.isEmpty
                      ? Colors.grey
                      : Colors.amber,
            ),
            child: Text(
              "Download",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    controller.selectedResolution.value.isEmpty
                        ? Colors.black45
                        : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

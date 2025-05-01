import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:native_youtube_download_manager/bindings/home_binding.dart';
import 'package:native_youtube_download_manager/screens/home_screen_new.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await handleStoragePermission();

  runApp(const MainApp());
}

Future<void> handleStoragePermission() async {
  if (Platform.isAndroid) {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
    } else {
      openAppSettings(); // optional fallback
      Get.snackbar("Permission Required", "Please grant full storage access.");
    }
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
      ),
      home: HomeScreenNew(),
      initialBinding: HomeBinding(),
    );
  }
}

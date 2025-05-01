import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission granted
    print("Storage permission granted!");
  } else {
    // Permission denied
    print("Storage permission denied!");
  }
}

Future<void> requestPhotoLibraryPermission() async {
  if (await Permission.photos.request().isGranted) {
    // Permission granted
    print("Photo library permission granted!");
  } else {
    // Permission denied
    print("Photo library permission denied!");
  }
}

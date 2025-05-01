# 🎬 Native YouTube Video Downloader - Flutter App

A **clean architecture Flutter app** that allows users to **download YouTube videos in selected resolutions**, shows **download progress**, and maintains a **download history list**.  
Built using **GetX**, `youtube_explode_dart`, and `ffmpeg_kit_flutter_minimal`.

---

## 🚀 Features

- ✅ Paste YouTube URL to fetch video metadata  
- ✅ Select resolution (e.g., 1080p, 720p, 480p...)  
- ✅ Show live download progress  
- ✅ Save videos to storage folder  
- ✅ View downloaded videos in history  
- ✅ Tap to open the downloaded video  
- ✅ Persistent local storage with `get_storage`  
- ✅ Clean architecture + GetX state management  

---

## 🧱 Folder Structure

lib/     
├── bindings/   
│ └── home_binding.dart   
├── controllers/   
│ └── home_controller.dart   
├── models/   
│ └── video_info_model.dart   
├── screens/   
│ ├── home_screen_new.dart   
│ └── download_history_screen.dart   
├── services/   
│ ├── youtube_service.dart   
│ └── storage_service.dart   
├── utils/   
│ ├── custom_toast.dart   
│ └── merge_audio_video.dart   
└── main.dart  

---

## 🛠️ Packages Used

| Package | Description |
|--------|-------------|
| `get` | State management, navigation |
| `youtube_explode_dart` | Fetch YouTube metadata and streams |
| `file_picker` | Select folder for saving videos |
| `permission_handler` | Handle Android/iOS permissions |
| `get_storage` | Store downloaded video list |
| `open_file` | Open videos in system video player |

---

## 📱 Screenshots
![merge_page](https://github.com/user-attachments/assets/11bdf0a4-726f-4aa2-a15a-a9f7ff5c72ee)

https://github.com/user-attachments/assets/992d00d0-8537-41e3-911b-988e0a2508c6

## Donwload Link
https://docs.google.com/uc?export=download&id=177u-z1ShnJnyQb7elk3SAA4Ubb-rbrHS

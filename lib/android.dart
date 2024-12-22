import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:external_path/external_path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

Future<String> downloadAudioUrl(String url) async {
  final urlRegExp =
      RegExp(r'^(https://youtu\.be/|https://(www\.)*youtube\.com/).+');
  final yt = YoutubeExplode();
  if (urlRegExp.hasMatch(url)) {
    final video = await yt.videos.get(url); // Returns a Video instance.
    print(video.id);
    final manifest = await yt.videos.streams.getManifest(video.id);
    final audio = manifest.audioOnly;
    print(video.title);
    final stream = yt.videos.streams.get(audio.last);
    print(audio.last.container.name);
    final safeTitle = video.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');

    Directory? downloadDir;

    if (Platform.isAndroid) {
      // ストレージ権限の確認を強化
      var storageStatus = await Permission.storage.request();
      var externalStorageStatus =
          await Permission.manageExternalStorage.request();

      if (storageStatus.isGranted || externalStorageStatus.isGranted) {
        String? externalDir =
            await ExternalPath.getExternalStoragePublicDirectory(
                ExternalPath.DIRECTORY_DOWNLOADS);
        downloadDir = Directory('$externalDir/youtube_audio');

        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
      } else {
        return "Storage permission denied";
      }
    } else {
      downloadDir = await getDownloadsDirectory();
    }

    if (downloadDir != null && !await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    print(downloadDir!.path);

    final task = DownloadTask(
      url: audio.last.url.toString(),
      filename: "$safeTitle.${audio.last.container.name}",
      directory: downloadDir.path,
      baseDirectory: BaseDirectory.root,
      updates: Updates.statusAndProgress, // request status and progress updates
      requiresWiFi: true,
      retries: 5,
      allowPause: true,
    );

    // Start download, and wait for result. Show progress and status changes
    // FileDownloader().configureNotification(
    //     running: TaskNotification('Downloading', 'file: {safeFilename}'),
    //     complete: TaskNotification('Download finished', 'file: {safeFilename}'),
    //     progressBar: true);

    final result = await FileDownloader().download(task,
        onProgress: (progress) => print('Progress: ${progress * 100}%'),
        onStatus: (status) => print('Status: $status'));

    // Act on the result
    switch (result.status) {
      case TaskStatus.complete:
        print('Success!');
        break;
      case TaskStatus.canceled:
        print('Download was canceled');
        break;
      case TaskStatus.paused:
        print('Download was paused');
        break;
      default:
        print('Download not successful');
    }
    return "Downloaded";
  }
  return "Invalid URL";
}

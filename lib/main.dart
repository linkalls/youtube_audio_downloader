import 'package:flutter/material.dart';
import 'dart:io';
import "package:youtube_audio_downloader/shared/input.dart";
import "package:youtube_audio_downloader/android.dart";
import "package:flutter_hooks/flutter_hooks.dart";

final ThemeData darkTheme = ThemeData.dark();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: darkTheme,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextInputWidget(),
              ),
              ElevatedButton(
                  onPressed: () async {
                    print(TextController.text);
                    // var status = await Permission.manageExternalStorage.request();
                    // if (status.isGranted) {
                    //   final result =
                    //       await downloadAudioUrl(TextController.text);
                    //   print(result);
                    // } else {
                    //   print("Permission denied");
                    // }
                    final result = await downloadAudioUrl(TextController.text);
                    print(result);
                  },
                  child: const Text('Download')),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioDownloader extends HookWidget {
  const AudioDownloader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var result = useState<String>("");

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextInputWidget(),
          ),
          ElevatedButton(
              onPressed: () async {
                print(TextController.text);
              },
              child: const Text('Download')),
        ],
      ),
    );
  }
}

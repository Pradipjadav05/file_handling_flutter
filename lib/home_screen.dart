import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  String content = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Handling Demo"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await resetContent();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () async {
            //     await getStoragePath();
            //   },
            //   child: const Text("get storage path"),
            // ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Write File"),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                await createFile();
                await readFile();
              },
              child: const Text("Write File"),
            ),
            ElevatedButton(
              onPressed: () async {
                await deleteFile();
              },
              child: const Text("Delete File"),
            ),
            Text(content),
          ],
        ),
      ),
    );
  }

  Future getStoragePath() async {
    /*
    * this will return: inside data package path
    * /data/user/0/com.example.file_handling/app_flutter
    * */
    final path = await getApplicationDocumentsDirectory();
    log("getApplicationDocumentsDirectory(): $path");

    /*
    * returns the device’s download directory, where the user can typically find files that they have downloaded through the internet or other apps.
    * /storage/emulated/0/Android/data/com.example.file_handling/files/downloads
    * */
    final downloadDirectory = await getDownloadsDirectory();
    log("Download Directory: $downloadDirectory");

    /*
    * returns a list of directories where an app can store cache files on external storage devices, such as an SD card.
    * [Directory: '/storage/emulated/0/Android/data/com.example.file_handling/files', Directory: '/storage/0EFA-261A/Android/data/com.example.file_handling/files']
    * */
    final externalDirectories = await getExternalStorageDirectories();
    log("external storage Directories: $externalDirectories");

    /*
    * returns the primary external storage directory of the device
    * /storage/emulated/0/Android/data/com.example.file_handling/files
    * */
    final externalDirectory = await getExternalStorageDirectory();
    log("external storage Directory: $externalDirectory");

    /*
    * return temporary directory of device
    * the system will automatically delete files in this directory as disk space is needed elsewhere on the device. The system will always delete older files first, based on the lastModifiedTime.
    * /data/user/0/com.example.file_handling/cache
    * */
    final tempDirectory = await getTemporaryDirectory();
    log("temporary directory: $tempDirectory");

    /*
    * return cache directory
    * '/data/user/0/com.example.file_handling/cache'
    * */
    final cacheApplicationDirectory = await getApplicationCacheDirectory();
    log("cache Application directory: $cacheApplicationDirectory");

    /*
    * return list of external cache directory
    * [Directory: '/storage/emulated/0/Android/data/com.example.file_handling/cache', Directory: '/storage/0EFA-261A/Android/data/com.example.file_handling/cache']
    * */
    final cacheExternalDirectory = await getExternalCacheDirectories();
    log("cache External directory: $cacheExternalDirectory");

    /*
    *
    * */
    // final libraryDirectory = await getLibraryDirectory();
    // log("library directory: $libraryDirectory");

    /*
    *
    * '/data/user/0/com.example.file_handling/files'
    * */
    final appSupportDir = await getApplicationSupportDirectory();
    log("App support directory: $appSupportDir");
  }

  createFile() async {
    final file = await _localFile;

    if (_textEditingController.text.trim().isNotEmpty) {
      await file.writeAsString(_textEditingController.text,
          mode: FileMode.append);
    }
    // Write the file
  }

  readFile() async {
    final file = await _localFile;

    if (await file.exists()) {
      final res = await file.readAsString();
      setState(() {
        content = res;
      });
    }else {
      setState(() {
        content = "file not exits.";
      });
    }
    //Read file
  }

  resetContent() async {
    final file = await _localFile;
    // Write the file
    await file.writeAsString("", mode: FileMode.write);
    await readFile();
  }

  deleteFile() async {
    final file = await _localFile;

    if (await file.exists()) {
      //delete file if exit
      file.deleteSync(recursive: true);
    } else {
      setState(() {
        content = "file not exits.";
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/text_file.txt');
  }
}

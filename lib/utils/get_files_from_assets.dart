import 'dart:io';

import 'package:flutter/services.dart';

Future<File> getEventsFileFromAssets(String path) async {
  String savePath = "/sdcard/Download/events.json";
  final byteData = await rootBundle.load("assets/$path");
  File jsonFile = File(savePath);
  if (!jsonFile.existsSync()) {
    jsonFile.createSync();
  }
  if(jsonFile.lengthSync() == 0) {
    await jsonFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  }
  return jsonFile;
}


Future<File> getTicketsFileFromAssets() async {
  String savePath = "/sdcard/Download/tickets.json";
  File jsonFile = File(savePath);
  return jsonFile;
}

Future<File> getRecordsFileFromAssets() async {
  String savePath = "/sdcard/Download/records.json";
  File jsonFile = File(savePath);
  return jsonFile;
}
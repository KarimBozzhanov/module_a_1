import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:module_a_1/models/record_response.dart';
import 'package:module_a_1/utils/records_api.dart';
import 'package:module_a_1/models/record.dart';

class RecordsProvider extends ChangeNotifier {

  Future<List<Record>> loadRecords() async {
    RecordsApi recordsApi = RecordsApi();
    RecordResponse recordResponse = await recordsApi.getRecords();
    return recordResponse.records;
  }

  Future<void> saveData(List<Record> recordsList) async {
    final jsonData = recordsList.map((record) => record.toJson()).toList();
    final jsonString = json.encode(jsonData);
    String savePath = "/sdcard/Download/records.json";
    File jsonFile = File(savePath);
    if(!jsonFile.existsSync()) {
      jsonFile.create();
    }
    print(jsonFile.path);
    await jsonFile.writeAsString(jsonString);
  }

}

import 'dart:convert';
import 'package:module_a_1/models/record.dart';
import 'package:module_a_1/models/record_response.dart';
import 'package:module_a_1/utils/get_files_from_assets.dart';


class RecordsApi {
  List<Record> recordsList = [];

  Future<RecordResponse> getRecords() async {
    final file = await getRecordsFileFromAssets();
    final String response = await file.readAsString();
    final data = json.decode(response);
    RecordResponse recordResponse = RecordResponse.fromJson(data);
    recordsList = recordResponse.records;
    return RecordResponse(records: recordsList);
  }
}
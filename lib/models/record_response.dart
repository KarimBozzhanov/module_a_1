import 'package:module_a_1/models/record.dart';

class RecordResponse {
  RecordResponse({required this.records});

  final List<Record> records;

  factory RecordResponse.fromJson(List<dynamic> snapshot) {
    List<Record> list;
    list = snapshot.map((data) => Record.fromJson(data)).toList();
    return RecordResponse(records: list);
  }
}
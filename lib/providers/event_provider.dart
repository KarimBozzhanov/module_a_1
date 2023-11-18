import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:module_a_1/models/event_response.dart';
import 'package:module_a_1/utils/event_api.dart';

import '../models/event.dart';

class EventProvider extends ChangeNotifier {

  Future<List<Event>> loadData() async {
    EventApi eventApi = EventApi();
    EventResponse eventResponse = await eventApi.getEvents();
    return eventResponse.eventList;
  }

  Future<void> saveData(List<Event> eventsList) async {
    final jsonData = eventsList.map((event) => event.toJson()).toList();
    final jsonString = json.encode(jsonData);
    String savePath = "/sdcard/Download/events.json";
    File jsonFile = File(savePath);
    await jsonFile.writeAsString(jsonString);
  }

  // void addViewCount(int index) {
  //   final event = _events[index];
  //   event.viewCount++;
  //   _saveData();
  //   notifyListeners();
  // }
}

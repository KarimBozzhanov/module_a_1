import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:module_a_1/models/event.dart';
import 'package:module_a_1/utils/get_files_from_assets.dart';

import '../models/event_response.dart';

class EventApi {
  List<Event> events = [];


  Future<EventResponse> getEvents() async {
    final file = await getEventsFileFromAssets("data/events.json");
    final String response = file.readAsStringSync();
    final data = json.decode(response);
    EventResponse eventResponse = EventResponse.fromJson(data);
    events = eventResponse.eventList;
    return EventResponse(events);
  }
}
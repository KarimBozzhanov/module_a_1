import 'package:module_a_1/models/event.dart';

class EventResponse {
  final List<Event> eventList;

  EventResponse(this.eventList);

  factory EventResponse.fromJson(List<dynamic> snapshot) {
    List<Event> list;
    list = snapshot.map((data) => Event.fromJson(data)).toList();
    return EventResponse(list);
  }
}
import 'dart:convert';

class Event {
  Event({required this.title, required this.description, required this.urlToImage1, required this.urlToImage2, required this.urlToImage3, required this.viewCount, required this.status});
  final String title, description, urlToImage1, urlToImage2, urlToImage3;
  String status;
  int viewCount;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json["title"],
      description: json["description"],
      urlToImage1: json["urlToImage1"],
      urlToImage2: json["urlToImage2"],
      urlToImage3: json["urlToImage3"],
      status: json["status"],
      viewCount: json["viewCount"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic> {
      "title": title,
      "description": description,
      "urlToImage1": urlToImage1,
      "urlToImage2": urlToImage2,
      "urlToImage3": urlToImage3,
      "status": status,
      "viewCount": viewCount,
    };
    return data;
  }
}
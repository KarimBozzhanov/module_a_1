import 'dart:typed_data';

class Ticket {
  Ticket({required this.ticketType, required this.audienceName, required this.time, required this.seat, this.image});

  final String ticketType;
  final String audienceName;
  final String time;
  final String seat;
  final String? image;

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(ticketType: json["ticketType"], audienceName: json["audienceName"], time: json["time"], seat: json["seat"], image: json["image"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic> {
      "ticketType": ticketType,
      "audienceName": audienceName,
      "time": time,
      "seat": seat,
      "image": image
    };
    return data;
  }
}
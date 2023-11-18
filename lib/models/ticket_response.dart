import 'package:module_a_1/models/ticket.dart';

class TicketResponse {
  final List<Ticket> ticketList;

  TicketResponse(this.ticketList);

  factory TicketResponse.fromJson(List<dynamic> snapshot) {
    List<Ticket> list;
    list = snapshot.map((data) => Ticket.fromJson(data)).toList();
    return TicketResponse(list);
  }
}
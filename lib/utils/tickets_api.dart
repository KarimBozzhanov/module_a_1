import 'dart:convert';

import 'package:module_a_1/models/ticket.dart';
import 'package:module_a_1/models/ticket_response.dart';

import '../models/event_response.dart';
import 'get_files_from_assets.dart';

class TicketsApi {

  List<Ticket> tickets = [];

  Future<TicketResponse> getTickets() async {
    final file = await getTicketsFileFromAssets();
    final String response = await file.readAsString();
    final data = json.decode(response);
    TicketResponse ticketResponse = TicketResponse.fromJson(data);
    tickets = ticketResponse.ticketList;
    return TicketResponse(tickets);
  }
}
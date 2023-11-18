import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:module_a_1/models/ticket_response.dart';
import 'package:module_a_1/utils/tickets_api.dart';

import '../models/ticket.dart';

class TicketsProvider extends ChangeNotifier {

    Future<List<Ticket>> loadTickets() async {
        TicketsApi ticketsApi = TicketsApi();
        TicketResponse ticketResponse = await ticketsApi.getTickets();
        return ticketResponse.ticketList;
    }

    Future<void> saveData(List<Ticket> openingList, List<Ticket> closingList) async {
        final ticketsList = [...openingList, ...closingList];
        final ticketsData = ticketsList.map((ticket) => ticket.toJson()).toList();
        final jsonString = json.encode(ticketsData);
        String savePath = "/sdcard/Download/tickets.json";
        File jsonFile = File(savePath);
        if(!jsonFile.existsSync()) {
            jsonFile.create();
        }
        await jsonFile.writeAsString(jsonString);
    }
}
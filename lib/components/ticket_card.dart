import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_a_1/models/ticket.dart';
import 'package:module_a_1/pages/tickets_details.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket});
  
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 50,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                ticket.audienceName,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                ticket.seat,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w400
                ),
              )
            )
          ],
        ),
      ),
    );
  }
  
}
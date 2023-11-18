import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_a_1/components/ticket_card.dart';
import 'package:module_a_1/pages/create_ticket_page.dart';
import 'package:module_a_1/pages/tickets_details.dart';

import '../models/ticket.dart';
import '../providers/tickets_provider.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => TicketsPageState();

}

class TicketsPageState extends State<TicketsPage> {

  List<Ticket> openingTickets = [];
  List<Ticket> closingTickets = [];
  late TicketsProvider ticketsProvider;

  @override
  void initState() {
    super.initState();
    ticketsProvider = TicketsProvider();
    fetchData();
  }


  fetchData() async {
    List<Ticket> list = await ticketsProvider.loadTickets();
    setState(() {
      openingTickets = list.where((element) => element.ticketType == "Opening Ceremony").toList();
      closingTickets = list.where((element) => element.ticketType == "Closing Ceremony").toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              "Tickets List",
              style: TextStyle(
                  fontSize: 25
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Text(
                      "Create a new ticket",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTicketPage()));
                }
            ),
            const SizedBox(
              height: 90,
            ),
            const Text(
              "Opening Ceremony Tickets",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            ReorderableListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: openingTickets.length,
                onReorder: (int oldIndex, int newIndex) {
                  if(oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = openingTickets.removeAt(oldIndex);
                  setState(() {
                    openingTickets.insert(newIndex, item);
                    ticketsProvider.saveData(openingTickets, closingTickets);
                  });
                },
                itemBuilder: (context, index) {
                  final ticket = openingTickets[index];
                  return showOpeningTickets(index, ticket);
                }
            ),
            const SizedBox(
              height: 60,
            ),
            const Text(
              "Closing Ceremony Tickets",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: closingTickets.length,
              onReorder: (int oldIndex, int newIndex) {
                if(oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = closingTickets.removeAt(oldIndex);
                setState(() {
                  closingTickets.insert(newIndex, item);
                  ticketsProvider.saveData(openingTickets, closingTickets);
                });
              },
              itemBuilder: (context, index) {
                final ticket = closingTickets[index];
                return showClosingTickets(index, ticket);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget showOpeningTickets(int index, Ticket ticket) => Dismissible(
    onDismissed: (direction) {
      setState(() {
        openingTickets.removeAt(index);
        ticketsProvider.saveData(openingTickets, closingTickets);
      });
    },
    key: ValueKey(openingTickets[index]),
    background: Container(color: Colors.red,),
    child: InkWell(
      child: TicketCard(ticket: ticket,),
      onTap: ()  => Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetails(ticket: ticket))),
    ),
  );

  Widget showClosingTickets(int index, Ticket ticket) => Dismissible(
    onDismissed: (direction) {
      setState(() {
        closingTickets.removeAt(index);
        ticketsProvider.saveData(openingTickets, closingTickets);
      });
    },
    key: ValueKey(closingTickets[index]),
    background: Container(color: Colors.red,),
    child: InkWell(
      child: TicketCard(ticket: ticket,),
      onTap: ()  => Navigator.push(context, MaterialPageRoute(builder: (context) => TicketDetails(ticket: ticket))),
    ),
  );

}
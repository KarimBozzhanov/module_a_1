import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:module_a_1/models/ticket.dart';
import 'package:module_a_1/pages/tickets_page.dart';
import 'package:module_a_1/providers/tickets_provider.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => CreateTicketPageState();
}

class CreateTicketPageState extends State<CreateTicketPage> {
  static const imagePickerChannel = MethodChannel("javaChannel");

  Future<Uint8List>? _image;

  @override
  void initState() {
    imagePickerChannel.setMethodCallHandler((call) async {
      if(call.method == "imageSelected") {
        setState(() {
          _image = File(call.arguments as String).readAsBytes();
        });
      }
    });
    ticketsProvider = TicketsProvider();
    fetchData();
  }

  String dropDownValue = "Opening Ceremony";
  TextEditingController controller = TextEditingController();
  late TicketsProvider ticketsProvider;
  late List<Ticket> tickets = [];


  fetchData() async {
    List<Ticket> list = await ticketsProvider.loadTickets();
    setState(() {
      tickets = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              const Text(
                "Ticket Create",
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                width: 300,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 2
                    )
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      isExpanded: true,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      value: dropDownValue,
                      items: <String>["Opening Ceremony", "Closing Ceremony"].map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val, textAlign: TextAlign.start,)
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          dropDownValue = newValue!;
                        });
                      }
                  ),
                ),
              ),
              Container(
                width: 300,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Input your name',
                    isDense: true,                      // Added this
                    contentPadding: EdgeInsets.only(left: 8, top: 13, bottom: 13),  // Added this
                  ),
                ),
              ),
              InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 90,
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choose one picture",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    final result = await imagePickerChannel.invokeMethod("pickImage");
                    print("Result - ${result}");
                  }
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: FutureBuilder(
                    future: _image,
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        return Image(
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                          image: MemoryImage(snapshot.data!),
                        );
                      } else {
                        return Container(
                          color: Colors.grey,
                          width: 300,
                          height: 200,
                          child: const Center(
                            child: Text(
                                "Preview picture"
                            ),
                          ),
                        );
                      }
                    }
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              InkWell(
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: const Center(
                      child: Text(
                        "Create",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    Uint8List? imageData;
                    String? imageBytes;
                    if(_image != null) {
                      imageData = await _image;
                      imageBytes = base64.encode(imageData!.toList());
                    } else {
                      imageBytes = null;
                    }
                    var now = DateTime.now();
                    String date = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}";
                    String ch = 'ABC';
                    Random random = Random();
                    String randomString = String.fromCharCodes(Iterable.generate(1, (_) => ch.codeUnitAt(random.nextInt(ch.length))));
                    String seat = "$randomString${random.nextInt(9) + 1} Строка ${random.nextInt(9) + 1} Столбец ${random.nextInt(9) + 1}";
                    final ticket = Ticket(ticketType: dropDownValue, audienceName: controller.text, time: date, seat: seat, image: imageBytes);
                    print("Тип - ${ticket.ticketType} \nИмя - ${ticket.audienceName} \nВремя - ${ticket.time} \nМесто - ${ticket.seat}\n Картинка - ${ticket.image}");
                    createTicket(ticket);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TicketsPage()));
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }


  void createTicket(Ticket ticket) {
    tickets.add(ticket);
    final openingTickets = tickets.where((element) => element.ticketType == "Opening Ceremony").toList();
    final closingTickets = tickets.where((element) => element.ticketType == "Closing Ceremony").toList();
    ticketsProvider.saveData(openingTickets, closingTickets);
  }

}
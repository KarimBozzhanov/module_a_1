import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:module_a_1/models/ticket.dart';
import 'package:module_a_1/pages/tickets_page.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({super.key, required this.ticket});

  final Ticket ticket;

  @override
  State<StatefulWidget> createState() => TicketDetailsState();

}

class TicketDetailsState extends State<TicketDetails> {

  var src = GlobalKey();

  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    convertImage();
  }

  convertImage() {
    if(widget.ticket != null) {
      _image = Uint8List.fromList(base64.decode(widget.ticket.image!));
    } else {
      _image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        print("Back button pressed");
        return true;
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              "Ticket Details",
              style: TextStyle(
                  fontSize: 25
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: 300,
                height: 480,
                margin: const EdgeInsets.only(bottom: 40),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.white
                ),
                child: RepaintBoundary(
                  key: src,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _image != null
                        ? Image.memory(_image!, width: 300, height: 200, fit: BoxFit.cover,) :
                      Container(
                        width: 300,
                        height: 200,
                        decoration: const BoxDecoration(
                            color: Colors.grey
                        ),
                        child: const Center(
                          child: Text("Image"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 8),
                        child: Text(
                          "Ticket type: ${widget.ticket.ticketType}",
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "Audience's name: ${widget.ticket.audienceName}",
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Time: ${widget.ticket.time}",
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Seat: ${widget.ticket.seat}",
                          style: const TextStyle(
                              fontSize: 16
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                )
              ),
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
                      "Download",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  takeScreenShot();
                }
            ),
          ],
        ),
      ),
    );
  }

  takeScreenShot() async {
    final boundary = src.currentContext?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary?.toImage();
    var byteData = await image?.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();
    if(pngBytes != null) {
      final imagePath = await File("sdcard/DCIM/Camera/${widget.ticket.hashCode}.png").create();
      imagePath.writeAsBytes(pngBytes);
    }
  }

}
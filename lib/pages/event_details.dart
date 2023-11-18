import 'package:flutter/material.dart';
import 'package:module_a_1/models/event.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key, required this.event});

  final Event event;

  @override
  State<EventDetails> createState() => EventDetailsState();

}

class EventDetailsState extends State<EventDetails> {
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
              "Events Details",
              style: TextStyle(
                  fontSize: 25
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              color: Colors.grey,
              child: Center(
                child: Text(
                    widget.event.title
                ),
              ),
            ),
            Text(
              widget.event.viewCount.toString()
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    image: NetworkImage(widget.event.urlToImage1),
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: NetworkImage(widget.event.urlToImage2),
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                  Image(
                    image: NetworkImage(widget.event.urlToImage3),
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                widget.event.description,
                softWrap: true,
              )
            )
          ],
        ),
      ),
    );
  }

}
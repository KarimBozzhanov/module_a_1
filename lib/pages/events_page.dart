import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:module_a_1/models/event.dart';
import 'package:module_a_1/models/event_response.dart';
import 'package:module_a_1/components/event_card.dart';
import 'package:module_a_1/pages/event_details.dart';
import 'package:module_a_1/providers/event_provider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => EventsPageState();

}

class EventsPageState extends State<EventsPage> {


  late EventProvider eventProvider;

  List<Event> eventList = [];

  @override
  void initState() {
    super.initState();
    eventProvider = EventProvider();
    fetchData();
  }


  fetchData() async {
    List<Event> list = await eventProvider.loadData();
    setState(() {
      eventList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          const Text(
            "Events List",
            style: TextStyle(
                fontSize: 25
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      eventProvider.loadData().then((value) => eventList = value);
                    });
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0)
                  ),
                  child: const Text(
                      "All"
                  )
              ),
              const Text("/"),
              TextButton(
                  onPressed: () {
                    setState(() {
                      eventProvider.loadData().then((value) => eventList = value.where((element) => element.status == "unread").toList());
                    });
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 0, right: 0)
                  ),
                  child: const Text(
                      "Unread"
                  )
              ),
              const Text("/"),
              TextButton(
                  onPressed: () {
                    setState(() {
                      eventProvider.loadData().then((value) => eventList = value.where((element) => element.status == "read").toList());
                    });
                  },
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 0, right: 0)
                  ),
                  child: const Text(
                      "Read"
                  )
              )
            ],
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: eventList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    final event = eventList[index];
                    if(eventList[index].status == "unread") {
                      setEventReadStatus(index);
                    }
                    addViewCount(index);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetails(event: event)));
                  },
                  child: EventCard(event: eventList[index],),
                );
              })
        ],
      ),
    );
  }

  void setEventReadStatus(int index) {
    setState(() {
      final event = eventList[index];
      event.status = "read";
      eventProvider.saveData(eventList);
    });
  }

  void addViewCount(int index) {
    setState(() {
      final event = eventList[index];
      event.viewCount++;
      eventProvider.saveData(eventList);
    });
  }

}
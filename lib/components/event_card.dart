import 'package:flutter/cupertino.dart';
import 'package:module_a_1/models/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Image(
            image: NetworkImage(event.urlToImage1),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: 200,
                  child: Text(
                    event.title,
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: 230,
                  child: Text(
                    event.description,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis
                    ),
                    maxLines: 2,
                    softWrap: true,
                    textAlign: TextAlign.start,
                  ),
                ),
                Text(
                  event.status
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
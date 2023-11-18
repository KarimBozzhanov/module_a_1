import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:module_a_1/pages/event_details.dart';
import 'package:module_a_1/pages/events_page.dart';
import 'package:module_a_1/pages/records_page.dart';
import 'package:module_a_1/pages/tickets_page.dart';
import 'package:module_a_1/providers/event_provider.dart';
import 'package:module_a_1/providers/records_provider.dart';
import 'package:module_a_1/providers/tickets_provider.dart';

import '../models/event.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  
  int _selectedIndex = 0;

  Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>()
  };

  final List<Widget> _widgetOptions = <Widget>[
    const EventsPage(),
    const TicketsPage(),
    RecordsPage()
  ];

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.event),
        label: "Events"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.sticky_note_2),
          label: "Tickets"
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.fiber_smart_record_sharp),
          label: "Records"
      ),
    ];
  }

  void itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKeys[_selectedIndex],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (_) => _widgetOptions.elementAt(_selectedIndex));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          itemTapped(index);
        },
        items: buildBottomNavBarItems(),
      )
    );
  }

}
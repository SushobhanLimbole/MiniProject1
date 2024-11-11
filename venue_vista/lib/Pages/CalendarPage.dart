// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:venue_vista/Pages/Test.dart';
// import 'package:venue_vista/constants.dart';
// import 'package:venue_vista/drawer.dart';

// class CalendarPage extends StatefulWidget {
//   final String uid;
//   final bool isAdmin;
//   final String userName;
//   final String userEmail;
//   CalendarPage(
//       {required this.uid, required this.isAdmin, required this.userName, required this.userEmail});
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   Map<DateTime, List<String>> _events = {
//     DateTime.utc(2024, 10, 21): ['Event 1', 'Event 2'],
//     DateTime.utc(2024, 10, 22): ['Event 3'],
//   };

//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey, // Add this line to associate the key with the Scaffold
//       appBar: AppBar(
//         centerTitle: true,
//         leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(Icons.chevron_left)),
//         backgroundColor: Color.fromRGBO(243, 193, 202, 1),
//         title: Text(
//           'Central Auditorium',
//           style: GoogleFonts.poppins(),
//         ),
//       ),
//       drawer: AppDrawer(uid: widget.uid,isAdmin: widget.isAdmin,userEmail: widget.userEmail,userName: widget.userName,),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               margin:EdgeInsets.all(5) ,
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black,width: 1),
//                 borderRadius: BorderRadius.circular(4)
//               ),
//               child: TableCalendar(
//                 firstDay: DateTime.utc(2020, 1, 1),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 focusedDay: _focusedDay,
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 calendarFormat: _calendarFormat,
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     _selectedDay = selectedDay;
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 eventLoader: (day) {
//                   return _events[day] ?? [];
//                 },
//                 onFormatChanged: (format) {
//                   if (_calendarFormat != format) {
//                     setState(() {
//                       _calendarFormat = format;
//                     });
//                   }
//                 },
//                 onPageChanged: (focusedDay) {
//                   _focusedDay = focusedDay;
//                 },
//                 calendarStyle: CalendarStyle(
//                   isTodayHighlighted: true,
//                   selectedDecoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [primaryColor, primaryColor.withOpacity(0.7)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   todayDecoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [secondaryColor, secondaryColor.withOpacity(0.7)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     shape: BoxShape.circle,
//                   ),
//                   weekendTextStyle: TextStyle(
//                     color: secondaryColor,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   holidayTextStyle: TextStyle(
//                     color: primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   outsideDaysVisible: true,
//                   outsideTextStyle: TextStyle(color: Colors.grey.shade500),
//                   disabledTextStyle: TextStyle(color: Colors.grey.shade300),
//                   selectedTextStyle: TextStyle(
//                     color: secondaryColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   todayTextStyle: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                   defaultTextStyle: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: secondaryColor,
//                   ),
//                   withinRangeTextStyle: TextStyle(color: secondaryColor),
//                 ),
//                 headerStyle: HeaderStyle(
//                   titleTextStyle: TextStyle(
//                     color: secondaryColor,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   titleCentered: true,
//                   formatButtonVisible: true,
//                   formatButtonDecoration: BoxDecoration(
//                     color: primaryColor,
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   formatButtonTextStyle: TextStyle(
//                     color: secondaryColor,
//                     fontSize: 16,
//                     // fontWeight: FontWeight.w600,
//                   ),
//                   leftChevronIcon: Icon(
//                     Icons.chevron_left,
//                     color: secondaryColor,
//                     size: 28,
//                   ),
//                   rightChevronIcon: Icon(
//                     Icons.chevron_right,
//                     color: secondaryColor,
//                     size: 28,
//                   ),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//                 onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Demo(
//                         uid: widget.uid,
//                         isAdmin: widget.isAdmin,
//                         userName: widget.userName,
//                         userEmail: widget.userEmail,
//                       ),
//                     )),
//                 child: Text('Book')),
//             if (_selectedDay != null)
//               ..._events[_selectedDay!.toUtc()]?.map((event) => Container(
//                         child: Text(event),
//                       )) ??
//                   [ListTile(title: Text('No Events'))]
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:venue_vista/Pages/Test.dart';
import 'package:venue_vista/constants.dart';
import 'package:venue_vista/drawer.dart';

class CalendarPage extends StatefulWidget {
  final String uid;
  final bool isAdmin;
  final String userName;
  final String userEmail;

  CalendarPage({
    required this.uid,
    required this.isAdmin,
    required this.userName,
    required this.userEmail,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    // Fetching events from Firebase
    FirebaseFirestore.instance.collection('Events').get().then((querySnapshot) {
      Map<DateTime, List<String>> events = {};
      querySnapshot.docs.forEach((doc) {
        DateTime startDate = (doc['startDate'] as Timestamp).toDate();
        DateTime lastDate = (doc['lastDate'] as Timestamp).toDate();
        String eventName = doc['eventName'];

        // Add event to the map for all days between startDate and lastDate
        for (DateTime date = startDate;
            date.isBefore(lastDate.add(Duration(days: 1)));
            date = date.add(Duration(days: 1))) {
          if (events[date] == null) {
            events[date] = [];
          }
          events[date]?.add(eventName);
        }
      });
      setState(() {
        _events = events;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add this line to associate the key with the Scaffold
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.chevron_left)),
        backgroundColor: Color.fromRGBO(243, 193, 202, 1),
        title: Text(
          'Central Auditorium',
          style: GoogleFonts.poppins(),
        ),
      ),
      drawer: AppDrawer(
        uid: widget.uid,
        isAdmin: widget.isAdmin,
        userEmail: widget.userEmail,
        userName: widget.userName,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: (day) {
                  return _events[day] ?? [];
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [secondaryColor, secondaryColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  holidayTextStyle: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  outsideDaysVisible: true,
                  outsideTextStyle: TextStyle(color: Colors.grey.shade500),
                  disabledTextStyle: TextStyle(color: Colors.grey.shade300),
                  selectedTextStyle: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  defaultTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: secondaryColor,
                  ),
                  withinRangeTextStyle: TextStyle(color: secondaryColor),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  titleCentered: true,
                  formatButtonVisible: true,
                  formatButtonDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: secondaryColor,
                    fontSize: 16,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: secondaryColor,
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: secondaryColor,
                    size: 28,
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Demo(
                        uid: widget.uid,
                        isAdmin: widget.isAdmin,
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                      ),
                    )),
                child: Text('Book')),
            if (_selectedDay != null)
              ..._events[_selectedDay!.toUtc()]?.map((event) => Container(
                        child: Text(event),
                      )) ??
                  [ListTile(title: Text('No Events'))]
          ],
        ),
      ),
    );
  }
}

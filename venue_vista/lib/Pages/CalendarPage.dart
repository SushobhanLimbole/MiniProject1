import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: Icon(Icons.sort),
        ),
        backgroundColor: Color.fromRGBO(243, 193, 202, 1),
        title: Text('Calendar', style: GoogleFonts.poppins()),
      ),
      drawer: AppDrawer(
        uid: widget.uid,
        isAdmin: widget.isAdmin,
        userEmail: widget.userEmail,
        userName: widget.userName,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userEmail)
            .collection('Events')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: secondaryColor));
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Initialize event status data map
          Map<DateTime, String> eventData = {};

// Extract event data from snapshot
          for (var doc in snapshot.data!.docs) {

            debugPrint('start');
            // Parse the date from Firestore as a DateTime object
            DateTime eventDate =
                DateTime.parse(doc['startDate']); // Ensure format is yyyy-MM-dd
                 debugPrint('end ===== $eventDate');
            DateTime normalizedDate =
                DateTime(eventDate.year, eventDate.month, eventDate.day);
                debugPrint('hehe ======== $normalizedDate');

            // Determine the event status based on slots
            String eventStatus = 'Available';

            // Helper function to parse time strings into DateTime objects
            DateTime parseTime(String time) {
              List<String> parts = time.split(':');
              int hour = int.parse(parts[0]);
              int minute = int.parse(parts[1]);
              return DateTime(0, 0, 0, hour, minute);
            }

            // Make sure 'startTime' and 'lastTime' are in HH:mm format before parsing
            
              // Parse Firestore times as DateTime objects
              DateTime startTime = parseTime(doc['startTime']);
              DateTime lastTime = parseTime(doc['lastTime']);

              // Check time slots
              if ((startTime == parseTime('10:30') &&
                      lastTime == parseTime('13:00')) ||
                  (startTime == parseTime('14:00') &&
                      lastTime == parseTime('17:00'))) {
                eventStatus = 'Half Day';
              } else if (startTime == parseTime('10:30') &&
                  lastTime == parseTime('17:00')) {
                eventStatus = 'Occupied';
              }
            

            print(eventStatus);

            // Update event status for the date
            eventData[normalizedDate] = eventStatus;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: false,
                  outsideDaysVisible: true,
                  outsideTextStyle:
                      GoogleFonts.poppins(color: Colors.grey.shade500),
                  disabledTextStyle:
                      GoogleFonts.poppins(color: Colors.grey.shade300),
                  selectedTextStyle: GoogleFonts.poppins(color: Colors.white),
                  defaultTextStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  withinRangeTextStyle: GoogleFonts.poppins(color: Colors.teal),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: GoogleFonts.poppins(
                    color: secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  titleCentered: true,
                  formatButtonVisible: false,
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
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    debugPrint('day start ');
                    DateTime normalizedDay =
                        DateTime(day.year, day.month, day.day);
                        debugPrint('day end ======= $normalizedDay ');
                    String status = eventData[normalizedDay] ?? 'Available';
                    Color dayColor;

                    // Set the color based on event status
                    switch (status) {
                      case 'Available':
                        dayColor = Colors.green;
                        break;
                      case 'Half Day':
                        dayColor = Colors.amber;
                        break;
                      case 'Occupied':
                        dayColor = Colors.red;
                        break;
                      default:
                        dayColor = Colors.transparent;
                    }

                    bool isSelected = isSameDay(_selectedDay, day);
                    bool isToday = isSameDay(DateTime.now(), day);

                    Color backgroundColor = dayColor == Colors.transparent
                        ? Colors.transparent
                        : dayColor;

                    if (isToday) {
                      backgroundColor = secondaryColor;
                    } else if (isSelected) {
                      backgroundColor = primaryColor;
                    }

                    return Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${day.day}', // Show the day number
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: backgroundColor == Colors.transparent
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

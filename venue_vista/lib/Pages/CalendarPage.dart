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

// class _CalendarPageState extends State<CalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () => _scaffoldKey.currentState!.openDrawer(),
//           child: Icon(Icons.sort),
//         ),
//         backgroundColor: Color.fromRGBO(243, 193, 202, 1),
//         title: Text('Calendar', style: GoogleFonts.poppins()),
//       ),
//       drawer: AppDrawer(
//         uid: widget.uid,
//         isAdmin: widget.isAdmin,
//         userEmail: widget.userEmail,
//         userName: widget.userName,
//       ),
//       body: // StreamBuilder for displaying events in a calendar
//           StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Users')
//             .doc(widget.userEmail)
//             .collection('Events')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//                 child: CircularProgressIndicator(color: secondaryColor));
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           // Initialize event status data map
//           Map<DateTime, String> eventData = {};

//           // Define time slots
//           List<Map<String, DateTime>> timeSlots = [
//             {
//               "start": DateTime(0, 0, 0, 10, 30),
//               "end": DateTime(0, 0, 0, 13, 00)
//             },
//             {
//               "start": DateTime(0, 0, 0, 14, 00),
//               "end": DateTime(0, 0, 0, 17, 00)
//             },
//           ];

//           // Helper function to parse time strings into DateTime objects
//           DateTime parseTime(String time) {
//             List<String> parts = time.split(':');
//             int hour = int.parse(parts[0]);
//             int minute = int.parse(parts[1]);
//             return DateTime(0, 0, 0, hour, minute);
//           }

//           // Extract and process event data from snapshot
//           for (var doc in snapshot.data!.docs) {
//             // Parse startDate and endDate as DateTime objects
//             DateTime startDate =
//                 DateTime.parse(doc['startDate']); // yyyy-MM-dd format
//             DateTime endDate =
//                 DateTime.parse(doc['lastDate']); // yyyy-MM-dd format

//             // Parse startTime and lastTime as DateTime objects
//             DateTime startTime = parseTime(doc['startTime']);
//             DateTime lastTime = parseTime(doc['lastTime']);

//             // Calculate event duration
//             int eventDurationMinutes = lastTime.difference(startTime).inMinutes;

//             // Determine event status based on time slots
//             String eventStatus = 'Available';
//             int slotsCovered = 0;

//             for (var slot in timeSlots) {
//               DateTime slotStart = slot["start"]!;
//               DateTime slotEnd = slot["end"]!;

//               if (!(lastTime.isBefore(slotStart) ||
//                   startTime.isAfter(slotEnd))) {
//                 DateTime overlapStart =
//                     startTime.isAfter(slotStart) ? startTime : slotStart;
//                 DateTime overlapEnd =
//                     lastTime.isBefore(slotEnd) ? lastTime : slotEnd;
//                 int overlapDuration =
//                     overlapEnd.difference(overlapStart).inMinutes;

//                 if (overlapDuration ==
//                     slotEnd.difference(slotStart).inMinutes) {
//                   slotsCovered++;
//                 } else if (overlapDuration > 0) {
//                   slotsCovered += 1;
//                 }
//               }
//             }

//             if (slotsCovered == 1) {
//               eventStatus = 'Half Day';
//             } else if (slotsCovered >= 2) {
//               eventStatus = 'Occupied';
//             }

//             // Assign event status for each day within the startDate to endDate range
//             DateTime currentDate = startDate;
//             while (!currentDate.isAfter(endDate)) {
//               DateTime normalizedDate = DateTime(
//                   currentDate.year, currentDate.month, currentDate.day);
//               eventData[normalizedDate] = eventStatus;

//               // Move to the next day
//               currentDate = currentDate.add(Duration(days: 1));
//             }
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TableCalendar(
//                 firstDay: DateTime.now(),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 focusedDay: _focusedDay,
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     _selectedDay = selectedDay;
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 onPageChanged: (focusedDay) {
//                   setState(() {
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 calendarStyle: CalendarStyle(
//                   isTodayHighlighted: false,
//                   outsideDaysVisible: true,
//                   outsideTextStyle:
//                       GoogleFonts.poppins(color: Colors.grey.shade500),
//                   disabledTextStyle:
//                       GoogleFonts.poppins(color: Colors.grey.shade300),
//                   selectedTextStyle: GoogleFonts.poppins(color: Colors.white),
//                   defaultTextStyle: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                   withinRangeTextStyle: GoogleFonts.poppins(color: Colors.teal),
//                 ),
//                 headerStyle: HeaderStyle(
//                   titleTextStyle: GoogleFonts.poppins(
//                     color: secondaryColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   titleCentered: true,
//                   formatButtonVisible: false,
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
//                 calendarBuilders: CalendarBuilders(
//                   defaultBuilder: (context, day, focusedDay) {
//                     DateTime normalizedDay =
//                         DateTime(day.year, day.month, day.day);
//                     String status = eventData[normalizedDay] ?? 'Available';
//                     Color dayColor;

//                     switch (status) {
//                       case 'Available':
//                         dayColor = Colors.green;
//                         break;
//                       case 'Half Day':
//                         dayColor = Colors.amber;
//                         break;
//                       case 'Occupied':
//                         dayColor = const Color.fromARGB(255, 206, 14, 0);
//                         break;
//                       default:
//                         dayColor = Colors.transparent;
//                     }

//                     bool isSelected = isSameDay(_selectedDay, day);
//                     bool isToday = isSameDay(DateTime.now(), day);

//                     Color backgroundColor = dayColor == Colors.transparent
//                         ? Colors.transparent
//                         : dayColor;

//                     if (isToday) {
//                       backgroundColor = secondaryColor;
//                     } else if (isSelected) {
//                       backgroundColor = primaryColor;
//                     }

//                     return Container(
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                         color: backgroundColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: backgroundColor == Colors.transparent
//                                 ? Colors.black
//                                 : Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _CalendarPageState extends State<CalendarPage> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         centerTitle: true,
//         leading: InkWell(
//           onTap: () => _scaffoldKey.currentState!.openDrawer(),
//           child: Icon(Icons.sort),
//         ),
//         backgroundColor: Color.fromRGBO(243, 193, 202, 1),
//         title: Text('Calendar', style: GoogleFonts.poppins()),
//       ),
//       drawer: AppDrawer(
//         uid: widget.uid,
//         isAdmin: widget.isAdmin,
//         userEmail: widget.userEmail,
//         userName: widget.userName,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Users')
//             .doc(widget.userEmail)
//             .collection('Events')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//                 child: CircularProgressIndicator(color: secondaryColor));
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           // Map to store event status for each day
//           Map<DateTime, String> eventData = {};

//           // Define slot labels
//           const morningSlot = 'Morning Slot';
//           const eveningSlot = 'Evening Slot';
//           const fullDaySlot = 'Full Day';

//           // Process each event document
//           for (var doc in snapshot.data!.docs) {
//             DateTime startDate = DateTime.parse(doc['startDate']);
//             DateTime endDate = DateTime.parse(doc['lastDate']);
//             String slot = doc['slot']; // Assume slot is saved as "morning", "evening", or "full-day"

//             // Determine event status based on the slot value
//             String eventStatus;
//             if (slot == fullDaySlot) {
//               eventStatus = 'Occupied';
//             } else if (slot == morningSlot || slot == eveningSlot) {
//               eventStatus = 'Half Day';
//             } else {
//               eventStatus = 'Available';
//             }

//             // Assign event status for each day in the date range
//             DateTime currentDate = startDate;
//             while (!currentDate.isAfter(endDate)) {
//               DateTime normalizedDate = DateTime(
//                   currentDate.year, currentDate.month, currentDate.day);
//               eventData[normalizedDate] = eventStatus;
//               currentDate = currentDate.add(Duration(days: 1));
//             }
//           }

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TableCalendar(
//                 firstDay: DateTime.now(),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 focusedDay: _focusedDay,
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 onDaySelected: (selectedDay, focusedDay) {
//                   setState(() {
//                     _selectedDay = selectedDay;
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 onPageChanged: (focusedDay) {
//                   setState(() {
//                     _focusedDay = focusedDay;
//                   });
//                 },
//                 calendarStyle: CalendarStyle(
//                   isTodayHighlighted: false,
//                   outsideDaysVisible: true,
//                   outsideTextStyle:
//                       GoogleFonts.poppins(color: Colors.grey.shade500),
//                   disabledTextStyle:
//                       GoogleFonts.poppins(color: Colors.grey.shade300),
//                   selectedTextStyle: GoogleFonts.poppins(color: Colors.white),
//                   defaultTextStyle: GoogleFonts.poppins(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.black87,
//                   ),
//                   withinRangeTextStyle: GoogleFonts.poppins(color: Colors.teal),
//                 ),
//                 headerStyle: HeaderStyle(
//                   titleTextStyle: GoogleFonts.poppins(
//                     color: secondaryColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   titleCentered: true,
//                   formatButtonVisible: false,
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
//                 calendarBuilders: CalendarBuilders(
//                   defaultBuilder: (context, day, focusedDay) {
//                     DateTime normalizedDay =
//                         DateTime(day.year, day.month, day.day);
//                     String status = eventData[normalizedDay] ?? 'Available';
//                     Color dayColor;

//                     switch (status) {
//                       case 'Available':
//                         dayColor = Colors.green;
//                         break;
//                       case 'Half Day':
//                         dayColor = Colors.amber;
//                         break;
//                       case 'Occupied':
//                         dayColor = const Color.fromARGB(255, 206, 14, 0);
//                         break;
//                       default:
//                         dayColor = Colors.transparent;
//                     }

//                     bool isSelected = isSameDay(_selectedDay, day);
//                     bool isToday = isSameDay(DateTime.now(), day);

//                     Color backgroundColor = dayColor == Colors.transparent
//                         ? Colors.transparent
//                         : dayColor;

//                     if (isToday) {
//                       backgroundColor = secondaryColor;
//                     } else if (isSelected) {
//                       backgroundColor = primaryColor;
//                     }

//                     return Container(
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                         color: backgroundColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${day.day}',
//                           style: GoogleFonts.poppins(
//                             fontSize: 14,
//                             color: backgroundColor == Colors.transparent
//                                 ? Colors.black
//                                 : Colors.white,
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Track slot availability for each date and slot combination
  Map<String, String> slotAvailability = {};

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

          // Map to store event status for each day
          Map<DateTime, String> eventData = {};

          // Define slot labels
          const morningSlot = 'Morning Slot';
          const eveningSlot = 'Evening Slot';
          const fullDaySlot = 'Full Day';

          // Process each event document
          for (var doc in snapshot.data!.docs) {
            DateTime startDate = DateTime.parse(doc['startDate']);
            DateTime endDate = DateTime.parse(doc['lastDate']);
            String slot = doc['slot']; // Get slot (morning, evening, or full-day)

            DateTime currentDate = startDate;
            while (!currentDate.isAfter(endDate)) {
              DateTime normalizedDate = DateTime(
                  currentDate.year, currentDate.month, currentDate.day);

              // Track slot availability for the specific day and slot
              String dayKey = "${normalizedDate.toIso8601String().split('T')[0]}";

              // Determine event status based on the slot value
              if (slot == fullDaySlot) {
                // If full day is booked, mark all slots as "Occupied" for this date
                slotAvailability["$dayKey $morningSlot"] = 'Occupied';
                slotAvailability["$dayKey $eveningSlot"] = 'Occupied';
                slotAvailability["$dayKey $fullDaySlot"] = 'Occupied';
                eventData[normalizedDate] = 'Occupied';
              } else {
                // Mark half-day slot as "Half Day" if it’s not already fully occupied
                if (slotAvailability["$dayKey $fullDaySlot"] != 'Occupied') {
                  slotAvailability["$dayKey $slot"] = 'Half Day';
                  eventData[normalizedDate] = 'Half Day';
                }
              }

              currentDate = currentDate.add(Duration(days: 1));
            }
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
                    _showSlotDialog(context, selectedDay, slotAvailability,morningSlot,eveningSlot);
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
                    DateTime normalizedDay =
                        DateTime(day.year, day.month, day.day);
                    String status = eventData[normalizedDay] ?? 'Available';
                    Color dayColor;

                    switch (status) {
                      case 'Available':
                        dayColor = Colors.green;
                        break;
                      case 'Half Day':
                        dayColor = Colors.amber;
                        break;
                      case 'Occupied':
                        dayColor = const Color.fromARGB(255, 206, 14, 0);
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
                          '${day.day}',
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

  void _showSlotDialog(BuildContext context, DateTime day, Map<String, String> slotAvailability,String morningSlot,String eveningSlot) {
    // Define slot labels
    List<String> slots = ['Morning Slot', 'Evening Slot', 'Full Day'];
    Map<String, String> slotAvailabilityForDay = {};

    // Format the date key to match the storage format in slotAvailability
    String dateKeyPrefix = "${day.toIso8601String().split('T')[0]}";

    // Retrieve availability for each slot of the selected day
    for (String slot in slots) {
      String dayKey = "$dateKeyPrefix $slot"; // Matches the key format in slotAvailability
      String status = slotAvailability[dayKey] ?? 'Available';

      // If full-day is occupied, override morning and evening slots to display as "Occupied"
      if (slot == 'Full Day' && status == 'Occupied') {
        slotAvailabilityForDay[morningSlot] = 'Occupied';
        slotAvailabilityForDay[eveningSlot] = 'Occupied';
      }

      slotAvailabilityForDay[slot] = status;
    }

    // Show dialog with available slots for the selected day
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Slot Availability for ${day.toLocal().toString().split(' ')[0]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: slotAvailabilityForDay.entries.map((entry) {
              String slotName = entry.key;
              String slotStatus = entry.value;

              return Text(
                "$slotName: $slotStatus",
                style: TextStyle(
                  color: slotStatus == 'Available' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

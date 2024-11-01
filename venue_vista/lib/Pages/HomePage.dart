import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:venue_vista/Pages/Test.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 10, 21): ['Event 1', 'Event 2'],
    DateTime.utc(2024, 10, 22): ['Event 3'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.sort),
        backgroundColor: Color.fromRGBO(243, 193, 202, 1),
        title: Text(
          'Home',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // Update focusedDay
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
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DepartmentBarChart(),
                  )),
              child: Text('Test')),
          if (_selectedDay != null)
            ..._events[_selectedDay!.toUtc()]?.map((event) => Container(
                      child: Text(event),
                    )) ??
                [ListTile(title: Text('No Events'))]
        ],
      ),
    );
  }
}

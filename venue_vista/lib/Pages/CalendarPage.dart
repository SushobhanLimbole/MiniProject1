import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:venue_vista/Components/BottomNavigationBar.dart';
import 'package:venue_vista/Components/Drawer.dart';

class CalendarPage extends StatefulWidget {
  final String uid;
  final bool isAdmin;
  final String userEmail;
  final String userName;

  CalendarPage({
    required this.uid,
    required this.isAdmin,
    required this.userEmail,
    required this.userName,
  });

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventSpeakerController = TextEditingController();
  final TextEditingController eventAttendeeController = TextEditingController();
  final TextEditingController eventCollabController = TextEditingController();
  final TextEditingController eventDesc = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  String? selectedslot;
  final List<String> slots = ['Morning Slot', 'Evening Slot', 'Full Day'];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, String> slotAvailability = {};
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  // Date Picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate,
      firstDate: _selectedStartDate!,
      lastDate: _selectedStartDate!.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
         // _selectedStartDate = picked;
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  // Format Date
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Format Time
  String formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

Future<void> addTopic(
      {required String eventName,
      required String startDate,
      required String lastDate,
      required String speaker,
      required String attendee,
      required Timestamp nowDate,
      required String slot,
      String? collab,
      required String description}) async {
    try {
      debugPrint(widget.uid);
      await _firestore
          .collection('Users')
          .doc(widget.userEmail)
          .collection('Events')
          .doc(eventName)
          .set({
        "eventName": eventNameController.text.trim(),
        "startDate": DateFormat('dd-MM-yyyy').format(DateTime.parse("$_selectedStartDate")),
        //  _selectedStartDate != null ? DateTime(_selectedStartDate!.day) : Timestamp.fromDate(eventstartDate),
        "lastDate": DateFormat('dd-MM-yyyy').format(DateTime.parse("$_selectedEndDate")),
        // _selectedEndDate != null ? DateTime(_selectedEndDate!.day) : Timestamp.fromDate(eventendDate),
        //"startTime": startTime,
        //  _selectedStartTime != null ? DateTime(_selectedStartTime!.hour) : Timestamp.fromDate(eventendDate),
        //"lastTime": lastTime,
        //  _selectedEndTime != null ? DateTime(_selectedEndTime!.hour) : Timestamp.fromDate(eventendDate),
        "speaker": eventSpeakerController.text.trim(),
        "attendee": eventAttendeeController.text.trim(),
        "description": eventDesc.text.trim(),
        "collab": eventCollabController.text.trim(),
        "isApproved": false,
        "isPending": true,
        "nowDate":DateTime.now(),
        "slot":selectedslot,
      });
      debugPrint("Event added successfully");
    } catch (e) {
      debugPrint("Failed to add event: $e");
    }
  }

  void _submitEvent() async {
    if (eventNameController.text.isEmpty ||
        eventSpeakerController.text.isEmpty ||
        eventAttendeeController.text.isEmpty ||
        eventDesc.text.isEmpty ||
        _selectedEndDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
    }
    debugPrint("before addTopic method");
    await addTopic(
      eventName: eventNameController.text.trim(),
      startDate: "$_selectedStartDate",
      lastDate: "$_selectedEndDate",
      speaker: eventSpeakerController.text.trim(),
      attendee: eventAttendeeController.text.trim(),
      description: eventDesc.text.trim(),
      collab: eventCollabController.text.trim(),
      nowDate: Timestamp.fromDate(DateTime.now()),
      slot: selectedslot!,
    );
    debugPrint("after addTopic method");
  }

  void eventRequestBottomSheet(DateTime focusedDay,List availableSlots) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          _selectedStartDate=focusedDay;
          return Container(
            height: MediaQuery.of(context).size.height - 80,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Event Request',
                          style: GoogleFonts.poppins(
                              fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: eventNameController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Event Name',
                        hintStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'Date & Time',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.teal,
                          ),
                          child: Container(
                            width: 200,
                            child: Center(
                              child: Text(
                                "Start Date: ${DateFormat('dd-MM-yyyy').format(_selectedStartDate!)}",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            _selectDate(context, false);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.teal,
                          ),
                          child: Container(
                            width: 200,
                            child: Center(
                              child: Text(
                                _selectedEndDate != null
                                    ? "End Date: ${DateFormat('dd-MM-yyyy').format(_selectedEndDate!)}"
                                    : "Pick an End Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedslot,
                      items: availableSlots.map((_selectedStartDate) {
                        return DropdownMenuItem<String>(
                          value: _selectedStartDate,
                          child: Text(_selectedStartDate),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedslot = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Slots',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.business),
                        ),
                      ),
                      validator: (value) {
                        // Validate if a slot is selected
                        if (value == null) {
                          return 'Please select a Slot';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: eventSpeakerController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Speaker',
                        hintStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: eventAttendeeController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Attedees',
                        hintStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      controller: eventCollabController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Collaboration(Optional)',
                        hintStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      style: GoogleFonts.poppins(),
                      controller: eventDesc,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter the event description',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitEvent();
                          Navigator.pop(context);
                        },
                        child: Text("Send Event Request"),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

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
        backgroundColor: const Color.fromRGBO(243, 193, 202, 1),
        title: Text('Calendar', style: GoogleFonts.poppins()),
      ),
      drawer: AppDrawer(
        uid: widget.uid,
        isAdmin: widget.isAdmin,
        userEmail: widget.userEmail,
        userName: widget.userName,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collectionGroup('Events').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          Map<DateTime, String> eventData = {};
          const morningSlot = 'Morning Slot';
          const eveningSlot = 'Evening Slot';
          const fullDaySlot = 'Full Day';

          for (var doc in snapshot.data!.docs) {
            // Check if the event is approved
            bool isApproved = doc['isApproved'] ?? false;
            if (!isApproved) {
              continue; // Skip this event if it's not approved
            }

            String startDateStr = doc['startDate'];
            String endDateStr = doc['lastDate'];
            String slot = doc['slot'];

            DateTime startDate = dateFormat.parse(startDateStr);
            DateTime endDate = dateFormat.parse(endDateStr);

            DateTime currentDate = startDate;
            while (!currentDate.isAfter(endDate)) {
              DateTime normalizedDate = DateTime(
                  currentDate.year, currentDate.month, currentDate.day);
              String dayKey =
                  "${normalizedDate.toIso8601String().split('T')[0]}";

              // If the current slot is "Full Day," override all other slots

              if (slot == fullDaySlot) {
                slotAvailability["$dayKey $morningSlot"] = '-';
                slotAvailability["$dayKey $eveningSlot"] = '-';
                slotAvailability["$dayKey $fullDaySlot"] = 'Occupied';
                eventData[normalizedDate] = 'Occupied';
              } else {
                // For morning/evening slots, mark as "Half Day"
                slotAvailability["$dayKey $slot"] = 'Half Day';

                // Check if both morning and evening slots are booked
                bool morningBooked =
                    slotAvailability["$dayKey $morningSlot"] == 'Half Day';
                bool eveningBooked =
                    slotAvailability["$dayKey $eveningSlot"] == 'Half Day';

                if (morningBooked && eveningBooked) {
                  slotAvailability["$dayKey $morningSlot"] = '-';
                  slotAvailability["$dayKey $eveningSlot"] = '-';
                  slotAvailability["$dayKey $fullDaySlot"] = 'Occupied';
                  eventData[normalizedDate] = 'Occupied';
                } else {
                  slotAvailability["$dayKey $fullDaySlot"] = 'Not Available';
                  eventData[normalizedDate] = 'Half Day';
                }
              }
              currentDate = currentDate.add(Duration(days: 1));
            }
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime.now().add(Duration(days: 30)),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                      _showSlotDialog(context, selectedDay, slotAvailability,
                          morningSlot, eveningSlot, fullDaySlot, focusedDay);
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    outsideDaysVisible: false,
                    defaultTextStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: GoogleFonts.poppins(
                      color: Colors.pinkAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    titleCentered: true,
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
                        backgroundColor = Colors.pinkAccent;
                      } else if (isSelected) {
                        backgroundColor = Colors.blue;
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
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigatorBar(
          index: 1,
          uid: widget.uid,
          isAdmin: widget.isAdmin,
          userEmail: widget.userEmail,
          userName: widget.userName),
    );
  }

  List<String> getAvailableSlots(Map<String, String> slotStatuses) {
    List<String> availableSlots = [];

    // Loop through all slots and add only the available ones
    slotStatuses.forEach((slot, status) {
      if (status == 'Available') {
        availableSlots.add(slot);
      }
    });

    return availableSlots;
  }

  void _showSlotDialog(
      BuildContext context,
      DateTime day,
      Map<String, String> slotAvailability,
      String morningSlot,
      String eveningSlot,
      String fullDaySlot,
      DateTime focusedDay) {
    // Format the date key to match the storage format in slotAvailability
    String dateKeyPrefix = "${day.toIso8601String().split('T')[0]}";

    // Retrieve the status for each slot
    Map<String, String> slotStatuses = {};
    List<String> slots = [morningSlot, eveningSlot, fullDaySlot];
    for (String slot in slots) {
      String dayKey = "$dateKeyPrefix $slot"; // Matches the key format
      slotStatuses[slot] = slotAvailability[dayKey] ?? 'Available';
    }

    // Show dialog with slot availability
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Slot Availability for ${dateFormat.format(day)}"), // Formatted date
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: slotStatuses.entries.map((entry) {
              String slotName = entry.key;
              String slotStatus = entry.value;

              // Set color based on slot status
              Color textColor;
              if (slotStatus == 'Available') {
                textColor = Colors.green;
              } else if (slotStatus == 'Half Day') {
                textColor = Colors.amber;
              } else {
                textColor = Colors.red; // 'Occupied'
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "$slotName: $slotStatus",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    List<String> availableSlots =
                        getAvailableSlots(slotStatuses);
                    eventRequestBottomSheet(focusedDay,
                        availableSlots); // Pass available slots here
                  },
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: Center(
                        child:
                            Text("Book", style: TextStyle(color: Colors.blue))),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

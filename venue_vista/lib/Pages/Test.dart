import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/constants.dart';

class Demo extends StatefulWidget {
  final String uid;
  final bool isAdmin;
  final String userName;
  final String userEmail;
  const Demo(
      {super.key,
      required this.uid,
      required this.isAdmin,
      required this.userName,
      required this.userEmail});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventSpeakerController = TextEditingController();
  final TextEditingController eventAttendeeController = TextEditingController();
  final TextEditingController eventCollabController = TextEditingController();
  final TextEditingController eventDesc = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  // Date picker function
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isStartDate) {
        _selectedStartDate = picked;
        debugPrint("Selected Start Date: ${formatDate(_selectedStartDate!)}");
        eventstartDate = formatDate(_selectedStartDate!);
      } else {
        _selectedEndDate = picked;
        debugPrint("Selected End Date: ${formatDate(_selectedEndDate!)}");
        eventendTime = formatDate(_selectedEndDate!);
      }
    }
  }

  var eventstartTime, eventendTime, eventstartDate, eventendDate;
// Time picker function
  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStartTime) {
        _selectedStartTime = picked;
        debugPrint("Selected Start Time: ${formatTime(_selectedStartTime!)}");
        eventstartTime = formatTime(_selectedStartTime!);
      } else {
        _selectedEndTime = picked;
        debugPrint("Selected End Time: ${formatTime(_selectedEndTime!)}");
        eventendTime = formatTime(_selectedEndTime!);
      }
    }
  }

  // Format functions
  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  Future<void> addTopic(
      {required String eventName,
      required String startDate,
      required String lastDate,
      required String startTime,
      required String lastTime,
      required String speaker,
      required String attendee,
      bool isApproved = false,
      required String nowDate,
      String? collab,
      required String description}) async {
    try {
      debugPrint(widget.uid);
      await _firestore
          .collection('Users')
          .doc(widget.uid)
          .collection('Events')
          .add({
        "eventName": eventNameController.text.trim(),
        "startDate":
            _selectedStartDate != null ? formatDate(_selectedStartDate!) : '',
        "lastDate":
            _selectedEndDate != null ? formatDate(_selectedEndDate!) : '',
        "startTime":
            _selectedStartTime != null ? formatTime(_selectedStartTime!) : '',
        "lastTime":
            _selectedEndTime != null ? formatTime(_selectedEndTime!) : '',
        "speaker": eventSpeakerController.text.trim(),
        "attendee": eventAttendeeController.text.trim(),
        "description": eventDesc.text.trim(),
        "collab": eventCollabController.text.trim(),
        "isApproved":false,
        "nowDate":formatDate(DateTime.now()),
      });
      debugPrint("Event added successfully");
    } catch (e) {
      debugPrint("Failed to add event: $e");
    }
  }

  void _submitEvent() {
    if (eventNameController.text.isEmpty ||
        eventSpeakerController.text.isEmpty ||
        eventAttendeeController.text.isEmpty ||
        eventDesc.text.isEmpty ||
        _selectedStartDate == null ||
        _selectedEndDate == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
    }
    debugPrint("before addTopic method");
    addTopic(
      eventName: eventNameController.text.trim(),
      startDate: "$eventstartDate",
      lastDate: "$eventendDate",
      startTime: "$_firestore",
      lastTime: "$eventendDate",
      speaker: eventSpeakerController.text.trim(),
      attendee: eventAttendeeController.text.trim(),
      description: eventDesc.text.trim(),
      collab: eventCollabController.text.trim(),
      isApproved:false,
      nowDate:"${formatDate(DateTime.now())}",
    );
    debugPrint("after addTopic method");
  }

  void eventRequestBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
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
                          onPressed: () {
                            setState(() {});
                            _selectDate(context, true);
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
                                _selectedStartDate != null
                                    ? "Start Date: ${formatDate(_selectedStartDate!)}"
                                    : "Pick a Start Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // Start Time Picker Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            _pickTime(context, true);
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
                                _selectedStartTime != null
                                    ? "Start Time: ${formatTime(_selectedStartTime!)}"
                                    : "Pick a Start Time",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),

                    // End Date Picker Button
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
                                    ? "End Date: ${formatDate(_selectedEndDate!)}"
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

                    // End Time Picker Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            _pickTime(context, false);
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
                                _selectedEndTime != null
                                    ? "End Time: ${formatTime(_selectedEndTime!)}"
                                    : "Pick an End Time",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Display selected date and time
                    // if (_selectedStartDate != null &&
                    //     _selectedStartTime != null)
                    //   Text(
                    //     "Event starts on ${formatDate(_selectedStartDate!)} at ${formatTime(_selectedStartTime!)}",
                    //     style: GoogleFonts.poppins(fontSize: 16),
                    //   ),
                    // if (_selectedEndDate != null && _selectedEndTime != null)
                    //   Text(
                    //     "Event ends on ${formatDate(_selectedEndDate!)} at ${formatTime(_selectedEndTime!)}",
                    //     style: GoogleFonts.poppins(fontSize: 16),
                    //   ),

                    // SizedBox(height: 20),
                    // Text(
                    //   _selectedStartDate != null && _selectedStartTime != null
                    //       ? "Start: ${formatDateTime(_selectedStartDate!, _selectedStartTime!)}"
                    //       : "Start date & time not selected",
                    //   style: TextStyle(fontSize: 16),
                    // ),
                    // Text(
                    //   _selectedEndDate != null && _selectedEndTime != null
                    //       ? "End: ${formatDateTime(_selectedEndDate!, _selectedEndTime!)}"
                    //       : "End date & time not selected",
                    //   style: TextStyle(fontSize: 16),
                    // // ),
                    //           SizedBox(height: 15),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 10),
                    //             child: Text(
                    //               'Time Slot',
                    //               style: GoogleFonts.poppins(
                    //                   fontSize: 20, fontWeight: FontWeight.w500),
                    //             ),
                    //           ),

                    //           Row(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               ElevatedButton(onPressed: () {

                    //               }, child: Text('Start')),
                    //               ElevatedButton(onPressed: () {

                    //               }, child: Text('End'))
                    //             ],
                    //           ),
                    SizedBox(height: 15),
                    // TimePickerDialog(
                    //   initialTime: TimeOfDay.now(),
                    //   initialEntryMode: TimePickerEntryMode.inputOnly,
                    // ),
                    SizedBox(height: 15),
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
                        onPressed: (){
                          _submitEvent();
                          Navigator.pop(context);
                        },
                        child: Text("Send Event Request"),
                      ),
                    ),
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
      appBar: AppBar(
        title: Text("Booking Application"),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '   My Bookings Requests',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.uid)
                    .collection('Events')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    final events = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          var event = events[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Text(
                                        widget.userName
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      backgroundColor: Colors.blue,
                                    ),
                                    SizedBox(width: 16.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(event["eventName"],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor)),
                                        Text("Speaker: ${event["speaker"]}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: secondaryColor)),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                              "Description: ${event["description"]}",
                                              maxLines: 4,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryColor)),
                                        ),
                                        Text(
                                            "From: ${event["startDate"]} to ${event["lastDate"]}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: secondaryColor)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return Center(child: Text('No Events.'));
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: eventRequestBottomSheet,
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 20,
        ),
      ),
    );
  }
}

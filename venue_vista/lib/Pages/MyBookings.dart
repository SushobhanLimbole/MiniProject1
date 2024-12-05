import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
//import 'package:new_venue_vista/Components/BottomNavigationBar.dart';
import 'package:venue_vista/Components/Constants.dart';

class Demo extends StatefulWidget {
  final String uid;
  final bool isAdmin;
  final String userName;
  final String userEmail;
  final String hallId;
  const Demo(
      {super.key,
      required this.hallId,
      required this.uid,
      required this.isAdmin,
      required this.userName,
      required this.userEmail});

  @override
  State<Demo> createState() => _DemoState();
}

Future<void> onReject(DocumentSnapshot event) async {
  await event.reference.delete();
  debugPrint("Event '${event['eventName']}' has been delete.");
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
  String? selectedslot;
  final List<String> slots = ['Morning Slot', 'Evening Slot', 'Full Day'];
  Map<String, String> slotAvailability = {};
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');

  // Date Picker
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
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

  void eventDeleteDialog(DocumentSnapshot event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Do yo really want to delete the Event?"),
        actions: [
          TextButton(
            onPressed: () {
              onReject(event);
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
        ],
      ),
    );
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
      required String hallId,
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
        "startDate": DateFormat('dd-MM-yyyy')
            .format(DateTime.parse("$_selectedStartDate")),
        "lastDate": DateFormat('dd-MM-yyyy')
            .format(DateTime.parse("$_selectedEndDate")),
        "speaker": eventSpeakerController.text.trim(),
        "attendee": eventAttendeeController.text.trim(),
        "description": eventDesc.text.trim(),
        "collab": eventCollabController.text.trim(),
        "isApproved": false,
        "isPending": true,
        "nowDate": DateTime.now(),
        "slot": selectedslot,
        "hallId": widget.hallId
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
        hallId: widget.hallId);
    debugPrint("after addTopic method");
  }

  void eventRequestBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
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
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: eventNameController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Event Name',
                        hintStyle: GoogleFonts.poppins(),
                        border: const OutlineInputBorder(
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
                    const SizedBox(height: 15),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Date & Time',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context, true),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.teal,
                          ),
                          child: SizedBox(
                            width: 200,
                            child: Center(
                              child: Text(
                                _selectedStartDate != null
                                    ? "Start Date: ${DateFormat('dd-MM-yyyy').format(_selectedStartDate!)}"
                                    : "Pick an End Date",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDate(context, false),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.teal,
                          ),
                          child: SizedBox(
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
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedslot,
                      items: slots.map((selectedStartDate) {
                        return DropdownMenuItem<String>(
                          value: selectedStartDate,
                          child: Text(selectedStartDate),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedslot = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Select Slots',
                        prefixIcon: Padding(
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
                        border: const OutlineInputBorder(
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
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: eventAttendeeController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Attedees',
                        hintStyle: GoogleFonts.poppins(),
                        border: const OutlineInputBorder(
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
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: eventCollabController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 230, 164, 186),
                        hintText: 'Collaboration(Optional)',
                        hintStyle: GoogleFonts.poppins(),
                        border: const OutlineInputBorder(
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
                    const SizedBox(height: 15),
                    TextField(
                      style: GoogleFonts.poppins(),
                      controller: eventDesc,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Enter the event description',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          _submitEvent();
                          Navigator.pop(context);
                        },
                        child: const Text("Send Event Request"),
                      ),
                    ),
                    const SizedBox(
                      height: 140,
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
      appBar: AppBar(
        title: const Text("My Requests"),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     Text(
          //       '   My Bookings ',
          //       style: TextStyle(
          //         color: secondaryColor,
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ],
          // ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(widget.uid)
                    .collection('Events')
                    .orderBy('startDate', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                              child: InkWell(
                                onDoubleTap: () => eventDeleteDialog(event),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          widget.userName
                                              .substring(0, 1)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      const SizedBox(width: 14.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(event["eventName"],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: secondaryColor)),
                                          Text("Speaker: ${event["speaker"]}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryColor)),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                                "Description: ${event["description"]}",
                                                maxLines: 4,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: secondaryColor)),
                                          ),
                                          Text(
                                              "From: ${event["startDate"]} to ${event["lastDate"]}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: secondaryColor)),
                                          Text(
                                                    'Venue: ${event['hallId']}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: secondaryColor)),
                                          event["isApproved"]
                                              ? const Text(
                                                  "Approved",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.green),
                                                )
                                              : const Text("Not Approved",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                  return const Center(child: Text('No Events.'));
                }),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     eventRequestBottomSheet();
      //   },
      //   backgroundColor: Colors.blueAccent,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.black,
      //     size: 20,
      //   ),
      // ),
      // bottomNavigationBar: BottomNavigatorBar(
      //     index: 1,
      //     hallId: widget.hallId,
      //     uid: widget.uid,
      //     isAdmin: widget.isAdmin,
      //     userEmail: widget.userEmail,
      //     userName: widget.userName),
    );
  }
}

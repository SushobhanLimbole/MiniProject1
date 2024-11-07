import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventDesc = TextEditingController();

  TimeOfDay? _selectedTime;

  // Function to pick the time
  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
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
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                      'Date',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 15),

                  TimePickerDialog(
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('Start')),
                      ElevatedButton(onPressed: () {}, child: Text('End'))
                    ],
                  ),

                  Container(
                    child: Text(
                      _selectedTime != null
                          ? "Selected Time: ${_selectedTime!.format(context)}"
                          : "No time selected",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text("Pick a Time"),
                  ),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Time Slot',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('Start')),
                      ElevatedButton(onPressed: () {}, child: Text('End'))
                    ],
                  ),
                  SizedBox(height: 15),
                  TimePickerDialog(
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.inputOnly,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: eventNameController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 230, 164, 186),
                      hintText: 'Speaker',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                    controller: eventNameController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 230, 164, 186),
                      hintText: 'Attedees',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                    controller: eventNameController,
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 230, 164, 186),
                      hintText: 'Collaboration(Optional)',
                      hintStyle: GoogleFonts.poppins(),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
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
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  eventRequestBottomSheet();
                },
                child: Text('Bottom'))
          ],
        ),
      ),
    );
  }
}
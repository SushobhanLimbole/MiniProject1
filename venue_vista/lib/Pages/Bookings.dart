import 'package:flutter/material.dart';
import 'package:venue_vista/Pages/request.dart';
import 'package:venue_vista/constants.dart';

class Booking extends StatelessWidget {
  final DateTime requestTime =
      DateTime(2024, 10, 25, 14, 30); // Adjust to your needs

  @override
  Widget build(BuildContext context) {
    final Duration timePassed = DateTime.now().difference(requestTime);
    final String formattedTimePassed = formatDuration(timePassed);

    return Scaffold(
      appBar: AppBar(
        title: Text('Auditorium',style: TextStyle(color: secondaryColor),),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Bookings',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: InkWell(
                  onTap: (){showBottomSheet(context);},
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: Text('PS'),
                          backgroundColor: Colors.blue,
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Event: Engineer\'s Day',
                                style: TextStyle(fontSize: 16,color: secondaryColor)),
                            Text('Dept: CSE', style: TextStyle(fontSize: 16,color: secondaryColor)),
                            Text('From: XYZ', style: TextStyle(fontSize: 16,color: secondaryColor)),
                            Text('${formattedTimePassed} ago accepted',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          widthFactor: 1.0, // Ensures full width
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Event Details',
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailRow(
                            label: 'EVENT TITLE', value: 'Engineer\'s Day'),
                        DetailRow(label: 'Dept', value: 'CSE'),
                        DetailRow(label: 'From', value: 'XYZ'),
                        DetailRow(
                          label: 'Details',
                          value:
                              'An event to celebrate engineers with a large description that covers every aspect of the event in detail. This section can handle long text and will display it properly.',
                        ),
                        DetailRow(label: 'Speaker', value: 'John Doe'),
                        DetailRow(label: 'Attendees', value: '150'),
                        DetailRow(
                            label: 'Time Slot', value: '2:00 PM - 4:00 PM'),
                        SizedBox(height: 20),
                      ],
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

  String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    } else {
      return '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''}';
    }
  }
}

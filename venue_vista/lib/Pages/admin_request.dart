// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:venue_vista/constants.dart';

// class AuditoriumScreen extends StatefulWidget {
//   final bool isAdmin;
//   final String uid;
//   final String userName;
//   final String userEmail;
//   AuditoriumScreen({required this.uid,required this.userName,required this.userEmail,required this.isAdmin});
//   @override
//   State<AuditoriumScreen> createState() => _AuditoriumScreenState();
// }

// class _AuditoriumScreenState extends State<AuditoriumScreen> {
//   final DateTime requestTime;

//   @override
//   Widget build(BuildContext context) {
//     // final Duration timePassed = DateTime.now().difference(requestTime);
//     final String formattedTimePassed = formatDuration(timePassed);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Requests Verification',
//           style: TextStyle(color: secondaryColor),
//         ),
//         centerTitle: true,
//         backgroundColor: primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Pending Requests',
//               style: TextStyle(
//                 color: secondaryColor,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 20),
//             StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('Users')
//                     .doc()
//                     .collection('Events')
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasData) {
//                     final events = snapshot.data!.docs;
//                     return ListView.builder(
//                         itemCount: events.length,
//                         itemBuilder: (context, index) {
//                           var event = events[index];
//                           return Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15.0),
//                             ),
//                             elevation: 5,
//                             child: InkWell(
//                               onTap: () {
//                                 showBottomSheet(context);
//                               },
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Row(
//                                   children: [
//                                     CircleAvatar(
//                                       child: Text(widget.userName.substring(0,1).toUpperCase()),
//                                       backgroundColor: Colors.blue,
//                                     ),
//                                     SizedBox(width: 16.0),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text('Event: ${event['eventName']}',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: secondaryColor)),
//                                         Text('Dept: ',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: secondaryColor)),
//                                         Text('From: XYZ',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: secondaryColor)),
//                                         Text(
//                                             'Requested ${formattedTimePassed} ago',
//                                             style: TextStyle(
//                                                 fontSize: 12,
//                                                 color: Colors.grey)),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         });
//                   }
//                   return Center(child: Text('No Pending Requests.'));
//                 }),
//           ],
//         ),
//       ),
//     );
//   }

//   String formatDuration(Duration duration) {
//     if (duration.inDays > 0) {
//       return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
//     } else if (duration.inHours > 0) {
//       return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
//     } else if (duration.inMinutes > 0) {
//       return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
//     } else {
//       return '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''}';
//     }
//   }
// }

// void showBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (context) {
//       return FractionallySizedBox(
//         heightFactor: 0.75,
//         widthFactor: 1.0, // Ensures full width
//         child: Container(
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.0),
//               topRight: Radius.circular(20.0),
//             ),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Event Details',
//                   style: TextStyle(
//                     color: secondaryColor,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                   padding: EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       DetailRow(label: 'EVENT TITLE', value: 'Engineer\'s Day'),
//                       DetailRow(label: 'Dept', value: 'CSE'),
//                       DetailRow(label: 'From', value: 'XYZ'),
//                       DetailRow(
//                         label: 'Details',
//                         value:
//                             'An event to celebrate engineers with a large description that covers every aspect of the event in detail. This section can handle long text and will display it properly.',
//                       ),
//                       DetailRow(label: 'Speaker', value: 'John Doe'),
//                       DetailRow(label: 'Attendees', value: '150'),
//                       DetailRow(label: 'Time Slot', value: '2:00 PM - 4:00 PM'),
//                       SizedBox(height: 20),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('ACCEPT'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.green,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('REJECT'),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 10),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// String formatDuration(Duration duration) {
//   if (duration.inDays > 0) {
//     return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
//   } else if (duration.inHours > 0) {
//     return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
//   } else if (duration.inMinutes > 0) {
//     return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
//   } else {
//     return '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''}';
//   }
// }

// class DetailRow extends StatelessWidget {
//   final String label;
//   final String value;

//   DetailRow({required this.label, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           SizedBox(height: 4.0),
//           Text(
//             value,
//             style: TextStyle(fontSize: 16, color: secondaryColor),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venue_vista/constants.dart';

class AdminAuditoriumScreen extends StatefulWidget {
  final bool isAdmin;
  final String uid;
  final String userName;
  final String userEmail;

  AdminAuditoriumScreen({
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.isAdmin,
  });

  @override
  State<AdminAuditoriumScreen> createState() => _AdminAuditoriumScreenState();
}

class _AdminAuditoriumScreenState extends State<AdminAuditoriumScreen> {
  final DateTime requestTime = DateTime(2024, 10, 25, 14, 30);

  @override
  Widget build(BuildContext context) {
    final Duration timePassed = DateTime.now().difference(requestTime);
    final String formattedTimePassed = formatDuration(timePassed);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Requests Verification',
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Requests',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  final users = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        var user = users[index];
                        var department = user['department'];
                        return StreamBuilder(
                          stream:
                              user.reference.collection('Events').snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> eventSnapshot) {
                            if (eventSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (eventSnapshot.hasData &&
                                eventSnapshot.data!.docs.isNotEmpty) {
                              final events = eventSnapshot.data!.docs;
                              return Column(
                                children: events.map((event) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 5,
                                    child: InkWell(
                                      onTap: () {
                                        showBottomSheet(
                                            context, event, department);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              child: Text(widget.userName
                                                  .substring(0, 1)
                                                  .toUpperCase()),
                                              backgroundColor: Colors.blue,
                                            ),
                                            SizedBox(width: 16.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    'Event: ${event['eventName']}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: secondaryColor)),
                                                Text('Dept: $department',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: secondaryColor)),
                                                Text('From: XYZ',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: secondaryColor)),
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                        'Requested ${formattedTimePassed} ago',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.grey)),
                                                    
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:5.0),
                                                      child: event['isApproved']
                                                          ? Text(
                                                              "Approved",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              "Not Approved",
                                                              style: TextStyle(
                                                                  color:
                                                                      Colors.red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                            return Center(child: Text(""));
                          },
                        );
                      },
                    ),
                  );
                }
                return Center(child: Text('No Users Found.'));
              },
            ),
          ],
        ),
      ),
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

Future<void> onAccept(DocumentSnapshot event) async {
  await event.reference.update({'isApproved': true});
  print("Event '${event['eventName']}' has been accepted.");
}

Future<void> onReject(DocumentSnapshot event) async {
  await event.reference.update({'isApproved': false});
  print("Event '${event['eventName']}' has been rejected.");
}

void showBottomSheet(
    BuildContext context, DocumentSnapshot event, String department) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.75,
        widthFactor: 1.0,
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
                          label: 'EVENT TITLE', value: event['eventName']),
                      DetailRow(label: 'Dept', value: department),
                      DetailRow(label: 'From', value: '${event['startDate']}'),
                      DetailRow(label: 'Details', value: event['description']),
                      DetailRow(label: 'Speaker', value: event['speaker']),
                      DetailRow(label: 'Attendees', value: event['attendee']),
                      DetailRow(
                          label: 'Time Slot',
                          value:
                              '${event['startTime']} - ${event['lastTime']}'),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              onAccept(event);
                              Navigator.pop(context);
                            },
                            child: Text('ACCEPT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              onReject(event);
                              Navigator.pop(context);
                            },
                            child: Text('REJECT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
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

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: secondaryColor),
          ),
        ],
      ),
    );
  }
}
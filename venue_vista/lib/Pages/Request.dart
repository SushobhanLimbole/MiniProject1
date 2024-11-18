import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venue_vista/Components/Constants.dart';

class Request extends StatefulWidget {
  final bool isAdmin;
  final String uid;
  final String userName;
  final String userEmail;

  Request({
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.isAdmin,
  });

  @override
  State<Request> createState() => _AuditoriumScreenState();
}

class _AuditoriumScreenState extends State<Request> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Requests',
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left:16.0,right: 16,top: 5),
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
            SizedBox(height: 5),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Users').where("email",isEqualTo:widget.userEmail).snapshots(),
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
                              user.reference.collection('Events').where("isApproved",isEqualTo: false).snapshots(),
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
                                  Timestamp timestamp=event['nowDate'];
                                  DateTime requestTime = timestamp.toDate();
                                  var formatedDate=formatDuration(DateTime.now().difference(requestTime));
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
                                                Text('From: ${event["startDate"]} to ${event["lastDate"]}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: secondaryColor)),
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                        'Requested ${formatedDate} ago',
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
                                                                      .green,fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )
                                                          : Text(
                                                              "Not Approved",
                                                              style: TextStyle(
                                                                fontSize: 12,
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
  await event.reference.delete();
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
          width: 200,
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
                SizedBox(height: 20,width: 350,),
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
                      DetailRow(label: 'Time Slot', value:'${event['slot']}'),
                      SizedBox(height: 10),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            child: event['isApproved']?Text('ACCEPTED'):Text('ACCEPT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: event['isApproved']? Colors.white:Colors.green,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                side: event['isApproved']? BorderSide(color: Colors.green):BorderSide(color: Colors.white),
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

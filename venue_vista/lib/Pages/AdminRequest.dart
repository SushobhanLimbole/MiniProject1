import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venue_vista/Components/Constants.dart';

class AdminRequest extends StatefulWidget {
  final bool isAdmin;
  final String uid;
  final String userName;
  final String userEmail;

  const AdminRequest({
    super.key,
    required this.uid,
    required this.userName,
    required this.userEmail,
    required this.isAdmin,
  });

  @override
  State<AdminRequest> createState() => _AdminAuditoriumScreenState();
}

class _AdminAuditoriumScreenState extends State<AdminRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Verification',
          style: TextStyle(color: secondaryColor),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10,top: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final users = snapshot.data!.docs;
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  var userName = user['userName'];
                  var department = user['department'];
                  return StreamBuilder(
                    stream: user.reference
                        .collection('Events')
                        .orderBy('startDate', descending: false)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot> eventSnapshot) {
                      if (eventSnapshot.hasData &&
                          eventSnapshot.data!.docs.isNotEmpty) {
                        final events = eventSnapshot.data!.docs;
                        return Column(
                          children: events.map((event) {
                            Timestamp timestamp = event['nowDate'];
                            DateTime requestTime = timestamp.toDate();
                            var formatedDate = formatDuration(
                                DateTime.now().difference(requestTime));
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: InkWell(
                                onTap: () {
                                  showBottomSheet(context, event, department);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, bottom: 5),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text(widget.userName
                                            .substring(0, 1)
                                            .toUpperCase()),
                                      ),
                                      const SizedBox(width: 16.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Event: ${event['eventName']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryColor)),
                                          Text('Dept: $department',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryColor)),
                                          Text('From: $userName',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryColor)),
                                          Text('Venue: ${event['hallId']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: secondaryColor)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                  'Requested $formatedDate ago',
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey)),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 5.0),
                                                child: event['isApproved']
                                                    ? const Text(
                                                        "Approved",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color:
                                                                Colors.green,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : const Text(
                                                        "Not Approved",
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.red,
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
                      return const Center();
                    },
                  );
                },
              );
            }
            return const Center(child: Text('No Users Found.'));
          },
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
  event['isApproved']
      ? await event.reference.update({'isApproved': false})
      : await event.reference.update({'isApproved': true});
}

Future<void> onReject(DocumentSnapshot event) async {
  await event.reference.delete();
  debugPrint("Event '${event['eventName']}' has been rejected.");
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
          decoration: const BoxDecoration(
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
                const Text(
                  'Event Details',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
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
                      DetailRow(label: 'Time Slot', value: '${event['slot']}'),
                      DetailRow(label: 'Venue', value: '${event['hallId']}'),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              onAccept(event);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: event['isApproved']
                                  ? Colors.white
                                  : Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                side: event['isApproved']
                                    ? const BorderSide(color: Colors.green)
                                    : const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: event['isApproved']
                                ? Text('ACCEPTED')
                                : Text('ACCEPT'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              onReject(event);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text('REJECT'),
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

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4.0),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: secondaryColor),
          ),
        ],
      ),
    );
  }
}

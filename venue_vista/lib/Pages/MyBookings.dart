import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:venue_vista/Components/BottomNavigationBar.dart';
import 'package:venue_vista/Components/Constants.dart';

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

Future<void> onReject(DocumentSnapshot event) async {
  await event.reference.delete();
  debugPrint("Event '${event['eventName']}' has been delete.");
}

class _DemoState extends State<Demo> {
  void eventDeleteDialog(DocumentSnapshot event) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Event"),
        content: Text("Do yo really want to delete the Event?"),
        actions: [
          TextButton(
            onPressed: () {
              onReject(event);
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: ()=>Navigator.pop(context),
            child: Text("No"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Requests"),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: secondaryColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '   My Bookings ',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
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
                                child: GestureDetector(
                                  onLongPress: (){
                                    eventDeleteDialog(event);
                                    Navigator.pop(context);
                                  },
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
                                          event["isApproved"]
                                              ? Text(
                                                  "Approved",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.green),
                                                )
                                              : Text("Not Approved",
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
                  return Center(child: Text('No Events.'));
                }),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: eventRequestBottomSheet,
      //   backgroundColor: Colors.blueAccent,
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.black,
      //     size: 20,
      //   ),
      // ),
      bottomNavigationBar: BottomNavigatorBar(
          index: 2,
          uid: widget.uid,
          isAdmin: widget.isAdmin,
          userEmail: widget.userEmail,
          userName: widget.userName),
    );
  }
}

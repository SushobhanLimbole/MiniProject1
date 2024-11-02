import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista_admin/EventDetails.dart';

class EventLog extends StatefulWidget {
  EventLog({super.key});
  @override
  State<EventLog> createState() => _EventLogState();
}

class _EventLogState extends State<EventLog> {
  final DateTime requestTime = DateTime(2024, 10, 25, 14, 30);

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

  Widget myContainer({required String str}){ 
    return Container(
      height: 40,
      margin: EdgeInsets.only(left:10,top:10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.black,width:1),
        borderRadius: BorderRadius.circular(4)
      ),
      padding: EdgeInsets.only(left:20,right:20),
      child: Center(
        child: Text(str,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final Duration timePassed = DateTime.now().difference(requestTime);
    final String formattedTimePassed = formatDuration(timePassed);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //leading: Icon(Icons.sort),
        backgroundColor: Color.fromRGBO(243, 193, 202, 1),
        title: Text(
          'Event Log',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    setState((){});
                  },
                  child: myContainer(str: "All")),
                InkWell(
                  onTap: (){
                    setState((){});
                  },
                  child: myContainer(str: "Incoming events")),
                InkWell(
                  onTap: (){
                    setState((){});
                  },
                  child: myContainer(str: "Recent events")),
              ],
            ),
          ),

          SizedBox(height: 10,),
          Expanded(
            child:ListView.builder(
            itemCount: 5,
            itemBuilder: (context,index){
              return GestureDetector(
              onTap:() => Navigator.push(context,
                MaterialPageRoute(builder: (context) => EventDetail())),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
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
                              style: TextStyle(fontSize: 16)),
                          Text('Dept: CSE', style: TextStyle(fontSize: 16)),
                          Text('From: XYZ', style: TextStyle(fontSize: 16)),
                          Text('Recent event held ${formattedTimePassed} ago',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            }
            )
          ),
        ],
      ),
    );
  }
}
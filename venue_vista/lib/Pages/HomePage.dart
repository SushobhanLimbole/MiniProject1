import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Components/AuditoriumCard.dart';
//import 'package:new_venue_vista/Components/BottomNavigationBar.dart';
import 'package:venue_vista/Components/Drawer.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final bool isAdmin;
  final String userName;
  final String userEmail;
  const HomePage(
      {super.key,
      required this.uid,
      required this.isAdmin,
      required this.userEmail,
      required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String hallId=" ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Home',
            style: GoogleFonts.poppins(),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () => _scaffoldKey.currentState!
                .openDrawer(), // Open drawer on icon tap
            child: const Icon(Icons.sort),
          ),
        ),
        body: StreamBuilder(
            stream: _firestore.collection('Hall').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.pinkAccent),
                );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              var venues = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    var venue = venues[index];
                    hallId = venue["id"]!;
                    return AuditoriumCard(
                        hallId: venue["id"],
                        uid: widget.uid,
                        isAdmin: widget.isAdmin,
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        imageUrl: venue["imgUrl"],
                        auditoriumName: venue["Venue"],
                        location: venue["location"]);
                  });
            }),
        drawer: AppDrawer(
          uid: widget.uid,
          hallId: hallId,
          isAdmin: widget.isAdmin,
          userEmail: widget.userEmail,
          userName: widget.userName,
        ),

        // bottomNavigationBar: BottomNavigatorBar(
        //     index: 0,
        //     uid: widget.uid,
        //     hallId: hallId,
        //     isAdmin: widget.isAdmin,
        //     userEmail: widget.userEmail,
        //     userName: widget.userName)
    );
  }
}

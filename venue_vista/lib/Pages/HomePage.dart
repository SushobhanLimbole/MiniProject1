import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Components/AuditoriumCard.dart';
import 'package:venue_vista/drawer.dart';

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
          child: Icon(Icons.sort),
        ),
      ),
      drawer: AppDrawer(uid: widget.uid,isAdmin: widget.isAdmin,userEmail: widget.userEmail,userName: widget.userName,),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            AuditoriumCard(
              uid: widget.uid,
              isAdmin: widget.isAdmin,
              userName: widget.userName,
              userEmail: widget.userEmail,
              imageUrl: 'assets/central_auditorium.jpg',
              auditoriumName: 'Central Auditorium',
              location: 'KBP College of Engineering,Satara',
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}

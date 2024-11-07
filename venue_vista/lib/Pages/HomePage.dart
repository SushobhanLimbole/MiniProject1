import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Components/AuditoriumCard.dart';
import 'package:venue_vista/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
          onTap: () => _scaffoldKey.currentState!.openDrawer(), // Open drawer on icon tap
          child: Icon(Icons.sort),
        ),
      ),

      drawer: AppDrawer(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 8,),
            AuditoriumCard(
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5cxO4h5ne-iKfZpH4vZPhRkP2YOgmbi6TfA&s',
              auditoriumName: 'Grand Auditorium',
              location: 'Downtown City Center',
            ),
            SizedBox(height: 16,),
            AuditoriumCard(
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5cxO4h5ne-iKfZpH4vZPhRkP2YOgmbi6TfA&s',
              auditoriumName: 'Grand Auditorium',
              location: 'Downtown City Center',
            ),
            SizedBox(height: 16,),
            AuditoriumCard(
              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5cxO4h5ne-iKfZpH4vZPhRkP2YOgmbi6TfA&s',
              auditoriumName: 'Grand Auditorium',
              location: 'Downtown City Center',
            ),
          ],
        ),
      ),
    );
  }
}

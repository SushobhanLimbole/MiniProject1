import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Pages/CalendarPage.dart';

class AuditoriumCard extends StatelessWidget {
  final String imageUrl;
  final String auditoriumName;
  final String location;

  const AuditoriumCard({
    required this.imageUrl,
    required this.auditoriumName,
    required this.location,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => CalendarPage(),)),
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15.0,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width - 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    auditoriumName,
                    style: GoogleFonts.montserrat(
                      fontSize: 22.0,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.grey[600],
                  size: 16.0,
                ),
                SizedBox(width: 2.0),
                Text(
                  location,
                  style: GoogleFonts.montserrat(
                    fontSize: 14.0,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w500
                   
                  ),
                ),
                SizedBox(height: 5,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

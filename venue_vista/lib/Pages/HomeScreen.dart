import 'package:flutter/material.dart';
import 'package:flutter_image_carousel_slider/asset_image_carousel_slider_left_right_show.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Pages/Title.dart';
import 'package:venue_vista/Pages/request.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var imageList = [
    "images/Aud1.jpeg",
    "images/Aud2.jpeg",
    "images/Aud3.jpeg",
    "images/Aud4.jpeg",
    "images/Aud5.jpeg",
    "images/Aud6.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.grey.shade900,
        shadowColor: Colors.grey.shade600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  width: 150,
                  margin: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      Text(
                        "User",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.grey.shade600,
                        title: Text("Notification"),
                        onTap: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.grey.shade600,
                        title: Text("Request"),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuditoriumScreen())),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor: Colors.grey.shade600,
                        title: Text("Setting"),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text("Logout")),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        //leading: Icon(Icons.sort),
        backgroundColor: Color.fromRGBO(243, 193, 202, 1),
        title: Text(
          'Venue Vista',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(80),
                        image: DecorationImage(
                            image: AssetImage(
                              "images/Logo.jpeg",
                            ),
                            fit: BoxFit.cover)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Welcome to Venue Vista",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        "Book your next event with ease",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 1,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:5.0,right:15.0,bottom:5.0),
              child: AssetImageCarouselSliderLeftRightShow(
                items: imageList,
                imageHeight: 400,
                dotColor: Colors.grey.shade900,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 20, right: 20, bottom: 10),
              child: InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TitlePage())),
                child: Container(
                  height: 50,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text(
                      "Check Availability",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

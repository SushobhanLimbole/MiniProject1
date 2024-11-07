import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Pages/SignInPage.dart';
import 'package:venue_vista/Pages/Test.dart';
import 'package:venue_vista/constants.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userPic = '';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
            accountName: InkWell(
              child: Text(
                'Username',
                style: GoogleFonts.poppins(color: secondaryColor),
              ),
            ),
            accountEmail:
                Text('useremail123@gmail.com', style: GoogleFonts.poppins(color: secondaryColor)),
            currentAccountPicture: userPic != ''
                ? ClipOval(
                    child: Image.network(
                      userPic,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        }
                      },
                    ),
                  )
                : CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: Text(
                      'US',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
          ),
          ListTile(
            leading: const Icon(
              Icons.event,
              color: secondaryColor,
            ),
            title: Text('My Bookings',style: GoogleFonts.poppins(color: secondaryColor,)),
            onTap: () {},
          ),
          ListTile(
              leading: const Icon(
                Icons.bar_chart,
                color: secondaryColor,
              ),
              title: Text('Monthly Report',style: GoogleFonts.poppins(color: secondaryColor,)),
              onTap: () {}),
          ListTile(
            leading: const Icon(
              Icons.bar_chart,
              color: secondaryColor,
            ),
            title: Text('Yearly Report',style: GoogleFonts.poppins(color: secondaryColor,)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.check,
              color: secondaryColor,
            ),
            title: Text('Booking Verification',style: GoogleFonts.poppins(color: secondaryColor,)),
            onTap: () {
              // Handle navigation
            },
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.help,
              color: secondaryColor,
            ),
            title: Text('FAQs',style: GoogleFonts.poppins(color: secondaryColor,)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip,
              color: secondaryColor,
            ),
            title: Text('Help',style: GoogleFonts.poppins(color: secondaryColor,)),
            onTap: () {},
          ),
          ListTile( 
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text('Sign Out',style: GoogleFonts.poppins(color: Colors.red),),
            onTap: () {
              // Handle navigation

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

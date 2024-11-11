import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Pages/Request.dart';
import 'package:venue_vista/Pages/SignInPage.dart';
//import 'package:venue_vista/Pages/Bookings.dart';
import 'package:venue_vista/Pages/Test.dart';
import 'package:venue_vista/Pages/profile.dart';
import 'package:venue_vista/Pages/report.dart';
import 'package:venue_vista/Pages/admin_request.dart';
import 'package:venue_vista/constants.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer(
      {super.key,
      required this.uid,
      required this.isAdmin,
      required this.userEmail,
      required this.userName});
  final String uid;
  final bool isAdmin;
  final String userName;
  final String userEmail;
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
                '${widget.userName}',
                style: GoogleFonts.poppins(color: secondaryColor),
              ),
            ),
            accountEmail: Text('${widget.userEmail}',
                style: GoogleFonts.poppins(color: secondaryColor)),
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
                : InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                  )));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor,
                      child: Text(
                        widget.userName.substring(0, 1).toUpperCase(),
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
          ),
          ListTile(
            leading: const Icon(
              Icons.event,
              color: secondaryColor,
            ),
            title: Text('My Bookings',
                style: GoogleFonts.poppins(
                  color: secondaryColor,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Demo(
                        uid: widget.uid,
                        isAdmin: widget.isAdmin,
                        userName: widget.userName,
                        userEmail: widget.userEmail))),
          ),
          ListTile(
              leading: const Icon(
                Icons.bar_chart,
                color: secondaryColor,
              ),
              title: Text('Monthly Report',
                  style: GoogleFonts.poppins(
                    color: secondaryColor,
                  )),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DepartmentBarChart()))),
          ListTile(
            leading: const Icon(
              Icons.bar_chart,
              color: secondaryColor,
            ),
            title: Text('Yearly Report',
                style: GoogleFonts.poppins(
                  color: secondaryColor,
                )),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => DepartmentBarChart())),
          ),
          ListTile(
            leading: const Icon(
              Icons.check,
              color: secondaryColor,
            ),
            title: Text('Booking Verification',
                style: GoogleFonts.poppins(
                  color: secondaryColor,
                )),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) =>widget.isAdmin?AdminAuditoriumScreen(
                        uid:widget.uid,
                        isAdmin: widget.isAdmin,
                        userName: widget.userName,
                        userEmail: widget.userEmail) :AuditoriumScreen(
                        uid:widget.uid,
                        isAdmin: widget.isAdmin,
                        userName: widget.userName,
                        userEmail: widget.userEmail))),
          ),
          // const Divider(),
          ListTile(
            leading: const Icon(
              Icons.help,
              color: secondaryColor,
            ),
            title: Text('FAQs',
                style: GoogleFonts.poppins(
                  color: secondaryColor,
                )),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip,
              color: secondaryColor,
            ),
            title: Text('Help',
                style: GoogleFonts.poppins(
                  color: secondaryColor,
                )),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              'Sign Out',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
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

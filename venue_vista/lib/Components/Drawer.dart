import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Pages/FAQsPage.dart';
import 'package:venue_vista/Pages/HelpPage.dart';
import 'package:venue_vista/Pages/Request.dart';
//import 'package:venue_vista/Pages/SignInPage.dart';
import 'package:venue_vista/Pages/MyBookings.dart';
import 'package:venue_vista/Pages/Profile.dart';
import 'package:venue_vista/Pages/Report.dart';
import 'package:venue_vista/Pages/AdminRequest.dart';
import 'package:venue_vista/Components/Constants.dart';
import 'package:venue_vista/Pages/SignInPage.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer(
      {super.key,
      required this.hallId,
      required this.uid,
      required this.isAdmin,
      required this.userEmail,
      required this.userName});
  final String uid;
  final String hallId;
  final bool isAdmin;
  final String userName;
  final String userEmail;
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  Future<void> signOutUser() async {
    await FirebaseAuth.instance.signOut();
    debugPrint("User signed out.");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));
  }

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
                widget.userName,
                style: GoogleFonts.poppins(color: secondaryColor),
              ),
            ),
            accountEmail: Text(widget.userEmail,
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
                                    uid: widget.uid,
                                    hallId: widget.hallId,
                                    isAdmin: widget.isAdmin,
                                    userEmail: widget.userEmail,
                                    userName: widget.userName,
                                  )));
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor,
                      child: Text(
                        widget.userName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 25),
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
                        hallId: widget.hallId,
                        isAdmin: widget.isAdmin,
                        userName: widget.userName,
                        userEmail: widget.userEmail))),
          ),
          widget.isAdmin
              ? ListTile(
                  leading: const Icon(
                    Icons.bar_chart,
                    color: secondaryColor,
                  ),
                  title: Text('Report',
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                      )),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const DepartmentMonthlyBarChart())))
              : Container(),
          widget.isAdmin
              ? ListTile(
                  leading: const Icon(
                    Icons.check,
                    color: secondaryColor,
                  ),
                  title: Text('Request Verification',
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                      )),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => widget.isAdmin
                              ? AdminRequest(
                                  uid: widget.uid,
                                  isAdmin: widget.isAdmin,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail)
                              : Request(
                                  uid: widget.uid,
                                  isAdmin: widget.isAdmin,
                                  userName: widget.userName,
                                  userEmail: widget.userEmail))),
                )
              : Container(),
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
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => FAQsPage())),
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
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HelpPage())),
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
            onTap:signOutUser,
          ),
        ],
      ),
    );
  }
}

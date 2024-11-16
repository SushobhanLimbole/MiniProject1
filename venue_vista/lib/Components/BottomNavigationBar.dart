import 'package:flutter/material.dart';
import 'package:venue_vista/Components/Constants.dart';
import 'package:venue_vista/Pages/MyRequests.dart';
import 'package:venue_vista/Pages/CalendarPage.dart';
import 'package:venue_vista/Pages/HomePage.dart';
import 'package:venue_vista/Pages/Profile.dart';

class BottomNavigatorBar extends StatelessWidget {
  const BottomNavigatorBar(
      {super.key,
      required this.index,
      required this.uid,
      required this.isAdmin,
      required this.userEmail,
      required this.userName});
  final String uid;
  final int index;
  final bool isAdmin;
  final String userName;
  final String userEmail;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      backgroundColor: secondaryColor,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        uid: uid,
                        isAdmin: isAdmin,
                        userEmail: userEmail,
                        userName: userName))),
            child: Icon(
              Icons.home,
              color: primaryColor,
            ),
          ),
          activeIcon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.home,
              color: primaryColor,
            ),
          ),
          label: "Home",
          tooltip: "Home",
          backgroundColor: secondaryColor,
        ),
        BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarPage(
                    uid: uid,
                    isAdmin: isAdmin,
                    userEmail: userEmail,
                    userName: userName,
                  ),
                ),
              ),
              child: Icon(
                Icons.calendar_month,
                color: primaryColor,
              ),
            ),
            activeIcon: Icon(
              Icons.calendar_month_outlined,
              color: primaryColor,
            ),
            backgroundColor: secondaryColor,
            label: "Calendar",
            tooltip: "Check Availavility"),
        BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Demo(
                          uid: uid,
                          isAdmin: isAdmin,
                          userName: userName,
                          userEmail: userEmail))),
              child: Icon(
                Icons.post_add_outlined,
                color: primaryColor,
              ),
            ),
            activeIcon: Icon(
              Icons.post_add_rounded,
              color: primaryColor,
            ),
            backgroundColor: secondaryColor,
            label: "Booking",
            tooltip: "Book your slot"),
        BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uid: uid,
                          isAdmin: isAdmin,
                          userName: userName,
                          userEmail: userEmail))),
              child: Icon(
                Icons.account_circle_outlined,
                color: primaryColor,
              ),
            ),
            activeIcon: Icon(
              Icons.account_circle,
              color: primaryColor,
            ),
            backgroundColor: secondaryColor,
            label: "Profile",
            tooltip: "Edit your profile"),
      ],
    );
  }
}

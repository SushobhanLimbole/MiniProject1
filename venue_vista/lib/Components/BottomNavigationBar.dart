import 'package:flutter/material.dart';
import 'package:venue_vista/Components/Constants.dart';
import 'package:venue_vista/Pages/MyBookings.dart';
//import 'package:new_venue_vista/Pages/CalendarPage.dart';
import 'package:venue_vista/Pages/HomePage.dart';
import 'package:venue_vista/Pages/Profile.dart';

class BottomNavigatorBar extends StatelessWidget {
  const BottomNavigatorBar(
      {super.key,
      required this.index,
      required this.uid,
      required this.isAdmin,
      required this.userEmail,
      required this.userName,
      required this.hallId});
  final String uid;
  final int index;
  final bool isAdmin;
  final String userName;
  final String userEmail;
  final String hallId;
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
            child: const Icon(
              Icons.home,
              color: primaryColor,
            ),
          ),
          activeIcon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Icon(
              Icons.home,
              color: primaryColor,
            ),
          ),
          label: "Home",
          tooltip: "Home",
          backgroundColor: secondaryColor,
        ),
        // BottomNavigationBarItem(
        //     icon: GestureDetector(
        //       onTap: () => Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => CalendarPage(
        //             hallId: hallId,
        //             uid: uid,
        //             isAdmin: isAdmin,
        //             userEmail: userEmail,
        //             userName: userName,
        //           ),
        //         ),
        //       ),
        //       child: const Icon(
        //         Icons.calendar_month,
        //         color: primaryColor,
        //       ),
        //     ),
        //     activeIcon: const Icon(
        //       Icons.calendar_month_outlined,
        //       color: primaryColor,
        //     ),
        //     backgroundColor: secondaryColor,
        //     label: "Calendar",
        //     tooltip: "Check Availavility"),
        BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Demo(
                          uid: uid,
                          hallId: hallId,
                          isAdmin: isAdmin,
                          userName: userName,
                          userEmail: userEmail))),
              child: const Icon(
                Icons.event,
                color: primaryColor,
              ),
            ),
            activeIcon: const Icon(
              Icons.event_outlined,
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
                          hallId:hallId,
                          isAdmin: isAdmin,
                          userName: userName,
                          userEmail: userEmail))),
              child: const Icon(
                Icons.account_circle_outlined,
                color: primaryColor,
              ),
            ),
            activeIcon: const Icon(
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

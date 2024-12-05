import 'package:venue_vista/Components/Constants.dart';
import 'package:venue_vista/Pages/HomePage.dart';
import 'package:venue_vista/Pages/SignInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  /// Fetches user details like role, userName, and userEmail from Firestore.
  Future<Map<String, String>?> _getUserDetails(User user) async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();

      if (userDoc.exists) {
        final String userName = userDoc['userName'] ?? 'Unknown';
        final String userRole = userDoc['role'] ?? 'Faculty'; // Default role
        final String userEmail = user.email ?? 'Unknown';

        return {
          'role': userRole,
          'userName': userName,
          'userEmail': userEmail,
        };
      } else {
        debugPrint('No user document found for UID: ${user.email}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          }

          if (authSnapshot.hasError) {
            return const Center(
              child: Text("Something went wrong with authentication."),
            );
          }

          final User? user = authSnapshot.data;

          if (user == null) {
            // User is not authenticated; navigate to SignInPage
            return const SignInPage();
          }

          // User is authenticated, fetch additional details
          return FutureBuilder<Map<String, String>?>(
            future: _getUserDetails(user),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: secondaryColor,
                  ),
                );
              }

              if (roleSnapshot.hasError) {
                debugPrint('Error in role snapshot: ${roleSnapshot.error}');
                return const Center(
                  child: Text("Error retrieving user role."),
                );
              }

              final userDetails = roleSnapshot.data;

              if (userDetails == null) {
                return const Center(
                  child: Text("User details not found."),
                );
              }

              final String role = userDetails['role']!;
              final String userName = userDetails['userName']!;
              final String userEmail = userDetails['userEmail']!;

              // Navigate based on role
              return HomePage(
                uid: userEmail,
                isAdmin: role == 'Admin',
                userName: userName,
                userEmail: userEmail,
              );
            },
          );
        },
      ),
    );
  }
}

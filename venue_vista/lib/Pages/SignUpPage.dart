import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:venue_vista/Components/constants.dart';
import 'package:venue_vista/Pages/SignInPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _authService = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>(); // Key for the form
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  bool isVerified = false;
  String? selectedRole; // This will hold the selected role from the dropdown
  String? selectedDepartment;
  String? otp;

  final List<String> roles = ['Admin', 'Faculty']; // Roles list
  final List<String> departments = [
    'CSE',
    'Mechanical',
    'Civil',
    'ENTC',
    'AIDS'
  ];
  String generateOTP(int length) {
    const chars = '0123456789'; // Allowed characters for the OTP (digits only)
    final random = Random(); // Instance of Random to generate random numbers
    return String.fromCharCodes(
      Iterable.generate(
          length, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }

  Future sendEmail(String email) async {
    if (email.isEmpty || email.trim().isEmpty) {
      // Email is null or empty
      debugPrint("Error: Email cannot be null or empty");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return; // Exit the function early
    }

    try {
      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      const serviceid =
          "service_epjudfi"; // Replace with your EmailJS service ID
      const templateid =
          "template_itcxm4e"; // Replace with your EmailJS template ID
      const publickey =
          "WZlIBgRns3yRc1tAd"; // Replace with your EmailJS public key
      const privateKey =
          "1yZuslns59KY87r-ue5yA"; // Replace with your EmailJS private key

      final otp = generateOTP(6);
      this.otp = otp; // Store OTP for verification

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          "service_id": serviceid,
          "template_id": templateid,
          "user_id": publickey, // Pass the public key here
          "accessToken": privateKey,
          "template_params": {
            "otp": otp, // OTP parameter for your template
            "email": email // Recipient's email address
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Email sent successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP sent successfully to $email")),
        );
        return response.statusCode;
      } else {
        debugPrint("Failed to send email. Status: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP. Please try again.")),
        );
        return response.statusCode;
      }
    } catch (e) {
      debugPrint("Error occurred while sending email: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred while sending email: $e")),
      );
      return null;
    }
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid ?? false) {
      _formKey.currentState?.save();

      // Show loading SnackBar
      final loadingSnackBar = SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Registering user, please wait...'),
          ],
        ),
        duration: Duration(minutes: 1), // Keep it visible for longer duration
      );
      ScaffoldMessenger.of(context).showSnackBar(loadingSnackBar);

      try {
        if (userNameController.text.isNotEmpty) {
          if (confirmPasswordController.text.isEmpty) {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide loading SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please confirm your password.')),
            );
          } else if (passwordController.text ==
              confirmPasswordController.text) {
            UserCredential userCredential =
                await _authService.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
            User? user = userCredential.user;

            if (user != null) {
              await user.updateDisplayName(userNameController.text);

              // Add user details to Firestore
              await _firestore
                  .collection('Users')
                  .doc(emailController.text)
                  .set({
                'userName': userNameController.text,
                'email': emailController.text,
                'password': passwordController.text,
                'role': selectedRole,
                'department': selectedDepartment,
              });

              ScaffoldMessenger.of(context)
                  .hideCurrentSnackBar(); // Hide loading SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User registered successfully')),
              );

              // Navigate to SignInPage after successful registration
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInPage(),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context)
                .hideCurrentSnackBar(); // Hide loading SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password mismatch')),
            );
          }
        } else {
          ScaffoldMessenger.of(context)
              .hideCurrentSnackBar(); // Hide loading SnackBar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please enter your username')),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context)
            .hideCurrentSnackBar(); // Hide loading SnackBar
        String message = 'An error occurred, please check your credentials!';
        if (e.code == 'email-already-in-use') {
          message = 'The email address is already in use by another account.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is badly formatted.';
        } else if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        debugPrint('error = $e');
        ScaffoldMessenger.of(context)
            .hideCurrentSnackBar(); // Hide loading SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void verificationDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Verify OTP"),
        content: TextFormField(
          controller: otpController,
          decoration: InputDecoration(
            labelText: 'Enter OTP',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (otpController.text.trim() == otp.toString()) {
                setState(() => isVerified = true);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('OTP Verified!')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Incorrect OTP, try again')),
                );
              }
            },
            child: Text("Verify"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign form key
            child: Column(
              children: [
                // logo
                Container(
                  height: 130,
                  width: 130,
                  margin: const EdgeInsets.only(top: 50, bottom: 15),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/logo.png'))),
                ),

                Text(
                  'Nice to Meet You!',
                  style: GoogleFonts.poppins(
                      fontSize: 30, fontWeight: FontWeight.w700),
                ),

                Text(
                  'Create Your Account',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 30.0),

                TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.person),
                    ),
                  ),
                  validator: (value) {
                    // Basic email validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                // Email TextField
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.email),
                    ),
                  ),
                  autofillHints: null,
                  validator: (value) {
                    // Basic email validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailPattern = r'^[^@]+@[^@]+\.[^@]+$';
                    if (!RegExp(emailPattern).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                isVerified
                    ? ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          side: BorderSide(color: secondaryColor),
                          backgroundColor: primaryColor,
                        ),
                        child: Container(
                          width: 200,
                          child: Center(
                            child: Text(
                              "Verified",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: secondaryColor),
                            ),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          sendEmail(emailController.text.trim());
                          if (emailController.text.trim().isNotEmpty) {
                            verificationDialog();
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: secondaryColor),
                              borderRadius: BorderRadius.circular(100)),
                          backgroundColor: primaryColor,
                        ),
                        child: Container(
                          width: 200,
                          child: Center(
                            child: Text(
                              "Verify Email",
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: secondaryColor),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 16.0),
                // Password TextField
                TextFormField(
                  controller: passwordController,
                  obscureText: _isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.password),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: _isPasswordVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(
                                Icons.visibility_off,
                              ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    // Basic password validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Confirm Password TextField
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.password),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      }),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: _isPasswordVisible
                            ? const Icon(Icons.visibility)
                            : const Icon(
                                Icons.visibility_off,
                              ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    // Basic password validation
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      return 'Password mismatch';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Department Dropdown
                DropdownButtonFormField<String>(
                  value: selectedDepartment,
                  items: departments.map((dept) {
                    return DropdownMenuItem<String>(
                      value: dept,
                      child: Text(dept),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDepartment = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Department',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.business),
                    ),
                  ),
                  validator: (value) {
                    // Validate if a role is selected
                    if (value == null) {
                      return 'Please select a department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Role Dropdown
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: roles.map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Role',
                    prefixIcon: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(Icons.person),
                    ),
                  ),
                  validator: (value) {
                    // Validate if a role is selected
                    if (value == null) {
                      return 'Please select a role';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),

                // Sign Up Button
                isVerified
                    ? ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If all validations pass
                            debugPrint('Email: ${emailController.text}');
                            debugPrint('Password: ${passwordController.text}');
                            debugPrint('Role: $selectedRole');
                            _trySubmit();
                          }
                        },
                        child: Text(
                          'Create My Account',
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // If all validations pass
                            // debugPrint('Email: ${emailController.text}');
                            // debugPrint('Password: ${passwordController.text}');
                            // debugPrint('Role: $selectedRole');
                            // _trySubmit();
                            return;
                          }
                        },
                        child: Text(
                          'Create My Account',
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

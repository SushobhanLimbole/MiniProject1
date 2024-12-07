import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:new_venue_vista/Components/BottomNavigationBar.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  final String userName;
  final String uid;
  final String hallId;
  final String userEmail;
  final bool isAdmin;
  const ProfileScreen(
      {super.key,
      required this.hallId,
      required this.userName,
      required this.userEmail,
      required this.uid,
      required this.isAdmin});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final TextEditingController _usernameController =
      TextEditingController(text: '');
  bool _isEditing = false;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          backgroundColor: Colors.teal[1000],
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit,
                  color: Colors.white),
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
                if (!_isEditing) {
                  // Save action
                  String username = _usernameController.text;
                  print('Username: $username');
                  if (_image != null) {
                    print('Profile Photo: ${_image!.path}');
                  }
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          _image != null ? FileImage(File(_image!.path)) : null,
                      backgroundColor: Colors.teal[100],
                      child: _image == null
                          ? const Icon(Icons.person,
                              size: 80, color: Colors.white)
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo,
                                color: Colors.white, size: 30),
                            onPressed: _pickImage,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _isEditing
                    ? TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: const TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.person, size: 30),
                        ),
                        style: const TextStyle(fontSize: 24),
                      )
                    : Text(
                        _usernameController.text,
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[900]),
                      ),
              ],
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigatorBar(
        //     index: 2,
        //     hallId: widget.hallId,
        //     uid: widget.uid,
        //     isAdmin: true,
        //     userEmail: widget.userEmail,
        //     userName: widget.userName)
    );
  }
}

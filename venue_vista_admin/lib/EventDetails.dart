import 'package:flutter/material.dart';

class EventDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Event Highlights',
            style: TextStyle(color: Colors.amber),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/jp.png'), // Replace with your image asset
                        radius: 25.0,
                      ),
                      SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pranav Ghorpade',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            'Satara, India',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images.jpeg'), // Replace with your image asset
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 200.0, // You can adjust the height as needed
                    width: double.infinity,
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () {},
                            color: Colors.red,
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {},
                            color: Colors.blue,
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {},
                            color: Colors.green,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border),
                        onPressed: () {},
                        color: Colors.black,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: 'Event Organizer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text:
                              ' Exciting sessions lined up for the conference',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'View all 10 comments',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '2 hours ago',
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FAQsPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I book an auditorium through the Venue Vista app?',
      'answer':
          'To book an auditorium, log in to the app, navigate to the booking section, and select an available date and time slot. Complete the required booking details, and submit your request. You will receive a notification once the booking is approved by the admin.'
    },
    {
      'question': 'What are the available time slots for booking?',
      'answer':
          'The auditorium can be booked for various time slots, including morning, afternoon, and full-day sessions. The availability of slots may vary depending on existing bookings and the type of event you plan to host.'
    },
    {
      'question': 'Can I modify or cancel a booking after it is approved?',
      'answer':
          'Yes, you can request modifications or cancellations. However, approval is subject to admin review and the time remaining before the booked date. Cancellations within 24 hours of the event may incur restrictions based on college policies.'
    },
    {
      'question': 'Who can approve my booking request?',
      'answer':
          'Once you submit a booking request, it will be reviewed by the admin assigned to manage auditorium bookings. They will verify the details and either approve or reject the request based on availability and other considerations.'
    },
    {
      'question': 'How can I check the status of my booking request?',
      'answer':
          'You can view the status of your booking request in the “My Bookings” section of the app. Here, you can track whether your request is pending, approved, or declined, and receive notifications for any changes in status.'
    },
    {
      'question': 'Can I book the auditorium for recurring events?',
      'answer':
          'Yes, the app allows you to schedule recurring bookings. When making a booking, select the recurring option and specify the frequency (e.g., weekly or monthly). The admin will approve each instance individually based on availability.'
    },
    {
      'question': 'What should I do if the auditorium is unavailable for my preferred date?',
      'answer':
          'If the auditorium is unavailable on your preferred date, consider choosing a different date or time slot. You can also join a waitlist, and the admin will notify you if the slot becomes available due to cancellations.'
    },
    {
      'question': 'Are there guidelines for using the auditorium facilities?',
      'answer':
          'Yes, guidelines for auditorium usage are provided in the app’s guidelines section. These include information on equipment usage, seating arrangements, and cleanup responsibilities. It is important to review these guidelines before your event.'
    },
    {
      'question': 'How can I contact the admin for special requests?',
      'answer':
          'You can contact the admin directly through the “Contact Admin” feature in the app. This is useful if you have special setup requirements, need additional equipment, or have any questions about the booking policies.'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQs'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              faqs[index]['question']!,
              style: GoogleFonts.poppins(),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  faqs[index]['answer']!,
                  style: GoogleFonts.poppins(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

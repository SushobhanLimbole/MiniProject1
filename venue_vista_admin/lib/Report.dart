import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //leading: Icon(Icons.sort),
        backgroundColor: Color.fromRGBO(243, 193, 202, 1),
        title: Text(
          'Report',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Container(
        
      ),
    );
  }
}
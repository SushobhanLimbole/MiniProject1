import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:venue_vista/constants.dart';

class DepartmentBarChart extends StatelessWidget {
  const DepartmentBarChart({super.key});

  Future<Map<String, int>> _fetchDepartmentBookings() async {
    Map<String, int> bookings = {};

    // Get all documents in the 'Users' collection
    final usersSnapshot = await FirebaseFirestore.instance.collection('Users').get();

    for (var userDoc in usersSnapshot.docs) {
      // Retrieve department name from the user document
      final department = userDoc['department'] as String;

      // Get the count of documents in the 'Events' subcollection
      final eventsSnapshot = await userDoc.reference.collection('Events').get();
      final eventCount = eventsSnapshot.docs.length;

      // Accumulate event counts for each department
      bookings[department] = (bookings[department] ?? 0) + eventCount;
    }

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchDepartmentBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No booking data available.'));
          }

          final departmentBookings = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: departmentBookings.values.reduce((a, b) => a > b ? a : b).toDouble() + 10,
                barGroups: _buildBarGroups(departmentBookings),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= departmentBookings.length) return SizedBox.shrink();
                        final department = departmentBookings.keys.elementAt(value.toInt());
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(department, style: TextStyle(fontSize: 10)),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
              ),
            ),
          );
        },
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, int> departmentBookings) {
    return departmentBookings.entries.map((entry) {
      final index = departmentBookings.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: secondaryColor,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}

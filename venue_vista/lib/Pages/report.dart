import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:venue_vista/Components/constants.dart';
import 'package:intl/intl.dart';

class DepartmentMonthlyBarChart extends StatefulWidget {
  const DepartmentMonthlyBarChart({super.key});

  @override
  _DepartmentMonthlyBarChartState createState() =>
      _DepartmentMonthlyBarChartState();
}

class _DepartmentMonthlyBarChartState extends State<DepartmentMonthlyBarChart> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  Future<Map<String, int>> _fetchDepartmentBookings(int month, int year) async {
    Map<String, int> bookings = {};

    final usersSnapshot =
        await FirebaseFirestore.instance.collection('Users').get();

    for (var userDoc in usersSnapshot.docs) {
      final department = userDoc['department'] as String;

      final eventsSnapshot = await userDoc.reference
          .collection('Events')
          .where("isApproved", isEqualTo: true)
          .get();

      int eventCount = 0;
      for (var eventDoc in eventsSnapshot.docs) {
        String startDateStr = eventDoc['startDate']; // Get startDate as string

        // Parse the startDate string using DateFormat
        DateTime startDate = DateFormat("dd-MM-yyyy").parse(startDateStr);

        // Check if startDate matches the selected month and year
        if (startDate.month == month && startDate.year == year) {
          eventCount++;
        }
      }

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
        actions: [
          DropdownButton<int>(
            value: selectedMonth,
            items: List.generate(12, (index) {
              return DropdownMenuItem(
                value: index + 1,
                child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
              );
            }),
            onChanged: (month) {
              setState(() {
                selectedMonth = month!;
              });
            },
          ),
          DropdownButton<int>(
            value: selectedYear,
            items: List.generate(11, (index) {
              int year = 2020 + index;
              return DropdownMenuItem(
                value: year,
                child: Text(year.toString()),
              );
            }),
            onChanged: (year) {
              setState(() {
                selectedYear = year!;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, int>>(
        future: _fetchDepartmentBookings(selectedMonth, selectedYear),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No booking data available for this period.'));
          }

          final departmentBookings = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: departmentBookings.values
                        .reduce((a, b) => a > b ? a : b)
                        .toDouble() +
                    10,
                barGroups: _buildBarGroups(departmentBookings),
                titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= departmentBookings.length)
                            return SizedBox.shrink();
                          final department =
                              departmentBookings.keys.elementAt(value.toInt());
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(department,
                                style: TextStyle(fontSize: 10)),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text("No. of Events"),
                      drawBelowEverything: true,
                      axisNameSize: 20,
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval:
                            1, // Set interval to prevent overlapping titles
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style:
                                TextStyle(fontSize: 14, color: Colors.black87),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false))),
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

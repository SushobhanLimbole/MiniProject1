import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:venue_vista/constants.dart';

class DepartmentBarChart extends StatelessWidget {
  // Data for department bookings
  //final String? title;
  //DepartmentBarChart({required String title});
  final Map<String, int> departmentBookings = {
    "CSE": 15,
    "MECH": 10,
    "ECE": 12,
    "CIVIL": 8,
    "EEE": 7,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 8.0,top: 8,bottom: 8,left: 14),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: departmentBookings.values.reduce((a, b) => a > b ? a : b).toDouble() + 5,
            barGroups: _buildBarGroups(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final department = departmentBookings.keys.elementAt(value.toInt());
                    return Text(department, style: TextStyle(fontSize: 10));
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
      ),
    );
    
  }

  List<BarChartGroupData> _buildBarGroups() {
    return departmentBookings.entries.map((entry) {
      final index = departmentBookings.keys.toList().indexOf(entry.key);
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: secondaryColor,
            width:18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }
}

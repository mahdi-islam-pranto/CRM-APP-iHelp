import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Models/leadSource.dart';

class LeadSourceChart extends StatefulWidget {
  @override
  _LeadSourceChartState createState() => _LeadSourceChartState();
}

class _LeadSourceChartState extends State<LeadSourceChart> {
  late Future<List<LeadSourceData>> futureLeadSourceData;

  @override
  void initState() {
    super.initState();
    futureLeadSourceData = fetchLeadSourceData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeadSourceData>>(
      future: futureLeadSourceData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No data available"));
        }

        List<LeadSourceData> leadSourceData = snapshot.data!;

        // Create the pie chart sections
        List<PieChartSectionData> sections = leadSourceData.map((data) {
          final value = double.tryParse(data.isActive) ?? 0.0;
          return PieChartSectionData(
            color: _getColor(data.name),
            value: value,
            title:
                "${(value * 100 / _total(leadSourceData)).toStringAsFixed(1)}%",
            titleStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          );
        }).toList();

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 50,
                  sectionsSpace: 0,
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicators(leadSourceData),
              ],
            )
          ],
        );
      },
    );
  }

  // Helper method to calculate the total sum of values
  double _total(List<LeadSourceData> data) {
    return data.fold(
        0.0, (sum, item) => sum + (double.tryParse(item.isActive) ?? 0.0));
  }

  // Helper method to get color based on the lead source name
  Color _getColor(String name) {
    switch (name) {
      case "Facebook":
        return Colors.blueAccent;
      case "Website":
        return Colors.green;
      case "Self Generated":
        return Colors.orange;
      case "Existing Customer":
        return Colors.red;
      case "Cold Call":
        return Colors.purple;
      case "Other":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  // Build the indicators for the legend
  Widget _buildIndicators(List<LeadSourceData> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.map((item) {
        return Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: _getColor(item.name),
            ),
            SizedBox(width: 8),
            Text(item.name),
          ],
        );
      }).toList(),
    );
  }
}

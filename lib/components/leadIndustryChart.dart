import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../Models/leadIndustry.dart';

class LeadIndustryChart extends StatefulWidget {
  @override
  _LeadIndustryChartState createState() => _LeadIndustryChartState();
}

class _LeadIndustryChartState extends State<LeadIndustryChart> {
  late Future<List<LeadIndustryData>> futureLeadIndustryData;

  @override
  void initState() {
    super.initState();
    futureLeadIndustryData = fetchLeadIndustryData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LeadIndustryData>>(
      future: futureLeadIndustryData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // return Center(child: Text("Error: ${snapshot.error}"));
          return const Center(child: Text("Couldn't Generate Chart"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data available"));
        }

        List<LeadIndustryData> leadIndustryData = snapshot.data!;

        // Calculate maxY dynamically based on the data
        final maxY = leadIndustryData
                .map((e) => e.count.toDouble())
                .reduce((a, b) => a > b ? a : b) *
            1.2;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY.isFinite ? maxY : 100, // Ensure maxY is finite
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= leadIndustryData.length) {
                          return const Text('');
                        }
                        final industry = leadIndustryData[index];
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Text(
                              industry.category,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 10, // Smaller font size
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // Format Y-axis values
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                      reservedSize: 40, // Adjust size for better fit
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barGroups: leadIndustryData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final industry = entry.value;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: industry.count.toDouble(),
                        color: Colors.amber,
                        width: 15,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

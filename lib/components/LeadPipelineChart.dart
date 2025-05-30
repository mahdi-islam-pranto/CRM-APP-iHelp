import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/components/DashboardFollowUps.dart';

import '../Models/leadPipeline.dart';

class LeadPipelineChart extends StatelessWidget {
  final List<LeadPipelineData> data;
  final List<String> categories;

  const LeadPipelineChart(
      {super.key, required this.data, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260, // Adjust height as needed
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    // Removes background color
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 0,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 8, // Smaller font size
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
                barGroups: data.map((lead) {
                  return BarChartGroupData(
                    x: lead.orderNo,
                    barRods: [
                      BarChartRodData(
                        toY: lead.value,
                        color: Colors.blue,
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5.0,
              children: List.generate(categories.length, (index) {
                return Text("${index + 1}. ${categories[index]}",
                    style: const TextStyle(fontSize: 12));
              }),
            ),
          ),
        ],
      ),
    );
  }
}

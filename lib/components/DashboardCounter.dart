import 'package:flutter/material.dart';

import 'package:untitled1/resourses/app_colors.dart';

class DashboardCounter extends StatelessWidget {
  const DashboardCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        // flex containers
        children: [Container(), Container(), Container(), Container()],
      ),
    );
  }
}

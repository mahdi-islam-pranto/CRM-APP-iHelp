import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/resourses/resourses.dart';

class AppTextStyle {
  TextStyle poppins({
    double? fontsize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontsize ?? 20.0,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? R.appColors.blackColor,
    );
  }

  TextStyle inter({
    double? fontsize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: fontsize ?? 14.0,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? R.appColors.blackColor,
    );
  }
}

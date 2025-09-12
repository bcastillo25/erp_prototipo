import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  ThemeData getTheme() {

    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      useMaterial3: true,
      visualDensity: VisualDensity.adaptivePlatformDensity,

      textTheme: TextTheme(
        titleLarge: GoogleFonts.inter()
        .copyWith(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        titleMedium: GoogleFonts.inter()
        .copyWith(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
        titleSmall: GoogleFonts.inter()
        .copyWith(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        labelSmall: GoogleFonts.inter()
        .copyWith(fontSize: 18, color: Colors.black),
        bodySmall: GoogleFonts.inter()
        .copyWith(fontSize: 14)
      ),
    );
  }
}

// inter, calbin, 
// poner menu, poner menu, imagenes con vectores
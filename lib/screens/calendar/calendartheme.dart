import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// create a theme class for different fonts used in calendar
class Themes{
  
}

TextStyle get dateheading {
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold
    )
  );
}

TextStyle get currentdayheading {
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold
    )
  );
}

TextStyle get maintitle {
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
    )
  );
}

TextStyle get subtitle {
  return GoogleFonts.lato (
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      //color: Colors.grey
    )
  );
}

import 'package:fiszki_projekt/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final appTheme = ThemeData(
    // style dla aplikacji ogólnie
    primaryColor: constMainColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 58,
        fontFamily: GoogleFonts.notoSans().fontFamily,
        fontWeight: FontWeight.bold,
      ),
    ),
    appBarTheme: AppBarTheme(
        // style dla appbar - tego paska na górze (dla każdego appbar w aplikacji)
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontSize: 20,
            color: Colors.white, // kolor tekstu w appbar
            fontWeight: FontWeight.bold),
        color: constMainColor),
    scaffoldBackgroundColor: constBackgroundColor,

    //theme dla podsumowania fiszek
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(constBorderRadiusElevatedButtons),
      ),
      backgroundColor: constMainColor,
      titleTextStyle: TextStyle(
          fontFamily: GoogleFonts.notoSans().fontFamily,
          fontSize: 20,
          color: Colors.white),
    ),
    //styl dla elevatedbutton
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(constBorderRadiusElevatedButtons),
              side: const BorderSide(color: Colors.white),
            ),
            backgroundColor: constBackgroundColor,
            textStyle: TextStyle(
              fontFamily: GoogleFonts.notoSans().fontFamily,
              color: Colors.white,
              fontSize: 15,
            ))),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: constMainColor,
      linearTrackColor: Colors.grey,
    ),
    //styl guzików w settings
    switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all<Color>(constMainColor)),
    listTileTheme: const ListTileThemeData(
      textColor: Colors.white,
      iconColor: Colors.white,
    ));

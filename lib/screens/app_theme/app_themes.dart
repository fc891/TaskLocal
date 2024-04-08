import 'package:flutter/material.dart';

ThemeData getAppTheme(BuildContext context, bool isDarkTheme) {
  return ThemeData(
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      colorScheme: Theme.of(context).colorScheme.copyWith(
        primary: isDarkTheme ? Colors.black : Colors.white,
        secondary: isDarkTheme ? Colors.white : Colors.white,
        tertiary: isDarkTheme ? Colors.grey[800] : Colors.green[800],),
      cardTheme: CardTheme(
          color: isDarkTheme ? Colors.grey[800] : Colors.green[800],
          surfaceTintColor: isDarkTheme ? Colors.white : Colors.white),
      scaffoldBackgroundColor: isDarkTheme ? Colors.black : Colors.green[500],
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: isDarkTheme ? Colors.white : Colors.white, //Controls text color generally (and in text)
            displayColor: isDarkTheme ? Colors.white : Colors.white,
          ),
      // textTheme: Theme.of(context)
      //     .textTheme
      //     .copyWith(
      //       titleSmall:
      //           Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
      //     )
      //     .apply(
      //       bodyColor: isDarkTheme ? Colors.white : Colors.black,
      //       displayColor: Colors.grey,
      //     ),
      switchTheme: SwitchThemeData(
        thumbColor:
            MaterialStateProperty.all(isDarkTheme ? Colors.orange : Colors.red),
      ),
      listTileTheme: ListTileThemeData(
          iconColor: isDarkTheme ? Colors.orange : Colors.red),
      appBarTheme: AppBarTheme(
          backgroundColor: isDarkTheme ? Colors.grey[800] : Colors.green[800],
          iconTheme:
              IconThemeData(color: isDarkTheme ? Colors.white : Colors.white),
          titleTextStyle: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.white,
              fontSize: 26.0)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkTheme ? Colors.grey[800] : Colors.white,
        unselectedLabelStyle: TextStyle(
          color: Colors.white
        ),
        selectedLabelStyle: TextStyle(
          color: Colors.white
        ),
        unselectedItemColor: isDarkTheme ? Colors.white : Colors.white,
        selectedItemColor: isDarkTheme ? Colors.grey : Colors.grey,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: isDarkTheme ? Colors.white : Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => (isDarkTheme ? Colors.white : Colors.white)),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) =>
              TextStyle(
                  color: isDarkTheme ? Colors.black : Colors.black,
                  fontSize: 16)),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDarkTheme ? Colors.white : Colors.black54,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDarkTheme ? Colors.grey[800] : Colors.green[800],
        labelStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.white,
          fontSize: 16,
        ),
        floatingLabelStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.white,
          fontSize: 16,
        ),
        helperStyle: TextStyle(
          color: isDarkTheme ? Colors.white : Colors.white,
          fontSize: 16,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) => (isDarkTheme ? Colors.white : Colors.green[500]!)),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) =>
              TextStyle(color: isDarkTheme ? Colors.black : Colors.black)),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.green[200],
      )
  );
}

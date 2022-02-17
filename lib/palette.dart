import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor myColor = MaterialColor(
    0xFF213C75, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFF213C75), //10%
      100: Color(0xFF213C75), //20%
      200: Color(0xFF213C75), //30%
      300: Color(0xFF213C75), //40%
      400: Color(0xFF213C75), //50%
      500: Color(0xFF213C75), //60%
      600: Color(0xFF213C75), //70%
      700: Color(0xFF213C75), //80%
      800: Color(0xFF213C75), //90%
      900: Color(0xFF213C75), //100%
    },
  );
}

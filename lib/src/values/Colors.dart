import 'dart:ui';

import 'package:flutter/material.dart';

class EColors{
  static final Color blackTransparent=Colors.black26;
  static final Color transparent=Colors.transparent;
  static final Color white=Colors.white;
  static final Color themeBlack=HexColor('#1a1d21');
  static final Color themeMaroon=HexColor('#1c141c');
  static final Color themeGrey=HexColor('#d1d2d3');
}


Color HexColor(String hexString) {
final buffer = StringBuffer();
if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
buffer.write(hexString.replaceFirst('#', ''));
return Color(int.parse(buffer.toString(), radix: 16));
}

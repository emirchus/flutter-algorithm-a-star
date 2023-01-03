import 'dart:math';

import 'package:flutter/material.dart';
import 'package:start_algorithm/application.dart';

void main() {
  runApp(const Application());
}

Color randomColorBySeed(int seed) {
  Random random = Random(seed);

  return Color.fromRGBO(random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
}

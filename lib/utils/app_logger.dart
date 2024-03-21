

import 'dart:math';

import 'package:logger/logger.dart';


class AppLogger{

  static Logger logger = Logger();

  static e(dynamic message){
    logger.e(message);
  }
}
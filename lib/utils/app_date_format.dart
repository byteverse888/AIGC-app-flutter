

import 'package:date_format/date_format.dart';

class AppDateFormat{

  static String getyyyymmddHHnnss(DateTime dateTime){
    return formatDate(dateTime, [yyyy, '-', mm, '-', dd,' ',HH, ':', nn, ':', ss]);
  }
}
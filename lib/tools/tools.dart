import 'package:intl/intl.dart';

class SetTime {
  static String setTime(String strDate) {
    var inputFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var inputDate = inputFormat.parse(strDate);
    var outputFormat = DateFormat("dd MMMM yyyy HH:mm:ss");
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }
}

class VariableGlobal {
  static double strLatitude = 0;
  static double strLongitude = 0;
  static String strAlamat = '';
}
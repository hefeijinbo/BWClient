
import 'package:flutter/cupertino.dart';

printLog(Object? object) {
  print(object);
}

const sortTypeRecommend = 200;
const sortTypeLatest = 300;
const defaultCursorType = "0";

const int currentYear = 2022;

class BWUtil {
  static getDescriptionWithTime(int time) {
    final epoch = DateTime.fromMicrosecondsSinceEpoch(time * 1000 * 1000);
    var hourStr = "";
    if (epoch.hour < 10) {
      hourStr = "0" + epoch.hour.toString();
    } else {
      hourStr = epoch.hour.toString();
    }
    var minuteStr = "";
    if (epoch.minute < 10) {
      minuteStr = "0" + epoch.minute.toString();
    } else {
      minuteStr = epoch.minute.toString();
    }
    if (epoch.year == currentYear) {
      return epoch.month.toString() + "月" + epoch.day.toString() + "日" + hourStr + ":" + minuteStr;
    } else {
      return epoch.year.toString() + "年" + epoch.month.toString() + "月" + epoch.day.toString() + "日" + hourStr + ":" + minuteStr;
    }
  }
}


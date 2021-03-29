/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

/// 日期时间格式化
class DateTimeUtils {
  const DateTimeUtils._();

  /// 转换
  static String convertDateTime(String dateTimeStr) {
    final structTime = DateTime.parse(dateTimeStr);
    final lastDayInMonth = DateTime(structTime.year, structTime.month + 1, 0).day;
    const minute = 60;
    const hour = 60 * minute;
    const day = 24 * hour;
    final month = lastDayInMonth * day;
    final year = 12 * month;
    final timestamp = (DateTime.now().millisecondsSinceEpoch - structTime.millisecondsSinceEpoch) ~/ 1000;
    if (timestamp > year) {
      return '${timestamp ~/ year}年前';
    }
    if (timestamp > month) {
      return '${timestamp ~/ month}月前';
    }
    if (timestamp > day) {
      return '${timestamp ~/ day}天前';
    }
    if (timestamp > hour) {
      return '${timestamp ~/ hour}小时前';
    }
    if (timestamp > minute) {
      return '${timestamp ~/ minute}分钟前';
    }
    return '刚刚';
  }
}

/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

/// Created by changlei on 2/20/21.
///
/// 打印日志
class Log {
  const Log._();

  /// 打印，只在debug模式
  static void normal(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fore: LogForeColors.normal);
  }

  /// 打印，只在debug模式
  static void v(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fore: LogForeColors.blue);
  }

  /// 打印，只在debug模式
  static void d(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fore: LogForeColors.blue);
  }

  /// 打印，只在debug模式
  static void i(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fore: LogForeColors.green);
  }

  /// 打印，只在debug模式
  static void w(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fore: LogForeColors.yellow);
  }

  /// 打印，只在debug模式
  static void e(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fore: LogForeColors.red);
  }

  /// 彩色打印
  static void colorPrint(
    Object? obj, {
    String? tag,
    LogForeColors fore = LogForeColors.normal,
    LogBackColors back = LogBackColors.normal,
    LogMode mode = LogMode.normal,
  }) {
    stdout.writeln(compositionColor(
      obj,
      tag: tag,
      fore: fore,
      back: back,
      mode: mode,
    ));
  }

  /// 叠加色彩
  static String compositionColor(
    Object? obj, {
    String? tag,
    LogForeColors fore = LogForeColors.normal,
    LogBackColors back = LogBackColors.normal,
    LogMode mode = LogMode.normal,
  }) {
    final contents = [
      '\x1B[$mode;$back;${fore}m',
      [if (tag != null) tag, obj?.toString()].join(': '),
      '\x1B[${LogForeColors.normal}m',
    ];
    return contents.join();
  }
}

/// color
class LogForeColors {
  const LogForeColors._(this.code);

  /// 颜色编码
  final int code;

  /// normal
  static const normal = LogForeColors._(0);

  /// foreBlack
  static const black = LogForeColors._(30);

  /// foreRed
  static const red = LogForeColors._(31);

  /// foreGreen
  static const green = LogForeColors._(32);

  /// foreYellow
  static const yellow = LogForeColors._(33);

  /// foreBlue
  static const blue = LogForeColors._(34);

  /// forePurple
  static const purple = LogForeColors._(35);

  /// foreCyan
  static const cyan = LogForeColors._(36);

  /// foreWhite
  static const white = LogForeColors._(37);

  @override
  String toString() {
    return code.toString();
  }
}

/// color
class LogBackColors {
  const LogBackColors._(this.code);

  /// 颜色编码
  final int code;

  /// normal
  static const normal = LogBackColors._(0);

  /// backBlack
  static const black = LogBackColors._(40);

  /// backRed
  static const red = LogBackColors._(41);

  /// backGreen
  static const green = LogBackColors._(42);

  /// backYellow
  static const yellow = LogBackColors._(43);

  /// backBlue
  static const blue = LogBackColors._(44);

  /// backPurple
  static const purple = LogBackColors._(45);

  /// backCyan
  static const cyan = LogBackColors._(46);

  /// backWhite
  static const white = LogBackColors._(47);

  @override
  String toString() {
    return code.toString();
  }
}

/// log mode
class LogMode {
  const LogMode._(this.code);

  /// code
  final int code;

  /// normal
  static const normal = LogMode._(0);

  /// bold
  static const bold = LogMode._(1);

  /// underline
  static const underline = LogMode._(4);

  /// blink
  static const blink = LogMode._(5);

  /// invert
  static const invert = LogMode._(7);

  @override
  String toString() {
    return code.toString();
  }
}

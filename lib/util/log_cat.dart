/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

const _ansiEsc = '\x1B[';

/// Created by changlei on 2/20/21.
///
/// 打印日志
class Log {
  const Log._();

  /// 打印，只在debug模式
  static void normal(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fgColor: AnsiFgColors.normal);
  }

  /// 打印，只在debug模式
  static void v(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fgColor: AnsiFgColors.blue);
  }

  /// 打印，只在debug模式
  static void d(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fgColor: AnsiFgColors.blue);
  }

  /// 打印，只在debug模式
  static void i(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fgColor: AnsiFgColors.green);
  }

  /// 打印，只在debug模式
  static void w(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fgColor: AnsiFgColors.yellow);
  }

  /// 打印，只在debug模式
  static void e(Object? obj, {String? tag}) {
    colorPrint(obj, tag: tag, fgColor: AnsiFgColors.red);
  }

  /// 彩色打印
  static void colorPrint(
    Object? obj, {
    String? tag,
    AnsiFgColors fgColor = AnsiFgColors.normal,
    AnsiBgColors bgColor = AnsiBgColors.normal,
    AnsiMode mode = AnsiMode.normal,
  }) {
    stdout.writeln(appendColor(
      obj,
      tag: tag,
      fgColor: fgColor,
      bgColor: bgColor,
      mode: mode,
    ));
  }

  /// 叠加色彩
  static String appendColor(
    Object? obj, {
    String? tag,
    AnsiFgColors fgColor = AnsiFgColors.normal,
    AnsiBgColors bgColor = AnsiBgColors.normal,
    AnsiMode mode = AnsiMode.normal,
  }) {
    final contents = [
      '$_ansiEsc$mode;$bgColor;${fgColor}m',
      [if (tag != null) tag, obj?.toString()].join(': '),
      '$_ansiEsc${AnsiFgColors.normal}m',
    ];
    return contents.join();
  }
}

/// color
class AnsiFgColors {
  const AnsiFgColors._(this.code);

  /// 颜色编码
  final int code;

  /// normal
  static const normal = AnsiFgColors._(0);

  /// foreBlack
  static const black = AnsiFgColors._(30);

  /// foreRed
  static const red = AnsiFgColors._(31);

  /// foreGreen
  static const green = AnsiFgColors._(32);

  /// foreYellow
  static const yellow = AnsiFgColors._(33);

  /// foreBlue
  static const blue = AnsiFgColors._(34);

  /// forePurple
  static const purple = AnsiFgColors._(35);

  /// foreCyan
  static const cyan = AnsiFgColors._(36);

  /// foreWhite
  static const white = AnsiFgColors._(37);

  @override
  String toString() {
    return code.toString();
  }
}

/// color
class AnsiBgColors {
  const AnsiBgColors._(this.code);

  /// 颜色编码
  final int code;

  /// normal
  static const normal = AnsiBgColors._(0);

  /// backBlack
  static const black = AnsiBgColors._(40);

  /// backRed
  static const red = AnsiBgColors._(41);

  /// backGreen
  static const green = AnsiBgColors._(42);

  /// backYellow
  static const yellow = AnsiBgColors._(43);

  /// backBlue
  static const blue = AnsiBgColors._(44);

  /// backPurple
  static const purple = AnsiBgColors._(45);

  /// backCyan
  static const cyan = AnsiBgColors._(46);

  /// backWhite
  static const white = AnsiBgColors._(47);

  @override
  String toString() {
    return code.toString();
  }
}

/// log mode
class AnsiMode {
  const AnsiMode._(this.code);

  /// code
  final int code;

  /// normal
  static const normal = AnsiMode._(0);

  /// bold
  static const bold = AnsiMode._(1);

  /// underline
  static const underline = AnsiMode._(4);

  /// blink
  static const blink = AnsiMode._(5);

  /// invert
  static const invert = AnsiMode._(7);

  @override
  String toString() {
    return code.toString();
  }
}

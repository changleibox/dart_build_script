/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/util/log_cat.dart';

/// std工具
class StdProgress {
  const StdProgress._();

  /// 打印进度
  static void writeProgress(int count, int total, [String? prefix, String? suffix]) {
    final formattedProgress = ('=' * (count * 100 ~/ total)).padRight(100);
    stdout.write(
      Log.compositionColor(
        '\r${prefix ?? ''}[$formattedProgress]${suffix ?? ''}',
        fore: LogForeColors.blue,
      ),
    );
    if (count >= total) {
      stdout.writeln();
    }
  }
}

/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

/// std工具
class StdProgress {
  const StdProgress._();

  /// 打印进度
  static void writeProgress(int count, int total, [String? prefix, String? suffix]) {
    final formattedProgress = ('=' * (count * 100 ~/ total)).padRight(100);
    stdout.write(
      '\r${prefix ?? ''}[$formattedProgress]${suffix ?? ''}',
    );
    if (count >= total) {
      stdout.writeln();
    }
  }
}

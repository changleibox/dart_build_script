/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/util/file_utils.dart';

/// std工具
class StdProgress {
  const StdProgress._();

  /// 打印进度
  static void writeProgress(int count, int total, [String? prefix]) {
    final countStr = FileUtils.convertFukeSize(count).replaceAll(' ', '').replaceAll('Byte', 'B');
    final totalStr = FileUtils.convertFukeSize(total).replaceAll(' ', '').replaceAll('Byte', 'B');
    final percent = count * 100 / total;
    final formattedPercent = '${percent.toStringAsFixed(2)}%';
    final formattedProgress = ('=' * percent.toInt()).padRight(100);
    prefix ??= '';
    stdout.write(
      '\r$prefix($formattedPercent)：[$formattedProgress] $countStr/$totalStr',
    );
  }
}

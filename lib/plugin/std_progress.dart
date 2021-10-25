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
    stdout.write('\r${prefix ?? ''}(${count * 100 / total}%)：[${('=' * count).padRight(100)}] $countStr/$totalStr');
    stdout.flush();
  }
}

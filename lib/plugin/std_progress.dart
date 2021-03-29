/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import '../util/file_utils.dart';

/// std工具
class StdProgress {
  /// 写到终端
  static void write(int count, int total) {
    final countStr = FileUtils.convertFukeSize(count);
    final totalStr = FileUtils.convertFukeSize(total);
    stdout.writeln('正在上传：$countStr/$totalStr');
  }
}

import 'dart:io';

import '../util/file_utils.dart';

class StdProgress {
  static write(int count, int total) {
    var countStr = FileUtils.convertFukeSize(count);
    var totalStr = FileUtils.convertFukeSize(total);
    stdout.writeln('正在上传：$countStr/$totalStr');
  }
}

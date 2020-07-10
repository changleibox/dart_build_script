import 'dart:io';

import 'package:path/path.dart';

class FileUtils {
  static Future<void> replace(
    Iterable<String> paths,
    String old, {
    String replace,
  }) async {
    assert(paths != null && paths.isNotEmpty);
    assert(old != null);
    for (var filePath in paths) {
      var file = File(filePath);
      var content = await file.readAsString();
      if (content.contains(old)) {
        content = content.replaceAll(old, replace ?? '');
        await file.writeAsString(content, flush: true);
      }
    }
  }

  static String convertFukeSize(int size) {
    if (size == null) {
      return '0 Byte';
    }

    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;
    const tb = gb * 1024;

    if (size >= tb) {
      return '${(size / tb).toStringAsFixed(2)} TB';
    }
    if (size >= gb) return '${(size / gb).toStringAsFixed(2)} GB';
    if (size >= mb) return '${(size / mb).toStringAsFixed(2)} MB';
    if (size >= kb) return '${(size / kb).toStringAsFixed(2)} KB';
    return '$size Byte';
  }

  static Future<String> copy(String sourcePath, String targetPath) async {
    if (FileSystemEntity.isFileSync(sourcePath)) {
      if (FileSystemEntity.isDirectorySync(targetPath)) {
        var directory = Directory(targetPath);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        targetPath = join(targetPath, basename(sourcePath));
      }
      var newFile = File(sourcePath).copySync(targetPath);
      return newFile.path;
    } else {
      var targetDir = Directory(targetPath);
      if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
      }
      var sourceDir = Directory(sourcePath);
      var exportDir = Directory(join(targetPath, basename(sourceDir.path)));
      if (exportDir.existsSync()) {
        exportDir.deleteSync(recursive: true);
      }
      exportDir.createSync(recursive: true);
      var fileSystemEntities = sourceDir.listSync(recursive: false);
      for (var fileSystemEntity in fileSystemEntities) {
        var filePath = fileSystemEntity.path;
        copy(filePath, exportDir.path);
      }
      return exportDir.path;
    }
  }
}

/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:path/path.dart';

/// 文件工具
class FileUtils {
  const FileUtils._();

  /// 替换文件内容
  static Future<void> replace(
    Iterable<String> paths,
    String old, {
    String? replace,
  }) async {
    assert(paths.isNotEmpty);
    for (var filePath in paths) {
      final file = File(filePath);
      if (!file.existsSync()) {
        continue;
      }
      var content = await file.readAsString();
      if (content.contains(old)) {
        content = content.replaceAll(old, replace ?? '');
        await file.writeAsString(content, flush: true);
      }
    }
  }

  /// 获取格式化的文件大小
  static String convertFukeSize(int? size) {
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
    if (size >= gb) {
      return '${(size / gb).toStringAsFixed(2)} GB';
    }
    if (size >= mb) {
      return '${(size / mb).toStringAsFixed(2)} MB';
    }
    if (size >= kb) {
      return '${(size / kb).toStringAsFixed(2)} KB';
    }
    return '${size.toStringAsFixed(2)} Byte';
  }

  /// 复制文件
  static Future<String> copy(String sourcePath, String targetPath) async {
    if (FileSystemEntity.isFileSync(sourcePath)) {
      if (FileSystemEntity.isDirectorySync(targetPath)) {
        final directory = Directory(targetPath);
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        targetPath = join(targetPath, basename(sourcePath));
      }
      final newFile = File(sourcePath).copySync(targetPath);
      return newFile.path;
    } else {
      final targetDir = Directory(targetPath);
      if (!targetDir.existsSync()) {
        targetDir.createSync(recursive: true);
      }
      final sourceDir = Directory(sourcePath);
      final exportDir = Directory(join(targetPath, basename(sourceDir.path)));
      if (exportDir.existsSync()) {
        exportDir.deleteSync(recursive: true);
      }
      exportDir.createSync(recursive: true);
      final fileSystemEntities = sourceDir.listSync(recursive: false);
      for (var fileSystemEntity in fileSystemEntities) {
        final filePath = fileSystemEntity.path;
        await copy(filePath, exportDir.path);
      }
      return exportDir.path;
    }
  }
}

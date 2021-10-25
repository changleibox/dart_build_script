/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/common/paths.dart';
import 'package:path/path.dart' as path;

const _debugUrl = r'http://8.136.190.38:8000';
const _releaseUrl = r'api.graspishop.com';
const _indent = '  ';

/// Created by changlei on 2021/10/25.
///
/// 替换[.temp/sources/Runner/lib/system/build_config.dart]
class Replacer {
  const Replacer._();

  /// 执行替换
  ///
  /// [filePath]相对[rootPath]路径
  static void debugBuildConfig(String filePath) {
    replace(filePath, <String, String>{
      '^$_indent\/\/.*?$_debugUrl.*,': _indent + r"baseUrl: 'http://8.136.190.38:8000/v$_version',",
      '^$_indent[^\/\/].*?$_releaseUrl.*,': _indent + r"// baseUrl: 'https://v${_version}api.graspishop.com/',",
    });
  }

  /// 执行替换
  ///
  /// [filePath]相对[rootPath]路径
  static void releaseBuildConfig(String filePath) {
    replace(filePath, <String, String>{
      '^$_indent[^\/\/].*?$_debugUrl.*,': _indent + r"// baseUrl: 'http://8.136.190.38:8000/v$_version',",
      '^$_indent\/\/.*?$_releaseUrl.*,': _indent + r"baseUrl: 'https://v${_version}api.graspishop.com/',",
    });
  }

  /// 执行替换
  ///
  /// [filePath]相对[rootPath]路径
  static void replace(String filePath, Map<String, String> replaceContents) {
    final buildConfig = File(path.join(rootPath, filePath));
    final lines = List.of(buildConfig.readAsLinesSync());
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (var key in replaceContents.keys) {
        if (RegExp(key).hasMatch(line)) {
          lines[i] = replaceContents[key]!;
        }
      }
    }
    buildConfig.writeAsStringSync(lines.join('\n'), flush: true);
  }
}

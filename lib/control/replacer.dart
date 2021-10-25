/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/common/paths.dart';
import 'package:dart_build_script/enums/build_type.dart';
import 'package:dart_build_script/enums/export_type.dart';
import 'package:path/path.dart' as path;

const _debugUrl = r'http://8.136.190.38:8000';
const _releaseUrl = r'api.graspishop.com';
const _indent = '  ';

/// Created by changlei on 2021/10/25.
///
/// 替换[.temp/sources/Runner/lib/system/build_config.dart]
class Replacer {
  /// 替换[.temp/sources/Runner/lib/system/build_config.dart]
  const Replacer(this.buildType, this.exportType);

  /// 构建类型
  final BuildType buildType;

  /// 导出类型
  final ExportType exportType;

  /// 执行替换
  Future<void> replace() async {
    switch (exportType) {
      case ExportType.export:
      case ExportType.dandelion:
        _debugBuildConfig(buildConfigPath);
        break;
      case ExportType.appStore:
        _releaseBuildConfig(buildConfigPath);
        break;
    }
  }

  /// 把正式地址换成调试地址
  ///
  /// [filePath]相对[rootPath]路径
  static void _debugBuildConfig(String filePath) {
    _replace(filePath, <String, String>{
      '^$_indent\/\/.*?$_debugUrl.*,': _indent + r"baseUrl: 'http://8.136.190.38:8000/v$_version',",
      '^$_indent[^\/\/].*?$_releaseUrl.*,': _indent + r"// baseUrl: 'https://v${_version}api.graspishop.com/',",
    });
  }

  /// 把调试地址换成正式地址
  ///
  /// [filePath]相对[rootPath]路径
  static void _releaseBuildConfig(String filePath) {
    _replace(filePath, <String, String>{
      '^$_indent[^\/\/].*?$_debugUrl.*,': _indent + r"// baseUrl: 'http://8.136.190.38:8000/v$_version',",
      '^$_indent\/\/.*?$_releaseUrl.*,': _indent + r"baseUrl: 'https://v${_version}api.graspishop.com/',",
    });
  }

  /// 执行替换
  ///
  /// [filePath]相对[rootPath]路径
  static void _replace(String filePath, Map<String, String?> replaceContents) {
    final buildConfig = File(path.join(rootPath, filePath));
    final lines = List<String?>.of(buildConfig.readAsLinesSync());
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (var key in replaceContents.keys) {
        if (line != null && RegExp(key).hasMatch(line)) {
          lines[i] = replaceContents[key];
        }
      }
    }
    final contents = lines.where((element) => element?.isNotEmpty == true).join('\n');
    buildConfig.writeAsStringSync(contents, flush: true);
  }
}

/// android替换
class ApkReplacer extends Replacer {
  /// android替换
  const ApkReplacer({
    required BuildType buildType,
    required ExportType exportType,
  }) : super(buildType, exportType);

  static const String _indent = '            ';

  @override
  Future<void> replace() async {
    await super.replace();
    Replacer._replace(infoPlistPath, <String, String?>{
      _indent + r'android\:name\=\"\.MainActivity\"': <String>[
        _indent + r'android:name=".MainActivity"',
        _indent + r'android:screenOrientation="landscape"',
      ].join('\n'),
    });
  }
}

/// iOS替换
class IOSReplacer extends Replacer {
  /// iOS替换
  const IOSReplacer({
    required BuildType buildType,
    required ExportType exportType,
  }) : super(buildType, exportType);

  static const String _indent = '		';

  @override
  Future<void> replace() async {
    await super.replace();
    Replacer._replace(infoPlistPath, <String, String?>{
      _indent + r'\<string\>UIInterfaceOrientationPortrait\<\/string\>': null,
    });
  }
}

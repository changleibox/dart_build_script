/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/process/xcrun_process.dart';

/// 发布器
abstract class Publisher {
  /// 构造函数
  const Publisher();

  /// 发布
  Future<ProcessResult?> publish(File file);
}

/// apk发布器
class ApkPublisher extends Publisher {
  @override
  Future<ProcessResult?> publish(File file) async {
    stdout.writeln('暂不支持apk的发布');
    return null;
  }
}

/// iOS发布器
class IOSPublisher extends Publisher {
  /// 构造函数
  const IOSPublisher(this.config) : process = const XcrunProcess();

  /// appStore配置
  final AppStoreConfig config;

  /// xcrun命令行工具
  final XcrunProcess process;

  @override
  Future<ProcessResult> publish(File file) async {
    var result = await process.validateApp(
      file.path,
      config.type!,
      config.apiKey!,
      config.apiIssuer!,
      config.outputFormat!,
    );
    if (result.exitCode == 0) {
      result = await process.uploadApp(
        file.path,
        config.type!,
        config.apiKey!,
        config.apiIssuer!,
        config.outputFormat!,
      );
    }
    return result;
  }
}

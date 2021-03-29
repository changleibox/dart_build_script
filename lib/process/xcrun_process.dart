/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'process.dart';

/// xcrun命令行
class XcrunProcess extends IProcess {
  /// 构造函数
  const XcrunProcess() : super();

  /// xcrun altool --validate-app
  Future<ProcessResult> validateApp(
    String appPath,
    String type,
    String apiKey,
    String apiIssuer,
    String outputFormat,
  ) {
    return run('xcrun', [
      'altool',
      '--validate-app',
      '-f',
      appPath,
      '-t',
      type,
      '-apiKey',
      apiKey,
      '-apiIssuer',
      apiIssuer,
      '--output-format',
      outputFormat,
    ]);
  }

  /// xcrun altool --upload-app
  Future<ProcessResult> uploadApp(
    String appPath,
    String type,
    String apiKey,
    String apiIssuer,
    String outputFormat,
  ) {
    return run('xcrun', [
      'altool',
      '--upload-app',
      '-f',
      appPath,
      '-t',
      type,
      '-apiKey',
      apiKey,
      '-apiIssuer',
      apiIssuer,
      '--output-format',
      outputFormat,
    ]);
  }
}

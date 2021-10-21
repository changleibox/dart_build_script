/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/common/paths.dart';
import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/process/git_process.dart';

/// git工具
class Gitter {
  /// 构造函数
  Gitter(this.config) : gitProcess = GitProcess(rootPath);

  /// git命令行工具
  final GitProcess gitProcess;

  /// git配置
  final GitConfig config;

  /// git pull
  Future<ProcessResult?> pull() async {
    var result = await gitProcess.init();
    if (result.exitCode == 0) {
      final rootDir = Directory(rootPath);
      if (rootDir.existsSync() && !File(yamlPath).existsSync()) {
        rootDir.deleteSync(recursive: true);
      }
      if (!rootDir.existsSync()) {
        result = await gitProcess.clone(config.branch!, config.remote!);
      }
    }
    // if (result.exitCode == 0) {
    //   result = await gitProcess.status();
    // }
    // if (result.exitCode == 0) {
    //   result = await gitProcess.log();
    // }
    if (result.exitCode == 0) {
      result = await gitProcess.fetch();
    }
    if (result.exitCode == 0) {
      result = await gitProcess.reset(config.branch!);
    }
    if (result.exitCode == 0) {
      result = await gitProcess.checkout(config.branch!);
    }
    if (result.exitCode == 0) {
      result = await gitProcess.pull();
    }
    assert(result.exitCode == 0, '代码拉取失败，请稍后尝试');
    return result;
  }
}

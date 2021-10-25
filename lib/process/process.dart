/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:async';
import 'dart:io';

import 'package:dart_build_script/common/paths.dart';

/// 命令行工具
abstract class IProcess {
  /// 构造函数
  const IProcess();

  /// 运行在当前目录
  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    final process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode,
    );
    stderr.writeln(['->', executable, ...arguments].join(' '));
    final stdoutBuffer = StringBuffer();
    process.stdout.transform(systemEncoding.decoder).listen((event) {
      stdout.write(event);
      stdoutBuffer.write(event);
    });
    final stderrBuffer = StringBuffer();
    process.stderr.transform(systemEncoding.decoder).listen((event) {
      stderr.write(event);
      stderrBuffer.write(event);
    });
    final exitCode = await process.exitCode;
    return ProcessResult(process.pid, exitCode, stdoutBuffer.toString(), stderrBuffer.toString());
  }

  /// 运行在根目录
  Future<ProcessResult> runAsRoot(
    String executable,
    List<String> arguments,
  ) {
    return run(executable, arguments, workingDirectory: rootPath);
  }

  /// 运行在ios目录
  Future<ProcessResult> runAsIOS(
    String executable,
    List<String> arguments,
  ) {
    return run(executable, arguments, workingDirectory: iosPath);
  }
}

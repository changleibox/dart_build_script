/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'process.dart';

/// git命令行工具
class GitProcess extends IProcess {
  /// 构造函数
  const GitProcess(this.workingDirectory) : super();

  /// git目标文件夹
  final String workingDirectory;

  /// git --global credential.helper store
  Future<ProcessResult> credentialHelper() {
    return run('git', ['config', '--global', 'credential.helper', 'store']);
  }

  /// git config --global user.name xxx
  /// git config --global user.password xxx
  /// git config --global user.email xxx
  Future<ProcessResult> configUser(String username, String password, {String? email}) async {
    var result = await run('git', ['config', '--global', 'user.name', username]);
    if (result.exitCode == 0) {
      result = await run('git', ['config', '--global', 'user.password', password]);
    }
    if (result.exitCode == 0 && email != null) {
      result = await run('git', ['config', '--global', 'user.email', email]);
    }
    return result;
  }

  /// git init
  Future<ProcessResult> init() {
    return run('git', ['init', workingDirectory]);
  }

  /// git clone
  Future<ProcessResult> clone(String branch, String remote) {
    return run('git', ['clone', '-b', branch, remote, workingDirectory]);
  }

  /// git status
  Future<ProcessResult> status() {
    return runAsIOS('git', ['status']);
  }

  /// git log
  Future<ProcessResult> log({bool stat = true}) {
    return runAsIOS('git', ['log', if (stat) '--stat']);
  }

  /// git fetch
  Future<ProcessResult> fetch({bool all = true}) {
    return runAsIOS('git', ['fetch', if (all) '--all']);
  }

  /// git reset --hard origin/[branch]
  Future<ProcessResult> reset(String branch) {
    return runAsIOS('git', ['reset', '--hard', 'origin/$branch']);
  }

  /// git checkout [branch]
  Future<ProcessResult> checkout(String branch) {
    return runAsIOS('git', ['checkout', branch]);
  }

  /// git pull
  Future<ProcessResult> pull() {
    return runAsIOS('git', ['pull']);
  }

  @override
  Future<ProcessResult> runAsIOS(
    String executable,
    List<String> arguments,
  ) {
    return run(executable, arguments, workingDirectory: workingDirectory);
  }
}

import 'dart:io';

import 'process.dart';

class GitProcess extends IProcess {
  final String workingDirectory;

  const GitProcess(this.workingDirectory) : super();

  Future<ProcessResult> credentialHelper() {
    return run('git', ['config', '--global', 'credential.helper', 'store']);
  }

  Future<ProcessResult> configUser(String username, String password, {String email}) async {
    var result = await run('git', ['config', '--global', 'user.name', username]);
    if (result.exitCode == 0) {
      result = await run('git', ['config', '--global', 'user.password', password]);
    }
    if (result.exitCode == 0 && email != null) {
      result = await run('git', ['config', '--global', 'user.email', email]);
    }
    return result;
  }

  Future<ProcessResult> init() {
    return run('git', ['init', workingDirectory]);
  }

  Future<ProcessResult> clone(String branch, String remote) {
    return run('git', ['clone', '-b', branch, remote, workingDirectory]);
  }

  Future<ProcessResult> status() {
    return runAsIOS('git', ['status']);
  }

  Future<ProcessResult> log({bool stat = true}) {
    return runAsIOS('git', ['log', if (stat) '--stat']);
  }

  Future<ProcessResult> fetch({bool all = true}) {
    return runAsIOS('git', ['fetch', if (all) '--all']);
  }

  Future<ProcessResult> reset(String branch) {
    return runAsIOS('git', ['reset', '--hard', 'origin/$branch']);
  }

  Future<ProcessResult> checkout(String branch) {
    return runAsIOS('git', ['checkout', branch]);
  }

  Future<ProcessResult> pull() {
    return runAsIOS('git', ['pull']);
  }

  Future<ProcessResult> runAsIOS(
    String executable,
    List<String> arguments,
  ) {
    return run(executable, arguments, workingDirectory: workingDirectory);
  }
}

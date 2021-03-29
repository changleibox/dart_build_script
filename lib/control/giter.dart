import 'dart:io';

import '../common/paths.dart';
import '../config/configs.dart';
import '../process/git_process.dart';

class Giter {
  final GitProcess gitProcess;
  final GitConfig? config;

  Giter(this.config)
      : assert(config != null),
        this.gitProcess = GitProcess(rootPath);

  Future<ProcessResult?> pull() async {
    if (config != null) {
      var result = await gitProcess.init();
      if (result.exitCode == 0) {
        var rootDir = Directory(rootPath);
        if (rootDir.existsSync() && !File(yamlPath).existsSync()) {
          rootDir.deleteSync(recursive: true);
        }
        if (!rootDir.existsSync()) {
          result = await gitProcess.clone(config!.branch!, config!.remote!);
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
        result = await gitProcess.reset(config!.branch!);
      }
      if (result.exitCode == 0) {
        result = await gitProcess.checkout(config!.branch!);
      }
      if (result.exitCode == 0) {
        result = await gitProcess.pull();
      }
      assert(result.exitCode == 0, '代码拉取失败，请稍后尝试');
      return result;
    }
    return null;
  }
}

import 'dart:async';
import 'dart:io';

import '../common/paths.dart';

abstract class IProcess {
  const IProcess();

  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String workingDirectory,
    Map<String, String> environment,
    bool includeParentEnvironment = true,
    bool runInShell = false,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    var process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      includeParentEnvironment: includeParentEnvironment,
      runInShell: runInShell,
      mode: mode,
    );
    var stdoutBuffer = StringBuffer();
    process.stdout.transform(systemEncoding.decoder).listen((event) {
      stdout.write(event);
      stdoutBuffer.write(event);
    });
    var stderrBuffer = StringBuffer();
    process.stderr.transform(systemEncoding.decoder).listen((event) {
      stderr.write(event);
      stderrBuffer.write(event);
    });
    var exitCode = await process.exitCode;
    return ProcessResult(process.pid, exitCode, stdoutBuffer.toString(), stderrBuffer.toString());
  }

  Future<ProcessResult> runAsRoot(
    String executable,
    List<String> arguments,
  ) {
    return run(executable, arguments, workingDirectory: rootPath);
  }

  Future<ProcessResult> runAsIOS(
    String executable,
    List<String> arguments,
  ) {
    return run(executable, arguments, workingDirectory: iosPath);
  }
}

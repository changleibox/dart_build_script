import 'dart:io';

import 'process.dart';

class XcrunProcess extends IProcess {
  const XcrunProcess() : super();

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

  Future<ProcessResult> uploadApp(
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
}

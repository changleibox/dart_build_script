import 'dart:io';

import '../util/string_utils.dart';
import 'process.dart';

class XcodebuildProcess extends IProcess {
  const XcodebuildProcess() : super();

  Future<ProcessResult> podInstall() {
    return runAsIOS('pod', ['install']);
  }

  Future<ProcessResult> clean(
    String workspacePath,
    String targetName, {
    String buildType = 'debug',
  }) {
    return runAsIOS('xcodebuild', [
      'clean',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
      '-configuration',
      capitalize(buildType),
    ]);
  }

  Future<ProcessResult> archive(
    String workspacePath,
    String targetName,
    String archivePath, {
    String buildType = 'debug',
  }) {
    return runAsIOS('xcodebuild', [
      'archive',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
      '-configuration',
      capitalize(buildType),
      '-archivePath',
      archivePath,
    ]);
  }

  Future<ProcessResult> exportArchive(
    String archivePath,
    String exportPath,
    String exportOptionsPlist,
  ) {
    return runAsIOS('xcodebuild', [
      '-exportArchive',
      '-archivePath',
      archivePath,
      '-exportPath',
      exportPath,
      '-exportOptionsPlist',
      exportOptionsPlist,
    ]);
  }
}

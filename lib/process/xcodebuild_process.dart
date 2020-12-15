import 'dart:io';

import '../util/string_utils.dart';
import 'process.dart';

class XcodebuildProcess extends IProcess {
  const XcodebuildProcess() : super();

  Future<ProcessResult> podUpdate({String libraryName}) {
    var arguments = <String>[];
    arguments.add('update');
    if (libraryName != null) {
      arguments.add(libraryName);
    }
    return runAsIOS('pod', arguments);
  }

  Future<ProcessResult> podInstall({bool verbose, bool repoUpdate}) {
    var arguments = <String>[];
    arguments.add('install');
    if (verbose == true) {
      arguments.add('--verbose');
    }
    if (repoUpdate != null) {
      arguments.add(repoUpdate ? '--repo-update' : '--no-repo-update');
    }
    return runAsIOS('pod', arguments);
  }

  Future<ProcessResult> clean(
    String workspacePath,
    String targetName, {
    String buildType = 'debug',
  }) {
    assert(buildType != null);
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
    assert(buildType != null);
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

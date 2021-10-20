/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import '../util/string_utils.dart';
import 'process.dart';

/// xcodebuild命令行
class XcodebuildProcess extends IProcess {
  /// 构造函数
  const XcodebuildProcess() : super();

  /// pod update
  Future<ProcessResult> podUpdate({String? libraryName}) {
    final arguments = <String>[];
    arguments.add('update');
    if (libraryName != null) {
      arguments.add(libraryName);
    }
    return runAsIOS('pod', arguments);
  }

  /// pod install
  Future<ProcessResult> podInstall({bool? verbose, bool? repoUpdate}) {
    final arguments = <String>[];
    arguments.add('install');
    if (verbose == true) {
      arguments.add('--verbose');
    }
    if (repoUpdate != null) {
      arguments.add(repoUpdate ? '--repo-update' : '--no-repo-update');
    }
    return runAsIOS('pod', arguments);
  }

  /// xcodebuild clean
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
      capitalize(buildType)!,
      '-sdk',
      _sdk(buildType),
    ]);
  }

  /// xcodebuild build
  Future<ProcessResult> build(
    String workspacePath,
    String targetName, {
    String buildType = 'debug',
  }) {
    return runAsIOS('xcodebuild', [
      'build',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
      '-configuration',
      capitalize(buildType)!,
      '-sdk',
      _sdk(buildType),
    ]);
  }

  /// xcodebuild archive
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
      capitalize(buildType)!,
      '-sdk',
      _sdk(buildType),
      '-archivePath',
      archivePath,
    ]);
  }

  /// xcodebuild export archive
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

  String _sdk(String buildType) {
    return buildType.toLowerCase() == 'debug' ? 'iphonesimulator' : 'iphoneos';
  }
}

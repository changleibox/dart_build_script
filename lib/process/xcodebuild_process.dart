/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/enums/build_type.dart';
import 'package:dart_build_script/process/process.dart';

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

  /// xcodebuild list
  Future<ProcessResult> list(
    String workspacePath,
    String targetName,
  ) {
    return runAsIOS('xcodebuild', [
      '-list',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
    ]);
  }

  /// xcodebuild clean
  Future<ProcessResult> clean(
    String workspacePath,
    String targetName, {
    BuildType buildType = BuildType.debug,
  }) {
    return runAsIOS('xcodebuild', [
      'clean',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
      '-configuration',
      buildType.configuration,
    ]);
  }

  /// xcodebuild build
  Future<ProcessResult> build(
    String workspacePath,
    String targetName, {
    BuildType buildType = BuildType.debug,
  }) {
    return runAsIOS('xcodebuild', [
      'build',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
      '-configuration',
      buildType.configuration,
      '-sdk',
      _sdk(buildType),
    ]);
  }

  /// xcodebuild archive
  Future<ProcessResult> archive(
    String workspacePath,
    String targetName,
    String archivePath, {
    BuildType buildType = BuildType.debug,
  }) {
    return runAsIOS('xcodebuild', [
      'archive',
      '-workspace',
      workspacePath,
      '-scheme',
      targetName,
      '-configuration',
      buildType.configuration,
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

  String _sdk(BuildType buildType) {
    return buildType.isDebug ? 'iphonesimulator' : 'iphoneos';
  }
}

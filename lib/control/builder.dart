/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:path/path.dart' as path;

import '../common/paths.dart';
import '../config/configs.dart';
import '../enums/build_platform.dart';
import '../process/flutter_process.dart';
import '../process/xcodebuild_process.dart';

/// 构建类
abstract class Builder {
  /// 构造函数
  const Builder(this.platform, {FlutterProcess? flutterProcess})
      : flutterProcess = flutterProcess ?? const FlutterProcess();

  /// 平台
  final String platform;

  /// flutter命令行工具
  final FlutterProcess flutterProcess;

  /// flutter clean
  Future<ProcessResult> clean() {
    return flutterProcess.clean();
  }

  /// flutter pub get
  Future<ProcessResult> pubGet() {
    return flutterProcess.pubGet();
  }

  /// flutter pub upgrade
  Future<ProcessResult> pubUpgrade() {
    return flutterProcess.pubUpgrade();
  }

  /// flutter pub run build_runner build
  Future<ProcessResult> runBuildRunner() {
    return flutterProcess.runBuildRunner();
  }

  /// 以[buildType]构建一个发布包
  ///
  /// 返回发布包的路径
  Future<File?> build();

  /// 开始构建
  Future<File?> startBuild() async {
    var result = await clean();
    if (result.exitCode == 0) {
      result = await pubUpgrade();
    }
    if (result.exitCode == 0) {
      result = await pubGet();
    }
    if (result.exitCode == 0) {
      result = await runBuildRunner();
    }
    File? file;
    if (result.exitCode == 0) {
      file = await build();
    }
    assert(file != null && file.existsSync());
    return file;
  }
}

/// 构建apk
class ApkBuilder extends Builder {
  /// 构造函数
  const ApkBuilder(String name, this.buildConfig) : super(name, flutterProcess: const ApkFlutterProcess());

  /// 构建apk配置
  final ApkBuildConfig buildConfig;

  @override
  Future<File?> build() async {
    final buildType = buildConfig.buildType;
    assert(buildType != null, '请配置buildType');
    final result = await flutterProcess.build(
      BuildPlatform.apk,
      buildType: buildType!,
      treeShakeIcons: buildConfig.treeShakeIcons,
      target: buildConfig.target,
      flavor: buildConfig.flavor,
      pub: buildConfig.pub,
      buildName: buildConfig.buildName,
      buildNumber: buildConfig.buildNumber,
      splitDebugInfo: buildConfig.splitDebugInfo,
      obfuscate: buildConfig.obfuscate,
      dartDefine: buildConfig.dartDefine,
      performanceMeasurementFile: buildConfig.performanceMeasurementFile,
      shrink: buildConfig.shrink,
      targetPlatform: buildConfig.targetPlatform,
      splitPerAbi: buildConfig.splitPerAbi,
      trackWidgetCreation: buildConfig.trackWidgetCreation,
    );
    final apkFile = File(path.join(apkExportPath, 'app-$buildType.apk'));
    if (result.exitCode == 0 && apkFile.existsSync()) {
      return apkFile;
    }
    assert(false, '打包失败，请稍后重试');
    return null;
  }
}

/// 构建iOS
class IOSBuilder extends Builder {
  /// 构造函数
  const IOSBuilder(String name, this.buildConfig)
      : xcodebuildProcess = const XcodebuildProcess(),
        super(name, flutterProcess: const IOSFlutterProcess());

  /// xcodebuild命令行工具
  final XcodebuildProcess xcodebuildProcess;

  /// 构建iOS命令行工具
  final IosBuildConfig buildConfig;

  /// pod update
  Future<ProcessResult> podUpdate({String? libraryName}) async {
    return await xcodebuildProcess.podUpdate(
      libraryName: libraryName,
    );
  }

  /// pod install
  Future<ProcessResult> podInstall({bool? verbose, bool? repoUpdate}) async {
    final result = await xcodebuildProcess.podInstall(
      verbose: verbose,
      repoUpdate: repoUpdate,
    );
    return result;
  }

  /// xcodebuild clean
  Future<ProcessResult> xcodebuildClean({required String buildType}) {
    return xcodebuildProcess.clean(
      workspacePath,
      targetName,
      buildType: buildType,
    );
  }

  /// xcodebuild archive
  Future<ProcessResult> xcodebuildArchive({required String buildType}) {
    return xcodebuildProcess.archive(
      workspacePath,
      targetName,
      archivePath,
      buildType: buildType,
    );
  }

  /// xcodebuild export archive
  Future<ProcessResult> xcodebuildExportArchive({required String buildType}) {
    final exportOptionsFileName = buildConfig.exportOptions?.toJson()[buildType.toLowerCase()] as String?;
    final exportOptionsPath = path.join(assetsPath, exportOptionsFileName);
    assert(
      File(exportOptionsPath).existsSync(),
      '请在配置文件设置，并且添加\'${path.join('assets', exportOptionsFileName)}\'文件.',
    );
    return xcodebuildProcess.exportArchive(
      archivePath,
      ipaExportPath,
      exportOptionsPath,
    );
  }

  @override
  Future<File?> build() async {
    var buildType = buildConfig.buildType;
    buildType = buildType?.toLowerCase();
    assert(buildType != null, '请配置buildType');
    var result = await podUpdate();
    if (result.exitCode == 0) {
      result = await podInstall(verbose: true, repoUpdate: false);
    }
    if (result.exitCode == 0) {
      result = await flutterProcess.build(
        BuildPlatform.ios,
        buildType: buildType!,
        treeShakeIcons: buildConfig.treeShakeIcons,
        target: buildConfig.target,
        flavor: buildConfig.flavor,
        pub: buildConfig.pub,
        buildName: buildConfig.buildName,
        buildNumber: buildConfig.buildNumber,
        splitDebugInfo: buildConfig.splitDebugInfo,
        obfuscate: buildConfig.obfuscate,
        dartDefine: buildConfig.dartDefine,
        performanceMeasurementFile: buildConfig.performanceMeasurementFile,
        simulator: buildConfig.simulator,
        codesign: buildConfig.codesign,
      );
    }
    if (result.exitCode == 0) {
      result = await xcodebuildClean(buildType: buildType!);
    }
    if (result.exitCode == 0) {
      result = await xcodebuildArchive(buildType: buildType!);
    }
    if (result.exitCode == 0) {
      result = await xcodebuildExportArchive(buildType: buildType!);
    }
    File? ipaFile;
    final directory = Directory(ipaExportPath);
    if (directory.existsSync()) {
      final files = directory.listSync(recursive: true, followLinks: false);
      for (var file in files) {
        if (file.path.endsWith('.ipa')) {
          ipaFile = File(file.path);
          break;
        }
      }
    }
    if (result.exitCode == 0 && ipaFile?.existsSync() == true) {
      return ipaFile;
    }
    assert(false, '打包失败，请稍后重试');
    return null;
  }
}

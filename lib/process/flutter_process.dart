/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/enums/build_platform.dart';
import 'package:dart_build_script/enums/build_type.dart';
import 'package:dart_build_script/process/process.dart';

/// flutter命令行工具
class FlutterProcess extends IProcess {
  /// 构造函数
  const FlutterProcess() : super();

  /// flutter clean
  Future<ProcessResult> clean() {
    return runAsRoot('flutter', ['clean']);
  }

  /// flutter pub get
  Future<ProcessResult> pubGet() {
    return runAsRoot('flutter', ['pub', 'get']);
  }

  /// flutter pub upgrade
  Future<ProcessResult> pubUpgrade() {
    return runAsRoot('flutter', ['pub', 'upgrade']);
  }

  /// flutter pub run build_runner build
  Future<ProcessResult> runBuildRunner() {
    return runAsRoot('flutter', [
      'packages',
      'pub',
      'run',
      'build_runner',
      'build',
      '--delete-conflicting-outputs',
    ]);
  }

  /// flutter build
  Future<ProcessResult> build(
    BuildPlatform platform, {
    required BuildType buildType,
    bool? treeShakeIcons,
    String? target,
    String? flavor,
    bool? pub,
    String? buildNumber,
    String? buildName,
    String? splitDebugInfo,
    bool? obfuscate,
    String? dartDefine,
    String? performanceMeasurementFile,
    bool? simulator,
    bool? codesign,
    bool? shrink,
    String? targetPlatform,
    String? splitPerAbi,
    bool? trackWidgetCreation,
  }) {
    final arguments = [
      'build',
      getBuildPlatformLabel(platform),
      '--$buildType',
    ];
    if (treeShakeIcons != null) {
      arguments.add(treeShakeIcons ? '--tree-shake-icons' : '--no-tree-shake-icons');
    }
    if (target != null) {
      arguments.addAll(['--target', target]);
    }
    if (flavor != null) {
      arguments.addAll(['--flavor', flavor]);
    }
    if (pub != null) {
      arguments.add(pub ? '--pub' : '--no-pub');
    }
    if (buildNumber != null) {
      arguments.addAll(['--build-number', buildNumber]);
    }
    if (buildName != null) {
      arguments.addAll(['--build-name', buildName]);
    }
    if (splitDebugInfo != null) {
      arguments.addAll(['--split-debug-info', splitDebugInfo]);
    }
    if (obfuscate != null) {
      arguments.add(obfuscate ? '--obfuscate' : '--no-obfuscate');
    }
    if (dartDefine != null) {
      arguments.addAll(['--dart-define', dartDefine]);
    }
    if (performanceMeasurementFile != null) {
      arguments.addAll(['--performance-measurement-file', performanceMeasurementFile]);
    }
    if (simulator != null) {
      arguments.add(simulator ? '--simulator' : '--no-simulator');
    }
    if (codesign != null) {
      arguments.add(codesign ? '--codesign' : '--no-codesign');
    }
    if (shrink != null) {
      arguments.add(shrink ? '--shrink' : '--no-shrink');
    }
    if (targetPlatform != null) {
      arguments.addAll(['--target-platform', targetPlatform]);
    }
    if (splitPerAbi != null) {
      arguments.addAll(['--split-per-abi', splitPerAbi]);
    }
    if (trackWidgetCreation != null) {
      arguments.add(trackWidgetCreation ? '--track-widget-creation' : '--no-track-widget-creation');
    }
    return runAsRoot('flutter', arguments);
  }
}

/// 构建apk命令行
class ApkFlutterProcess extends FlutterProcess {
  /// 构造函数
  const ApkFlutterProcess() : super();

  @override
  Future<ProcessResult> build(
    BuildPlatform platform, {
    BuildType? buildType,
    bool? treeShakeIcons,
    String? target,
    String? flavor,
    bool? pub,
    String? buildNumber,
    String? buildName,
    String? splitDebugInfo,
    bool? obfuscate,
    String? dartDefine,
    String? performanceMeasurementFile,
    bool? simulator,
    bool? codesign,
    bool? shrink,
    String? targetPlatform,
    String? splitPerAbi,
    bool? trackWidgetCreation,
  }) {
    final buildConfig = configs.config.apkBuildConfig;
    return super.build(
      platform,
      buildType: buildType ?? buildConfig!.buildType!,
      treeShakeIcons: treeShakeIcons ?? buildConfig!.treeShakeIcons,
      target: target ?? buildConfig!.target,
      flavor: flavor ?? buildConfig!.flavor,
      pub: pub ?? buildConfig!.pub,
      buildNumber: buildNumber ?? buildConfig!.buildNumber,
      buildName: buildName ?? buildConfig!.buildName,
      splitDebugInfo: splitDebugInfo ?? buildConfig!.splitDebugInfo,
      obfuscate: obfuscate ?? buildConfig!.obfuscate,
      dartDefine: dartDefine ?? buildConfig!.dartDefine,
      performanceMeasurementFile: performanceMeasurementFile ?? buildConfig!.performanceMeasurementFile,
      shrink: shrink ?? buildConfig!.shrink,
      targetPlatform: targetPlatform ?? buildConfig!.targetPlatform,
      splitPerAbi: splitPerAbi ?? buildConfig!.splitPerAbi,
      trackWidgetCreation: trackWidgetCreation ?? buildConfig!.trackWidgetCreation,
    );
  }
}

/// 构建iOS命令行
class IOSFlutterProcess extends FlutterProcess {
  /// 构造函数
  const IOSFlutterProcess() : super();

  @override
  Future<ProcessResult> build(
    BuildPlatform platform, {
    BuildType? buildType,
    bool? treeShakeIcons,
    String? target,
    String? flavor,
    bool? pub,
    String? buildNumber,
    String? buildName,
    String? splitDebugInfo,
    bool? obfuscate,
    String? dartDefine,
    String? performanceMeasurementFile,
    bool? simulator,
    bool? codesign,
    bool? shrink,
    String? targetPlatform,
    String? splitPerAbi,
    bool? trackWidgetCreation,
  }) {
    final buildConfig = configs.config.iosBuildConfig;
    return super.build(
      platform,
      buildType: buildType ?? buildConfig!.buildType!,
      treeShakeIcons: treeShakeIcons ?? buildConfig!.treeShakeIcons,
      target: target ?? buildConfig!.target,
      flavor: flavor ?? buildConfig!.flavor,
      pub: pub ?? buildConfig!.pub,
      buildNumber: buildNumber ?? buildConfig!.buildNumber,
      buildName: buildName ?? buildConfig!.buildName,
      splitDebugInfo: splitDebugInfo ?? buildConfig!.splitDebugInfo,
      obfuscate: obfuscate ?? buildConfig!.obfuscate,
      dartDefine: dartDefine ?? buildConfig!.dartDefine,
      performanceMeasurementFile: performanceMeasurementFile ?? buildConfig!.performanceMeasurementFile,
      codesign: codesign ?? buildConfig!.codesign,
      simulator: simulator ?? buildConfig!.simulator,
    );
  }
}

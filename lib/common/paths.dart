/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:io';

import 'package:path/path.dart' as path;

/// targetName
const String targetName = 'Runner';

/// 项目路径
final String projectPath = Directory.current.path;

/// assets文件夹路径
final String assetsPath = path.join(projectPath, 'assets');

/// 配置文件路径
final String configPath = path.join(assetsPath, 'configs.yaml');

/// 配置模版路径
final String configTemplatePath = path.join(assetsPath, 'configs.json');

/// 发布到钉钉群的描述模板
final String descriptionPath = path.join(assetsPath, 'description.md');

/// temp文件夹路径
final String tempPath = path.join(projectPath, '.temp');

/// sources文件夹路径
final String sourcesPath = path.join(tempPath, 'sources');

/// outputs文件夹路径
final String outputsPath = path.join(tempPath, 'outputs');

/// 项目源码根目录
final String rootPath = path.join(sourcesPath, targetName);

/// pubspec文件路径
final String yamlPath = path.join(rootPath, 'pubspec.yaml');

/// build文件夹路径
final String appBuildPath = path.join(rootPath, 'build');

/// apk导出路径
final String apkExportPath = path.join(appBuildPath, 'app', 'outputs', 'flutter-apk');

/// iOS根目录
final String iosPath = path.join(rootPath, 'ios');

/// pods文件夹路径
final String podsPath = path.join(iosPath, 'Pods', 'Target Support Files', 'Pods-$targetName');

/// workspace文件路径
final String workspacePath = path.join(iosPath, '$targetName.xcworkspace');

/// iphoneos文件夹路径
final String iphoneosPath = path.join(appBuildPath, 'ios', 'iphoneos');

/// archive文件路径
final String archivePath = path.join(iphoneosPath, '$targetName.xcarchive');

/// ipa导出路径
final String ipaExportPath = path.join(iphoneosPath, targetName);

/// buildConfig路径
const String buildConfigPath = 'lib/system/build_config.dart';

/// ios info.plist文件
const String infoPlistPath = 'ios/Runner/Info.plist';

/// android manifest文件
const String manifestPath = 'android/app/src/main/AndroidManifest.xml';

/// iOS配置
const List<String> xcconfigNames = [
  'Pods-Runner.debug.xcconfig',
  'Pods-Runner.profile.xcconfig',
  'Pods-Runner.release.xcconfig',
];

/// 初始化路径
Future<void> installPaths() async {
  assert(Directory(projectPath).existsSync());
  assert(File(configPath).existsSync(), '请添加\'${path.join('assets', 'configs.yaml')}\'配置文件，并设置相应参数.');
  assert(File(configTemplatePath).existsSync(), '\'${path.join('assets', 'configs.json')}\'不存在.');
  assert(File(descriptionPath).existsSync(), '\'${path.join('assets', 'description.md')}\'不存在.');

  final assetsDir = Directory(assetsPath);
  if (!assetsDir.existsSync()) {
    await assetsDir.create(recursive: true);
  }
  final tempDir = Directory(tempPath);
  if (!tempDir.existsSync()) {
    await tempDir.create(recursive: true);
  }
  final sourcesDir = Directory(sourcesPath);
  if (!sourcesDir.existsSync()) {
    await sourcesDir.create(recursive: true);
  }
  final outputsDir = Directory(outputsPath);
  if (!outputsDir.existsSync()) {
    await outputsDir.create(recursive: true);
  }
}

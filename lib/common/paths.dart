import 'dart:io';

import 'package:path/path.dart' as path;

const String targetName = 'Runner';

final String projectPath = Directory.current.path;

final String assetsPath = path.join(projectPath, 'assets');

final String configPath = path.join(assetsPath, 'configs.yaml');

final String configTemplatePath = path.join(assetsPath, 'configs.json');

final String descriptionPath = path.join(assetsPath, 'description.md');

final String tempPath = path.join(projectPath, '.temp');

final String sourcesPath = path.join(tempPath, 'sources');

final String outputsPath = path.join(tempPath, 'outputs');

final String rootPath = path.join(sourcesPath, targetName);

final String yamlPath = path.join(rootPath, 'pubspec.yaml');

final String appBuildPath = path.join(rootPath, 'build');

final String apkExportPath = path.join(appBuildPath, 'app', 'outputs', 'flutter-apk');

final String iosPath = path.join(rootPath, 'ios');

final String podsPath = path.join(iosPath, 'Pods', 'Target Support Files', 'Pods-$targetName');

final String workspacePath = path.join(iosPath, '$targetName.xcworkspace');

final String iphoneosPath = path.join(appBuildPath, 'ios', 'iphoneos');

final String archivePath = path.join(iphoneosPath, '$targetName.xcarchive');

final String ipaExportPath = path.join(iphoneosPath, targetName);

const List<String> xcconfigNames = [
  'Pods-Runner.debug.xcconfig',
  'Pods-Runner.profile.xcconfig',
  'Pods-Runner.release.xcconfig',
];

Future<void> installPaths() async {
  assert(await Directory(projectPath).exists());
  assert(await File(configPath).exists(), '请添加\'${path.join('assets', 'configs.yaml')}\'配置文件，并设置相应参数.');
  assert(await File(configTemplatePath).exists(), '\'${path.join('assets', 'configs.json')}\'不存在.');
  assert(await File(descriptionPath).exists(), '\'${path.join('assets', 'description.md')}\'不存在.');

  var assetsDir = Directory(assetsPath);
  if (!await assetsDir.exists()) {
    await assetsDir.create(recursive: true);
  }
  var tempDir = Directory(tempPath);
  if (!await tempDir.exists()) {
    await tempDir.create(recursive: true);
  }
  var sourcesDir = Directory(sourcesPath);
  if (!await sourcesDir.exists()) {
    await sourcesDir.create(recursive: true);
  }
  var outputsDir = Directory(outputsPath);
  if (!await outputsDir.exists()) {
    await outputsDir.create(recursive: true);
  }
}

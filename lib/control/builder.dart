import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import '../common/constants.dart';
import '../common/paths.dart';
import '../config/configs.dart';
import '../enums/build_platform.dart';
import '../process/flutter_process.dart';
import '../process/xcodebuild_process.dart';
import '../util/file_utils.dart';

/// 构建类
abstract class Builder {
  final String platform;
  final FlutterProcess flutterProcess;

  const Builder(this.platform, {FlutterProcess flutterProcess})
      : assert(platform != null),
        this.flutterProcess = flutterProcess ?? const FlutterProcess();

  Future<ProcessResult> clean() {
    return flutterProcess.clean();
  }

  Future<ProcessResult> pubGet() {
    return flutterProcess.pubGet();
  }

  Future<ProcessResult> runBuildRunner() {
    return flutterProcess.runBuildRunner();
  }

  /// 以[buildType]构建一个发布包
  ///
  /// 返回发布包的路径
  Future<File> build();

  Future<File> startBuild() async {
    var result = await clean();
    if (result.exitCode == 0) {
      result = await pubGet();
    }
    if (result.exitCode == 0) {
      result = await runBuildRunner();
    }
    var file;
    if (result.exitCode == 0) {
      file = await build();
    }
    assert(file != null && file.existsSync());
    return file;
  }
}

/// 构建apk
class ApkBuilder extends Builder {
  final ApkBuildConfig buildConfig;
  const ApkBuilder(String name, this.buildConfig)
      : assert(name != null),
        assert(buildConfig != null),
        super(name, flutterProcess: const ApkFlutterProcess());

  @override
  Future<File> build() async {
    var buildType = buildConfig.buildType;
    assert(buildType != null);
    var result = await flutterProcess.build(
      BuildPlatform.apk,
      buildType: buildType,
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
    var apkFile = File(path.join(apkExportPath, 'app-$buildType.apk'));
    if (result.exitCode == 0 && await apkFile.exists()) {
      return apkFile;
    }
    assert(false, '打包失败，请稍后重试');
    return null;
  }
}

/// 构建iOS
class IOSBuilder extends Builder {
  final XcodebuildProcess xcodebuildProcess;
  final IosBuildConfig buildConfig;

  const IOSBuilder(String name, this.buildConfig)
      : assert(name != null),
        assert(buildConfig != null),
        this.xcodebuildProcess = const XcodebuildProcess(),
        super(name, flutterProcess: const IOSFlutterProcess());

  Future<ProcessResult> podInstall({bool verbose, bool repoUpdate}) async {
    var result = await xcodebuildProcess.podInstall(
      verbose: verbose,
      repoUpdate: repoUpdate,
    );
    await removeJcore();
    return result;
  }

  Future<ProcessResult> xcodebuildClean({@required String buildType}) {
    return xcodebuildProcess.clean(
      workspacePath,
      targetName,
      buildType: buildType,
    );
  }

  Future<ProcessResult> xcodebuildArchive({@required String buildType}) {
    return xcodebuildProcess.archive(
      workspacePath,
      targetName,
      archivePath,
      buildType: buildType,
    );
  }

  Future<ProcessResult> xcodebuildExportArchive({@required String buildType}) {
    var exportOptionsFileName = buildConfig.exportOptions.toJson()[buildType.toLowerCase()];
    var exportOptionsPath = path.join(assetsPath, exportOptionsFileName);
    assert(
      exportOptionsPath != null && File(exportOptionsPath).existsSync(),
      '请在配置文件设置，并且添加\'${path.join('assets', exportOptionsFileName)}\'文件.',
    );
    return xcodebuildProcess.exportArchive(
      archivePath,
      ipaExportPath,
      exportOptionsPath,
    );
  }

  Future<void> removeJcore() async {
    var xcconfigPaths = xcconfigNames.map((e) => path.join(podsPath, e));
    await FileUtils.replace(xcconfigPaths, jcoreLib);
  }

  bool isJcoreError(ProcessResult result) {
    return result.stdout.contains(jcoreError) || result.stderr.contains(jcoreError);
  }

  @override
  Future<File> build() async {
    var buildType = buildConfig.buildType;
    assert(buildType != null);
    buildType = buildType.toLowerCase();
    var result = await podInstall(verbose: true, repoUpdate: false);
    if (result.exitCode == 0) {
      result = await flutterProcess.build(
        BuildPlatform.ios,
        buildType: buildType,
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
      result = await xcodebuildClean(buildType: buildType);
    } else if (isJcoreError(result)) {
      await removeJcore();
      return build();
    }
    if (result.exitCode == 0) {
      result = await xcodebuildArchive(buildType: buildType);
    }
    if (result.exitCode == 0) {
      result = await xcodebuildExportArchive(buildType: buildType);
    }
    var ipaFile = File(path.join(ipaExportPath, '$targetName.ipa'));
    if (result.exitCode == 0 && await ipaFile.exists()) {
      return ipaFile;
    }
    assert(false, '打包失败，请稍后重试');
    return null;
  }
}

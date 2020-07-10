import 'dart:io';

import '../common/paths.dart';
import '../config/configs.dart';
import '../control/builder.dart';
import '../control/giter.dart';
import '../control/notifier.dart';
import '../control/uploader.dart';
import '../enums/export_type.dart';
import 'organizer.dart';

class Manager {
  final Config config;

  const Manager(this.config) : assert(config != null);

  Future<void> build() async {
    var gitConfig = config.gitConfig;
    var androidBuildConfig = config.androidBuildConfig;
    var iosBuildConfig = config.iosBuildConfig;
    var appStoreConfig = config.appStoreConfig;
    var pgyConfig = config.pgyConfig;
    var dingtalkConfig = config.dingtalkConfig;
    assert(config != null, '请添加配置文件');

    await installConfigs();
    await installPaths();

    if (gitConfig != null) {
      var giter = Giter(gitConfig);
      await giter.pull();
    }

    var notifier;
    if (dingtalkConfig != null) {
      notifier = Notifier(dingtalkConfig);
    }

    var organizers = List<Organizer>();
    if (androidBuildConfig != null) {
      organizers.add(Organizer(
        ApkBuilder('android', androidBuildConfig),
        ApkUploader(
          convertExportType(androidBuildConfig.exportType),
          pgyConfig,
          pgyConfig?.androidAppKey,
        ),
        notifier,
      ));
    }
    if (iosBuildConfig != null) {
      organizers.add(Organizer(
        IOSBuilder('ios', iosBuildConfig),
        IOSUploader(
          convertExportType(iosBuildConfig.exportType),
          pgyConfig,
          pgyConfig?.iosAppKey,
          appStoreConfig,
        ),
        notifier,
      ));
    }
    assert(organizers.isNotEmpty, '请在配置文件设置需要构建的类型');
    for (var organizer in organizers) {
      var result = await organizer.release();
      if (result != null) {
        stdout.writeln('构建成功：$result');
      }
    }
  }
}

import 'dart:io';

import '../config/configs.dart';
import '../control/builder.dart';
import '../control/gitter.dart';
import '../control/notifier.dart';
import '../control/uploader.dart';
import '../enums/export_type.dart';
import 'organizer.dart';

class Manager {
  final Config? config;

  const Manager(this.config);

  Future<void> build() async {
    assert(config != null, '请添加配置文件');
    var gitConfig = config!.gitConfig;
    var apkBuildConfig = config!.apkBuildConfig;
    var iosBuildConfig = config!.iosBuildConfig;
    var appStoreConfig = config!.appStoreConfig;
    var pgyConfig = config!.pgyConfig;
    var dingtalkConfig = config!.dingtalkConfig;

    if (gitConfig != null) {
      var gitter = Gitter(gitConfig);
      await gitter.pull();
    }

    var notifier;
    if (dingtalkConfig != null) {
      notifier = Notifier(dingtalkConfig);
    }

    var organizers = <Organizer>[];
    if (apkBuildConfig != null) {
      organizers.add(Organizer(
        ApkBuilder('android', apkBuildConfig),
        uploader: ApkUploader(
          convertExportType(apkBuildConfig.exportType!)!,
          pgyConfig,
          pgyConfig?.androidAppKey,
        ),
        notifier: notifier,
      ));
    }
    if (iosBuildConfig != null) {
      organizers.add(Organizer(
        IOSBuilder('ios', iosBuildConfig),
        uploader: IOSUploader(
          convertExportType(iosBuildConfig.exportType!)!,
          pgyConfig,
          pgyConfig?.iosAppKey,
          appStoreConfig,
        ),
        notifier: notifier,
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

import 'dart:io';

import '../config/configs.dart';
import '../process/xcrun_process.dart';

abstract class Publisher {
  Future<ProcessResult> publish(File file);
}

class ApkPublisher extends Publisher {
  @override
  Future<ProcessResult> publish(File file) async {
    stdout.writeln('暂不支持apk的发布');
    return null;
  }
}

class IOSPublisher extends Publisher {
  final AppStoreConfig config;
  final XcrunProcess process;

  IOSPublisher(this.config) : this.process = XcrunProcess();

  @override
  Future<ProcessResult> publish(File file) async {
    var result = await process.validateApp(
      file.path,
      config.type,
      config.apiKey,
      config.apiIssuer,
      config.outputFormat,
    );
    if (result.exitCode == 0) {
      result = await process.uploadApp(
        file.path,
        config.type,
        config.apiKey,
        config.apiIssuer,
        config.outputFormat,
      );
    }
    return result;
  }
}

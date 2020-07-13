import '../control/builder.dart';
import '../control/notifier.dart';
import '../control/uploader.dart';

class Organizer {
  final Builder builder;
  final Uploader uploader;
  final Notifier notifier;

  Organizer(this.builder, {this.uploader, this.notifier}) : assert(builder != null);

  Future<dynamic> release() async {
    var appFile = await builder.startBuild();
    assert(appFile?.existsSync() == true, '构建失败，请稍后重试');

    if (uploader == null) {
      return;
    }
    var result = await uploader.upload(appFile);
    if (notifier != null && result is Map<String, dynamic>) {
      assert(result['code'] == 0, result['message']);
      return await notifier.notify(builder.platform, result);
    }
    return result;
  }
}

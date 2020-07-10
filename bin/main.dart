import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/manager/manager.dart';

main(List<String> args) async {
  var manager = Manager(configs.config);
  manager.build();
}

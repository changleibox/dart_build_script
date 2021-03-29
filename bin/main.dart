/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'package:dart_build_script/common/paths.dart';
import 'package:dart_build_script/config/configs.dart';
import 'package:dart_build_script/manager/manager.dart';

Future<void> main(List<String> args) async {
  await installConfigs();
  await installPaths();

  final manager = Manager(configs.config);
  await manager.build();
}

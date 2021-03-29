/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

/// 导出类型
enum ExportType {
  /// 导出
  export,

  /// 蒲公英
  dandelion,

  /// appStore
  appStore,
}

/// 根据名称获取导出类型
ExportType? convertExportType(String value) {
  switch (value) {
    case 'export':
      return ExportType.export;
    case 'pgy':
      return ExportType.dandelion;
    case 'appStore':
      return ExportType.appStore;
  }
  assert(false, '不支持的导出类型');
  return null;
}

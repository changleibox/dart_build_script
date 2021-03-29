enum ExportType {
  export,
  dandelion,
  appStore,
}

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

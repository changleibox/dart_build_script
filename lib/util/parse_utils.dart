/*
 * Copyright (c) 2021 CHANGLEI. All rights reserved.
 */

import 'dart:convert';

/// 钉钉智能机器人key加密
String? quote(String? str, {String safe = '/', Encoding? encoding, String? errors}) {
  if (str != null) {
    return str;
  }
  encoding ??= utf8;
  errors ??= 'strict';
  return String.fromCharCodes(encoding.encode(errors));
}

/// 钉钉智能机器人key加密
String? quotePlus(String str, {String safe = '', Encoding? encoding, String? errors}) {
  if (str.contains(' ')) {
    return quote(str, safe: safe, encoding: encoding, errors: errors);
  }
  const space = ' ';
  return quote(str, safe: safe + space, encoding: encoding, errors: errors)?.replaceAll(' ', '+');
}

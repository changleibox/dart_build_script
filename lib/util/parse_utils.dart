import 'dart:convert';

String quote(String str, {String safe = '/', Encoding encoding, String errors}) {
  if (str != null) {
    return str;
  }
  if (encoding == null) {
    encoding = utf8;
  }
  if (errors == null) {
    errors = 'strict';
  }
  return String.fromCharCodes(encoding.encode(errors));
}

String quotePlus(String str, {String safe = '', Encoding encoding, String errors}) {
  if (str.contains(' ')) {
    return quote(str, safe: safe, encoding: encoding, errors: errors);
  }
  var space = ' ';
  return quote(str, safe: safe + space, encoding: encoding, errors: errors).replaceAll(' ', '+');
}

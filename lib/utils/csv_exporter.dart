String sanitizeCsvCell(String value) {
  final dangerousPrefix = RegExp(r'^[=+\-@\t\r\n]');

  if (dangerousPrefix.hasMatch(value)) {
    return "'$value";
  }

  return value.replaceAll('"', '""');
}
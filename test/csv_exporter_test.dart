import 'package:flutter_test/flutter_test.dart';

import 'package:firstep/utils/csv_exporter.dart';

void main() {
  group('حماية CSV من Formula Injection', () {
    test('يحمي القيمة التي تبدأ بعلامة =', () {
      final result = sanitizeCsvCell('=1+1');

      expect(result, "'=1+1");
    });

    test('يحمي القيمة التي تبدأ بعلامة +', () {
      final result = sanitizeCsvCell('+1+1');

      expect(result, "'+1+1");
    });

    test('يحمي القيمة التي تبدأ بعلامة -', () {
      final result = sanitizeCsvCell('-1+1');

      expect(result, "'-1+1");
    });

    test('يحمي القيمة التي تبدأ بعلامة @', () {
      final result = sanitizeCsvCell('@SUM(1,1)');

      expect(result, "'@SUM(1,1)");
    });

    test('لا يغير النص العادي', () {
      final result = sanitizeCsvCell('Software Engineering Intern');

      expect(result, 'Software Engineering Intern');
    });

    test('يحمي علامات الاقتباس', () {
      final result = sanitizeCsvCell('He said "hello"');

      expect(result, 'He said ""hello""');
    });
  });
}
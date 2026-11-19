import 'package:flutter_test/flutter_test.dart';

import 'package:firstep/utils/reference_generator.dart';

void main() {
  group('توليد الرقم المرجعي', () {
    test('ينشئ رقم مرجعي بصيغة FS-2026-0001', () {
      final reference = generateReferenceNumber(
        year: 2026,
        sequence: 1,
      );

      expect(reference, 'FS-2026-0001');
    });

    test('يضيف أصفاراً للرقم 42', () {
      final reference = generateReferenceNumber(
        year: 2026,
        sequence: 42,
      );

      expect(reference, 'FS-2026-0042');
    });

    test('يضيف أصفاراً للرقم 999', () {
      final reference = generateReferenceNumber(
        year: 2026,
        sequence: 999,
      );

      expect(reference, 'FS-2026-0999');
    });

    test('يستعمل السنة الحالية إذا لم نرسل سنة', () {
      final reference = generateReferenceNumber(
        sequence: 1,
      );

      final currentYear = DateTime.now().year;

      expect(reference, 'FS-$currentYear-0001');
    });
  });
}
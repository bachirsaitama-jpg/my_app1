import 'package:flutter_test/flutter_test.dart';

import 'package:firstep/utils/application_status.dart';

void main() {
  group('فحص تأخر الطلبات', () {
    test('الطلب متأخر بعد 8 أيام', () {
      final submittedAt = DateTime(2026, 11, 1);
      final now = DateTime(2026, 11, 9);

      final result = isApplicationLate(
        submittedAt: submittedAt,
        now: now,
      );

      expect(result, true);
    });

    test('الطلب غير متأخر بعد 3 أيام', () {
      final submittedAt = DateTime(2026, 11, 5);
      final now = DateTime(2026, 11, 8);

      final result = isApplicationLate(
        submittedAt: submittedAt,
        now: now,
      );

      expect(result, false);
    });

    test('الطلب متأخر بعد 7 أيام بالضبط', () {
      final submittedAt = DateTime(2026, 11, 1);
      final now = DateTime(2026, 11, 8);

      final result = isApplicationLate(
        submittedAt: submittedAt,
        now: now,
      );

      expect(result, true);
    });

    test('الطلب غير متأخر في نفس اليوم', () {
      final submittedAt = DateTime(2026, 11, 8);
      final now = DateTime(2026, 11, 8);

      final result = isApplicationLate(
        submittedAt: submittedAt,
        now: now,
      );

      expect(result, false);
    });
  });
}
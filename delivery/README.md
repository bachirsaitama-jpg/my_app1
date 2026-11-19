# FIRSTSTEP

FIRSTSTEP هو تطبيق Flutter للبحث عن عروض التربص، حفظ العروض المفضلة، التقديم عليها، وتتبع الطلبات دون الحاجة إلى الإنترنت.

## الميزات المنفذة

- البحث الفوري في عروض التربص
- عرض تفاصيل كل عرض
- إضافة وإزالة العروض من المفضلة
- تقديم طلب تربص عبر استمارة محلية
- توليد رقم مرجعي بصيغة `FS-AAAA-NNNN`
- تتبع حالة الطلبات
- تنبيه للطلبات المتأخرة أكثر من 7 أيام
- تصدير الطلبات إلى ملف CSV بشكل آمن
- دعم العربية RTL والفرنسية
- عمل كامل دون إنترنت باستخدام SQLite

## التقنيات

- Flutter
- Dart
- SQLite عبر sqflite
- shared_preferences
- flutter_localizations
- flutter_test
- sqflite_common_ffi لاختبارات قاعدة البيانات

## التشغيل

```bash
flutter pub get
flutter run
```

## الاختبارات المنفذة

لتشغيل جميع الاختبارات:

```bash
flutter test
```

لتشغيل تقرير مفصل:

```bash
flutter test --reporter expanded
```

النتيجة الحالية:

```text
00:01 +17: All tests passed!
```

## بناء نسخة الإطلاق

```bash
flutter build apk --release --obfuscate --split-debug-info=build/symbols
```

النتيجة:

```text
Built build\app\outputs\flutter-apk\app-release.apk
```

## قاعدة البيانات

- الإصدار الحالي: v2
- الترحيل من v1 إلى v2 يتم عبر `onUpgrade`
- لا يتم فقدان المفضلة أو الطلبات عند التحديث
- يتم تخزين الحد الأدنى من البيانات الشخصية فقط

## الأمان المنفذ

- تنقية ملفات CSV ضد Formula Injection
- عدم استخدام `print` أو `debugPrint` في كود التطبيق
- تعطيل `allowBackup` في Android
- استخدام `dataExtractionRules` لمنع نسخ قاعدة البيانات والتفضيلات المحلية
- بناء APK باستخدام `--obfuscate` و`--split-debug-info`

## التسليم

تحتوي حزمة التسليم على:

- `FIRSTSTEP.apk`
- `FIRSTSTEP_source.zip`
- `README.md`
- `database_schema.md`
- `test_report.md`
- `security_report.md`
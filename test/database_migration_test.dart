import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test('ترحيل المفضلة من v1 إلى v2 يحفظ البيانات', () async {
    final tempDir = Directory.systemTemp.createTempSync('firststep_test');
    final dbPath = '${tempDir.path}/favorites.db';

    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            offer_id TEXT NOT NULL
          )
        ''');

        await db.insert('favorites', {
          'offer_id': 'OFF-001',
        });
      },
    );

    await db.close();

    final upgradedDb = await openDatabase(
      dbPath,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE favorites ADD COLUMN created_at TEXT',
          );
        }
      },
    );

    final favorites = await upgradedDb.query('favorites');

    expect(favorites.length, 1);
    expect(favorites.first['offer_id'], 'OFF-001');

    await upgradedDb.close();
    tempDir.deleteSync(recursive: true);
  });

  test('ترحيل الطلبات من v1 إلى v2 يحفظ البيانات', () async {
    final tempDir = Directory.systemTemp.createTempSync('firststep_test');
    final dbPath = '${tempDir.path}/applications.db';

    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE applications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            reference TEXT NOT NULL,
            offer_id TEXT NOT NULL
          )
        ''');

        await db.insert('applications', {
          'reference': 'FS-2026-0001',
          'offer_id': 'OFF-001',
        });
      },
    );

    await db.close();

    final upgradedDb = await openDatabase(
      dbPath,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE applications ADD COLUMN submitted_at TEXT',
          );
        }
      },
    );

    final applications = await upgradedDb.query('applications');

    expect(applications.length, 1);
    expect(applications.first['reference'], 'FS-2026-0001');

    await upgradedDb.close();
    tempDir.deleteSync(recursive: true);
  });
}
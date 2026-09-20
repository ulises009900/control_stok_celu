import 'dart:io';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/repositories/remito_number_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local numbers are sequential, persistent and reused on reopen',
      () async {
    final folder = await Directory.systemTemp.createTemp('remito-test-');
    final file = File('${folder.path}/test.sqlite');
    var db = AppDatabase(executor: NativeDatabase(file));
    try {
      var repository = RemitoNumberRepository(db);
      expect(await repository.getOrCreate('draft-a'), 1);
      expect(await repository.getOrCreate('sale-b'), 2);
      expect(await repository.getOrCreate('draft-a'), 1);
      final concurrent = await Future.wait([
        repository.getOrCreate('sale-c'),
        repository.getOrCreate('sale-c'),
      ]);
      expect(concurrent, [3, 3]);
      await db.close();
      db = AppDatabase(executor: NativeDatabase(file));
      repository = RemitoNumberRepository(db);
      expect(await repository.getOrCreate('draft-a'), 1);
      expect(await repository.getOrCreate('sale-d'), 4);
    } finally {
      await db.close();
      await folder.delete(recursive: true);
    }
  });

  test(
      'cached server numbers stay stable and local issuance continues after them',
      () async {
    final db = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(db.close);
    await db.customStatement(
      'INSERT INTO remito_numbers(scope, sale_id, number) VALUES (?, ?, ?)',
      ['https://old-server.test', 'sale-a', 37],
    );
    final repository = RemitoNumberRepository(db);
    expect(await repository.getOrCreate('sale-a'), 37);
    expect(await repository.getOrCreate('sale-b'), 38);
    expect(await repository.getOrCreate('sale-a'), 37);
    expect(await repository.getOrCreate('sale-b'), 38);
  });

  test('migration adds numbering without modifying existing database',
      () async {
    final db = AppDatabase(executor: NativeDatabase.memory(setup: (raw) {
      raw.execute('PRAGMA user_version = 7');
      raw.execute('CREATE TABLE saved_data (value TEXT)');
      raw.execute("INSERT INTO saved_data VALUES ('keep')");
    }));
    addTearDown(db.close);
    expect(await RemitoNumberRepository(db).getOrCreate('sale-a'), 1);
    expect(
        (await db.customSelect('SELECT value FROM saved_data').getSingle())
            .read<String>('value'),
        'keep');
  });
}

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:drift/native.dart';

AppDatabase createTestDatabase() {
  return AppDatabase(executor: NativeDatabase.memory());
}

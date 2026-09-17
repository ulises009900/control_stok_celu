// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:control_stok_celu/app/app.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots into the mandatory login screen when logged out',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          // flutter_secure_storage no responde en el entorno de widget
          // tests (no hay implementación de plataforma real), así que
          // evitamos tocarlo acá y simulamos "sin sesión guardada".
          syncCredentialsProvider.overrideWith((ref) async => null),
        ],
        child: const StockApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Entrar'), findsOneWidget);
  });
}

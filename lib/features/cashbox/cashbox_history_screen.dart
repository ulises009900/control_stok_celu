import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';
import 'package:control_stok_celu/features/cashbox/cashbox_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CashboxHistoryScreen extends ConsumerWidget {
  const CashboxHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(cashSessionHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Historial de caja'),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (sessions) {
          if (sessions.isEmpty) {
            return const Center(child: Text('Todavía no hay turnos de caja.'));
          }
          return ListView.separated(
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final session = sessions[index];
              final isOpen = session.status == CashSessionStatus.open;
              final diff = session.differenceCents;
              final owner = session.userName ?? session.deviceId;
              return ListTile(
                leading: Icon(
                  isOpen ? Icons.lock_open : Icons.lock_outline,
                  color: isOpen ? Colors.green : null,
                ),
                title: Text('${_formatDate(session.openedAt)} · $owner'),
                subtitle: Text(
                  isOpen
                      ? 'Abierta · Apertura: ${_formatMoney(session.openingCents)}'
                      : 'Cerrada ${session.closedAt != null ? _formatDate(session.closedAt!) : ''}'
                          '${diff != null ? ' · Dif: ${_formatMoney(diff)}' : ''}',
                ),
                trailing: diff != null && diff != 0
                    ? Icon(
                        diff > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                        color: diff > 0 ? Colors.blue : Colors.red,
                      )
                    : null,
                onTap: () => context.push('/caja/${session.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

String _formatMoney(int cents) {
  final sign = cents < 0 ? '-' : '';
  final absolute = cents.abs();
  final major = absolute ~/ 100;
  final minor = (absolute % 100).toString().padLeft(2, '0');
  return '$sign\$$major.$minor';
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/${local.year} $hour:$minute';
}

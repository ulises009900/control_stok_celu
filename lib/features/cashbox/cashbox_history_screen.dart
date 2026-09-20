import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';
import 'package:control_stok_celu/features/cashbox/cashbox_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CashboxHistoryScreen extends ConsumerWidget {
  const CashboxHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(cashHistoryFilterProvider);
    final sessionsAsync = ref.watch(cashSessionHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Historial de caja'),
      ),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          TextFormField(
            initialValue: filter.employee,
            decoration: const InputDecoration(labelText: 'Filtrar por empleado', prefixIcon: Icon(Icons.person_search)),
            onChanged: (value) => ref.read(cashHistoryFilterProvider.notifier).state = CashHistoryFilter(employee: value, from: filter.from, to: filter.to),
          ),
          const SizedBox(height: 8),
          Wrap(spacing: 8, children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.date_range),
              label: Text(filter.from == null ? 'Filtrar por fecha de apertura' : '${_formatDate(filter.from!)} - ${_formatDate(filter.to!.subtract(const Duration(days: 1)))}'),
              onPressed: () async {
                final range = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)),
                  initialDateRange: filter.from == null ? null : DateTimeRange(start: filter.from!, end: filter.to!.subtract(const Duration(days: 1))));
                if (range == null || !context.mounted) return;
                ref.read(cashHistoryFilterProvider.notifier).state = CashHistoryFilter(employee: filter.employee, from: range.start,
                  to: DateTime(range.end.year, range.end.month, range.end.day + 1));
              },
            ),
            if (filter.from != null) TextButton(onPressed: () => ref.read(cashHistoryFilterProvider.notifier).state = CashHistoryFilter(employee: filter.employee), child: const Text('Todas las fechas')),
          ]),
        ])),
        Expanded(child: sessionsAsync.when(
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
      )),
      ]),
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

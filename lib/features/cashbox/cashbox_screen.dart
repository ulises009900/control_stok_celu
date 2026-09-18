import 'package:control_stok_celu/core/errors/app_exception.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/cashbox/cashbox_models.dart';
import 'package:control_stok_celu/features/cashbox/cashbox_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class CashboxScreen extends ConsumerStatefulWidget {
  const CashboxScreen({super.key});

  @override
  ConsumerState<CashboxScreen> createState() => _CashboxScreenState();
}

class _CashboxScreenState extends ConsumerState<CashboxScreen> {
  bool _busy = false;

  Future<void> _openSession() async {
    final result = await showDialog<_AmountDialogResult>(
      context: context,
      builder: (context) => const _AmountDialog(
        title: 'Abrir caja',
        amountLabel: 'Monto inicial en efectivo',
        confirmLabel: 'Abrir',
      ),
    );
    if (result == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final credentials = await ref.read(syncCredentialsProvider.future);
      final repo = ref.read(cashboxRepositoryProvider);
      await repo.openSession(
        OpenCashSessionInput(
          id: const Uuid().v4(),
          deviceId: deviceId,
          openingCents: result.amountCents,
          openedAt: DateTime.now().toUtc(),
          userId: credentials?.username,
          userName: credentials?.displayName ?? credentials?.username,
          notes: result.notes,
        ),
      );
      await ref.read(syncControllerProvider.notifier).syncNow(silent: true);
      invalidateCashboxProviders(ref);
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _registerMovement(
      CashSessionSummary session, CashMovementType type) async {
    final result = await showDialog<_AmountDialogResult>(
      context: context,
      builder: (context) => _AmountDialog(
        title: type == CashMovementType.income
            ? 'Registrar ingreso'
            : 'Registrar egreso',
        amountLabel: 'Importe',
        confirmLabel: 'Registrar',
        showNotesAsDescription: true,
      ),
    );
    if (result == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final deviceId = await ref.read(deviceIdProvider.future);
      final credentials = await ref.read(syncCredentialsProvider.future);
      final repo = ref.read(cashboxRepositoryProvider);
      await repo.registerMovement(
        RegisterCashMovementInput(
          id: const Uuid().v4(),
          sessionId: session.id,
          type: type,
          amountCents: result.amountCents,
          deviceId: deviceId,
          description: result.notes,
          paymentMethod: result.paymentMethod,
          userId: credentials?.username,
        ),
      );
      await ref.read(syncControllerProvider.notifier).syncNow(silent: true);
      invalidateCashboxProviders(ref);
      ref.invalidate(cashSessionDetailProvider(session.id));
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _closeSession(CashSessionSummary session) async {
    final repo = ref.read(cashboxRepositoryProvider);
    final detail = await repo.getSessionDetail(session.id);
    if (!mounted) return;
    final result = await showDialog<_AmountDialogResult>(
      context: context,
      builder: (context) => _CloseSessionDialog(detail: detail),
    );
    if (result == null) {
      return;
    }
    setState(() => _busy = true);
    try {
      final closed = await repo.closeSession(
        CloseCashSessionInput(
          sessionId: session.id,
          countedClosingCents: result.amountCents,
          closedAt: DateTime.now().toUtc(),
          notes: result.notes,
        ),
      );
      await ref.read(syncControllerProvider.notifier).syncNow(silent: true);
      invalidateCashboxProviders(ref);
      if (mounted) {
        await _showCloseSummary(closed);
      }
    } catch (e) {
      _showError(e);
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _showCloseSummary(CashSessionDetail detail) async {
    final diff = detail.differenceCents ?? 0;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Caja cerrada'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Esperado: ${_formatMoney(detail.expectedClosingCents)}'),
            Text('Contado: ${_formatMoney(detail.countedClosingCents ?? 0)}'),
            const SizedBox(height: 8),
            Text(
              diff == 0
                  ? 'La caja cuadró perfectamente.'
                  : diff > 0
                      ? 'Sobrante: ${_formatMoney(diff)}'
                      : 'Faltante: ${_formatMoney(-diff)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: diff == 0
                    ? Colors.green
                    : diff > 0
                        ? Colors.blue
                        : Colors.red,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  void _showError(Object error) {
    final message = error is AppException ? error.message : error.toString();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final openSessionAsync = ref.watch(currentOpenCashSessionProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Caja'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Historial de turnos',
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/caja/historial'),
          ),
        ],
      ),
      body: openSessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (session) {
          if (session == null) {
            return _NoOpenSessionView(
              busy: _busy,
              onOpen: _openSession,
            );
          }
          return _OpenSessionView(
            session: session,
            busy: _busy,
            onIncome: () => _registerMovement(session, CashMovementType.income),
            onExpense: () =>
                _registerMovement(session, CashMovementType.expense),
            onClose: () => _closeSession(session),
            onOpenDetail: () => context.push('/caja/${session.id}'),
          );
        },
      ),
    );
  }
}

class _NoOpenSessionView extends StatelessWidget {
  const _NoOpenSessionView({required this.busy, required this.onOpen});

  final bool busy;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.point_of_sale_outlined, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No hay una caja abierta en este dispositivo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: busy ? null : onOpen,
              icon: const Icon(Icons.lock_open),
              label: const Text('Abrir caja'),
            ),
          ],
        ),
      ),
    );
  }
}

class _OpenSessionView extends StatelessWidget {
  const _OpenSessionView({
    required this.session,
    required this.busy,
    required this.onIncome,
    required this.onExpense,
    required this.onClose,
    required this.onOpenDetail,
  });

  final CashSessionSummary session;
  final bool busy;
  final VoidCallback onIncome;
  final VoidCallback onExpense;
  final VoidCallback onClose;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.lock_open, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Caja abierta',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Apertura: ${_formatMoney(session.openingCents)}'),
                Text('Desde: ${_formatDate(session.openedAt)}'),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onOpenDetail,
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: const Text('Ver arqueo y movimientos'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: busy ? null : onIncome,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Ingreso'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: busy ? null : onExpense,
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text('Egreso'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton.tonalIcon(
          onPressed: busy ? null : onClose,
          icon: const Icon(Icons.lock_outline),
          label: const Text('Cerrar caja'),
        ),
      ],
    );
  }
}

class _AmountDialogResult {
  const _AmountDialogResult(this.amountCents, this.notes, {this.paymentMethod = 'Efectivo'});

  final int amountCents;
  final String? notes;
  final String paymentMethod;
}

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({
    required this.title,
    required this.amountLabel,
    required this.confirmLabel,
    this.showNotesAsDescription = false,
  });

  final String title;
  final String amountLabel;
  final String confirmLabel;
  final bool showNotesAsDescription;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  String _paymentMethod = 'Efectivo';

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _confirm() {
    final amount =
        double.tryParse(_amountController.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresá un importe válido.')),
      );
      return;
    }
    Navigator.of(context).pop(
      _AmountDialogResult(
        (amount * 100).round(),
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        paymentMethod: _paymentMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _amountController,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
            ],
            decoration: InputDecoration(labelText: widget.amountLabel),
          ),
          const SizedBox(height: 12),
          if (widget.showNotesAsDescription)
            DropdownButtonFormField<String>(
              initialValue: _paymentMethod,
              decoration: const InputDecoration(labelText: 'Medio de pago'),
              items: const [
                DropdownMenuItem(value: 'Efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'Transferencia', child: Text('Transferencia')),
                DropdownMenuItem(value: 'Tarjeta', child: Text('Tarjeta')),
              ],
              onChanged: (value) => setState(() => _paymentMethod = value ?? 'Efectivo'),
            ),
          if (widget.showNotesAsDescription) const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText:
                  widget.showNotesAsDescription ? 'Descripción' : 'Notas',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _confirm,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

class _CloseSessionDialog extends StatefulWidget {
  const _CloseSessionDialog({required this.detail});

  final CashSessionDetail detail;

  @override
  State<_CloseSessionDialog> createState() => _CloseSessionDialogState();
}

class _CloseSessionDialogState extends State<_CloseSessionDialog> {
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _confirm() {
    final amount =
        double.tryParse(_amountController.text.trim().replaceAll(',', '.'));
    if (amount == null || amount < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresá un importe válido.')),
      );
      return;
    }
    Navigator.of(context).pop(
      _AmountDialogResult(
        (amount * 100).round(),
        _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    return AlertDialog(
      title: const Text('Cerrar caja'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Apertura: ${_formatMoney(detail.openingCents)}'),
            Text(
                'Ventas en efectivo (${detail.salesCount}): ${_formatMoney(detail.salesTotalCents)}'),
            Text('Transferencias (no efectivo): ${_formatMoney(detail.transferSalesCents)}'),
            Text('Tarjetas (no efectivo): ${_formatMoney(detail.cardSalesCents)}'),
            Text('Cuenta corriente pendiente: ${_formatMoney(detail.currentAccountSalesCents)}'),
            Text(
                'Ingresos manuales: ${_formatMoney(detail.manualIncomeCents)}'),
            Text(
                'Egresos manuales: ${_formatMoney(detail.manualExpenseCents)}'),
            Text(
                'Gastos (${detail.expensesCount}): ${_formatMoney(detail.expensesTotalCents)}'),
            const Divider(),
            Text(
              'Efectivo esperado en caja: ${_formatMoney(detail.expectedClosingCents)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: const InputDecoration(labelText: 'Efectivo contado'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notas de cierre'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _confirm,
          child: const Text('Cerrar caja'),
        ),
      ],
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

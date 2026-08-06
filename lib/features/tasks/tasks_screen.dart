import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Tareas'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Recordatorios'),
            Tab(text: 'Checklist'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          _RemindersTab(),
          _ChecklistsTab(),
        ],
      ),
    );
  }
}

class _RemindersTab extends ConsumerStatefulWidget {
  const _RemindersTab();

  @override
  ConsumerState<_RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends ConsumerState<_RemindersTab> {
  static const Uuid _uuid = Uuid();
  bool _loading = true;
  String? _error;
  List<dynamic> _items = <dynamic>[];
  bool _showCompleted = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(appDatabaseProvider);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final query = db.select(db.reminders)
        ..orderBy(
            [(t) => OrderingTerm(expression: t.dueAt, mode: OrderingMode.asc)]);
      final rows = await query.get();
      setState(() {
        _items = rows
            .where((item) => _showCompleted ? true : item.status != 'done')
            .toList();
      });
    } catch (e) {
      setState(() => _error = 'No pudimos cargar recordatorios. $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openForm({dynamic current}) async {
    final titleController = TextEditingController(text: current?.title ?? '');
    final descriptionController =
        TextEditingController(text: current?.description ?? '');
    DateTime dueAt = current?.dueAt ?? DateTime.now().toUtc();
    String priority = current?.priority ?? 'normal';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Descripción'),
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: priority,
                      decoration: const InputDecoration(labelText: 'Prioridad'),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'low', child: Text('Baja')),
                        DropdownMenuItem(
                            value: 'normal', child: Text('Normal')),
                        DropdownMenuItem(value: 'high', child: Text('Alta')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setModalState(() => priority = value);
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    Text('Fecha: ${_formatDate(dueAt)}'),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                          initialDate: dueAt.toLocal(),
                        );
                        if (picked != null) {
                          setModalState(() {
                            dueAt = DateTime.utc(
                                picked.year, picked.month, picked.day);
                          });
                        }
                      },
                      child: const Text('Elegir fecha'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final db = ref.read(appDatabaseProvider);
                        final navigator = Navigator.of(context);
                        if (current == null) {
                          await db.into(db.reminders).insert(
                                RemindersCompanion.insert(
                                  id: _uuid.v4(),
                                  title: titleController.text.trim(),
                                  description: Value(
                                      descriptionController.text.trim().isEmpty
                                          ? null
                                          : descriptionController.text.trim()),
                                  dueAt: dueAt,
                                  priority: Value(priority),
                                ),
                              );
                        } else {
                          await (db.update(db.reminders)
                                ..where((t) => t.id.equals(current.id)))
                              .write(
                            RemindersCompanion(
                              title: Value(titleController.text.trim()),
                              description: Value(
                                  descriptionController.text.trim().isEmpty
                                      ? null
                                      : descriptionController.text.trim()),
                              dueAt: Value(dueAt),
                              priority: Value(priority),
                            ),
                          );
                        }
                        if (!mounted) {
                          return;
                        }
                        navigator.pop();
                        _load();
                      },
                      child: const Text('Guardar recordatorio'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _toggleDone(dynamic item) async {
    final db = ref.read(appDatabaseProvider);
    final nextDone = item.status != 'done';
    await (db.update(db.reminders)..where((t) => t.id.equals(item.id))).write(
      RemindersCompanion(
        status: Value(nextDone ? 'done' : 'pending'),
        completedAt: Value(nextDone ? DateTime.now().toUtc() : null),
      ),
    );
    _load();
  }

  Future<void> _delete(dynamic item) async {
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.reminders)..where((t) => t.id.equals(item.id))).go();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    return Column(
      children: <Widget>[
        SwitchListTile(
          value: _showCompleted,
          onChanged: (value) {
            setState(() => _showCompleted = value);
            _load();
          },
          title: const Text('Mostrar completados'),
        ),
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text('No hay recordatorios.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle:
                          Text('${_formatDate(item.dueAt)} · ${item.priority}'),
                      leading: Checkbox(
                        value: item.status == 'done',
                        onChanged: (_) => _toggleDone(item),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _openForm(current: item);
                          } else {
                            _delete(item);
                          }
                        },
                        itemBuilder: (context) =>
                            const <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              value: 'edit', child: Text('Editar')),
                          PopupMenuItem<String>(
                              value: 'delete', child: Text('Eliminar')),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => _openForm(),
            icon: const Icon(Icons.add),
            label: const Text('Nuevo recordatorio'),
          ),
        ),
      ],
    );
  }
}

class _ChecklistsTab extends ConsumerStatefulWidget {
  const _ChecklistsTab();

  @override
  ConsumerState<_ChecklistsTab> createState() => _ChecklistsTabState();
}

class _ChecklistsTabState extends ConsumerState<_ChecklistsTab> {
  static const Uuid _uuid = Uuid();
  bool _loading = true;
  String? _error;
  List<dynamic> _items = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(appDatabaseProvider);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final rows = await (db.select(db.checklists)
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
            ]))
          .get();
      setState(() => _items = rows);
    } catch (e) {
      setState(() => _error = 'No pudimos cargar checklist. $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _openChecklist({dynamic current}) async {
    final db = ref.read(appDatabaseProvider);
    final titleController = TextEditingController(text: current?.title ?? '');
    final itemControllers = <TextEditingController>[];
    final existingItems = current == null
        ? <dynamic>[]
        : await (db.select(db.checklistItems)
              ..where((t) => t.checklistId.equals(current.id))
              ..orderBy([(t) => OrderingTerm(expression: t.position)]))
            .get();
    itemControllers.addAll(
      existingItems.map((item) => TextEditingController(text: item.textValue)),
    );
    if (itemControllers.isEmpty) {
      itemControllers.add(TextEditingController());
    }

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Título'),
                    ),
                    const SizedBox(height: 12),
                    ...itemControllers.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    controller: entry.value,
                                    decoration: InputDecoration(
                                      labelText: 'Elemento ${entry.key + 1}',
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: itemControllers.length == 1
                                      ? null
                                      : () {
                                          setModalState(() {
                                            itemControllers.removeAt(entry.key);
                                          });
                                        },
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                              ],
                            ),
                          ),
                        ),
                    TextButton.icon(
                      onPressed: () {
                        setModalState(() {
                          itemControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar elemento'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final now = DateTime.now().toUtc();
                        final checklistId = current?.id ?? _uuid.v4();
                        if (current == null) {
                          await db.into(db.checklists).insert(
                                ChecklistsCompanion.insert(
                                  id: checklistId,
                                  title: titleController.text.trim(),
                                  createdAt: now,
                                  updatedAt: now,
                                ),
                              );
                        } else {
                          await (db.update(db.checklists)
                                ..where((t) => t.id.equals(checklistId)))
                              .write(
                            ChecklistsCompanion(
                              title: Value(titleController.text.trim()),
                              updatedAt: Value(now),
                            ),
                          );
                          await (db.delete(db.checklistItems)
                                ..where(
                                    (t) => t.checklistId.equals(checklistId)))
                              .go();
                        }
                        for (var index = 0;
                            index < itemControllers.length;
                            index++) {
                          final text = itemControllers[index].text.trim();
                          if (text.isEmpty) {
                            continue;
                          }
                          await db.into(db.checklistItems).insert(
                                ChecklistItemsCompanion.insert(
                                  id: _uuid.v4(),
                                  checklistId: checklistId,
                                  textValue: text,
                                  position: Value(index),
                                  isDone: const Value(false),
                                ),
                              );
                        }
                        if (!mounted) {
                          return;
                        }
                        navigator.pop();
                        _load();
                      },
                      child: const Text('Guardar checklist'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _openChecklistDetail(dynamic checklist) async {
    final db = ref.read(appDatabaseProvider);
    final items = await (db.select(db.checklistItems)
          ..where((t) => t.checklistId.equals(checklist.id))
          ..orderBy([(t) => OrderingTerm(expression: t.position)]))
        .get();
    if (!mounted) {
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> toggle(dynamic item) async {
              await (db.update(db.checklistItems)
                    ..where((t) => t.id.equals(item.id)))
                  .write(
                ChecklistItemsCompanion(isDone: Value(!item.isDone)),
              );
              final refreshed = await (db.select(db.checklistItems)
                    ..where((t) => t.checklistId.equals(checklist.id))
                    ..orderBy([(t) => OrderingTerm(expression: t.position)]))
                  .get();
              items
                ..clear()
                ..addAll(refreshed);
              setModalState(() {});
              _load();
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 420,
                child: Column(
                  children: <Widget>[
                    Text(checklist.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView(
                        children: items
                            .map(
                              (item) => CheckboxListTile(
                                value: item.isDone,
                                onChanged: (_) => toggle(item),
                                title: Text(item.textValue),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _delete(dynamic checklist) async {
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.checklistItems)
          ..where((t) => t.checklistId.equals(checklist.id)))
        .go();
    await (db.delete(db.checklists)..where((t) => t.id.equals(checklist.id)))
        .go();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: _items.isEmpty
              ? const Center(child: Text('No hay checklists.'))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.isArchived ? 'Archivado' : 'Activo'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _openChecklist(current: item);
                          } else {
                            _delete(item);
                          }
                        },
                        itemBuilder: (context) =>
                            const <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                              value: 'edit', child: Text('Editar')),
                          PopupMenuItem<String>(
                              value: 'delete', child: Text('Eliminar')),
                        ],
                      ),
                      onTap: () => _openChecklistDetail(item),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () => _openChecklist(),
            icon: const Icon(Icons.add),
            label: const Text('Nueva checklist'),
          ),
        ),
      ],
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}

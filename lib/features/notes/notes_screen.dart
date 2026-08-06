import 'dart:async';
import 'dart:convert';

import 'package:control_stok_celu/data/db/app_database.dart';
import 'package:control_stok_celu/data/providers/app_providers.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  static const Uuid _uuid = Uuid();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _loading = true;
  String? _error;
  List<dynamic> _items = <dynamic>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = ref.read(appDatabaseProvider);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final normalized = _searchController.text.trim().toLowerCase();
      final query = db.select(db.notes)
        ..orderBy([
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)
        ]);
      final rows = await query.get();
      setState(() {
        _items = normalized.isEmpty
            ? rows
            : rows.where((note) {
                final haystack =
                    '${note.title} ${note.content} ${(note.tagsJson ?? '')}'
                        .toLowerCase();
                return haystack.contains(normalized);
              }).toList();
      });
    } catch (e) {
      setState(() => _error = 'No pudimos cargar notas. $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _load);
  }

  Future<void> _openForm({dynamic current}) async {
    final titleController = TextEditingController(text: current?.title ?? '');
    final contentController =
        TextEditingController(text: current?.content ?? '');
    final tagsController = TextEditingController(
      text: current?.tagsJson == null
          ? ''
          : ((jsonDecode(current.tagsJson) as List<dynamic>).join(', ')),
    );
    bool isPinned = current?.isPinned ?? false;
    bool isArchived = current?.isArchived ?? false;

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
                      controller: contentController,
                      minLines: 4,
                      maxLines: 8,
                      decoration: const InputDecoration(labelText: 'Contenido'),
                    ),
                    TextField(
                      controller: tagsController,
                      decoration: const InputDecoration(labelText: 'Tags'),
                    ),
                    SwitchListTile(
                      value: isPinned,
                      onChanged: (value) =>
                          setModalState(() => isPinned = value),
                      title: const Text('Importante'),
                    ),
                    SwitchListTile(
                      value: isArchived,
                      onChanged: (value) =>
                          setModalState(() => isArchived = value),
                      title: const Text('Archivada'),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final db = ref.read(appDatabaseProvider);
                        final navigator = Navigator.of(context);
                        final now = DateTime.now().toUtc();
                        final tags = tagsController.text.trim().isEmpty
                            ? null
                            : jsonEncode(
                                tagsController.text
                                    .split(',')
                                    .map((tag) => tag.trim())
                                    .where((tag) => tag.isNotEmpty)
                                    .toList(),
                              );
                        if (current == null) {
                          await db.into(db.notes).insert(
                                NotesCompanion.insert(
                                  id: _uuid.v4(),
                                  title: titleController.text.trim(),
                                  content: contentController.text.trim(),
                                  tagsJson: Value(tags),
                                  isPinned: Value(isPinned),
                                  isArchived: Value(isArchived),
                                  createdAt: now,
                                  updatedAt: now,
                                ),
                              );
                        } else {
                          await (db.update(db.notes)
                                ..where((t) => t.id.equals(current.id)))
                              .write(
                            NotesCompanion(
                              title: Value(titleController.text.trim()),
                              content: Value(contentController.text.trim()),
                              tagsJson: Value(tags),
                              isPinned: Value(isPinned),
                              isArchived: Value(isArchived),
                              updatedAt: Value(now),
                            ),
                          );
                        }
                        if (!mounted) {
                          return;
                        }
                        navigator.pop();
                        _load();
                      },
                      child: const Text('Guardar nota'),
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

  Future<void> _delete(dynamic note) async {
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.notes)..where((t) => t.id.equals(note.id))).go();
    if (!mounted) {
      return;
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Notas'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Buscar nota',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva nota'),
      ),
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_items.isEmpty) {
      return const Center(child: Text('No hay notas para mostrar.'));
    }
    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final note = _items[index];
        return ListTile(
          title: Text(note.title),
          subtitle:
              Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
          leading: note.isPinned ? const Icon(Icons.push_pin_outlined) : null,
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _openForm(current: note);
              } else {
                _delete(note);
              }
            },
            itemBuilder: (context) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'edit', child: Text('Editar')),
              PopupMenuItem<String>(value: 'delete', child: Text('Eliminar')),
            ],
          ),
          onTap: () => _openForm(current: note),
        );
      },
    );
  }
}

import 'package:control_stok_celu/data/sync/sync_api_client.dart';
import 'package:control_stok_celu/data/sync/sync_credentials_store.dart';
import 'package:control_stok_celu/data/sync/sync_providers.dart';
import 'package:control_stok_celu/domain/auth/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeesScreen extends ConsumerStatefulWidget {
  const EmployeesScreen({super.key});

  @override
  ConsumerState<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends ConsumerState<EmployeesScreen> {
  bool _loading = true;
  String? _error;
  List<AppUser> _users = <AppUser>[];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final client = await ref.read(authenticatedSyncApiClientProvider.future);
      if (client == null) {
        throw StateError(
          'No se encontró una sesión activa o el token no es válido.',
        );
      }
      final users = await client.getUsers();
      if (mounted) {
        setState(() {
          _users = users;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _openCreateUserDialog() async {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final displayNameController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'vendedor';
    bool obscurePassword = true;
    bool saving = false;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Nuevo Empleado / Usuario'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Usuario *',
                          hintText: 'ej: vendedor1',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 3) {
                            return 'Mínimo 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo',
                          hintText: 'ej: Juan Pérez',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña *',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 4) {
                            return 'Mínimo 4 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Rol',
                          prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'vendedor',
                            child: Text('Vendedor (Caja, Ventas, Stock)'),
                          ),
                          DropdownMenuItem(
                            value: 'admin',
                            child: Text('Administrador (Acceso total)'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => selectedRole = val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          setDialogState(() => saving = true);
                          try {
                            final client = await ref.read(
                              authenticatedSyncApiClientProvider.future,
                            );
                            if (client == null) {
                              throw StateError('Sin conexión con el servidor.');
                            }
                            await client.createUser(
                              username: usernameController.text.trim(),
                              password: passwordController.text.trim(),
                              role: selectedRole,
                              displayName:
                                  displayNameController.text.trim().isNotEmpty
                                      ? displayNameController.text.trim()
                                      : null,
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Empleado creado con éxito.'),
                                ),
                              );
                            }
                            await _loadUsers();
                          } catch (e) {
                            setDialogState(() => saving = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openEditUserDialog(
    AppUser user,
    SyncCredentials? currentCreds,
  ) async {
    final formKey = GlobalKey<FormState>();
    final displayNameController = TextEditingController(text: user.displayName);
    final passwordController = TextEditingController();
    String selectedRole = user.role;
    bool isActive = user.isActive;
    bool obscurePassword = true;
    bool saving = false;
    final isSelf = currentCreds?.username == user.username;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Editar ${user.username}'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Rol',
                          prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                        ),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(
                            value: 'vendedor',
                            child: Text('Vendedor'),
                          ),
                          DropdownMenuItem(
                            value: 'admin',
                            child: Text('Administrador'),
                          ),
                        ],
                        onChanged: isSelf
                            ? null
                            : (val) {
                                if (val != null) {
                                  setDialogState(() => selectedRole = val);
                                }
                              },
                      ),
                      if (isSelf) ...<Widget>[
                        const SizedBox(height: 4),
                        const Text(
                          'No podés cambiar tu propio rol de administrador.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Cuenta activa'),
                        subtitle: Text(
                          isActive
                              ? 'Puede iniciar sesión'
                              : 'Acceso bloqueado',
                        ),
                        value: isActive,
                        onChanged: isSelf
                            ? null
                            : (val) {
                                setDialogState(() => isActive = val);
                              },
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Nueva Contraseña (opcional)',
                          hintText: 'Dejar vacío para no cambiar',
                          prefixIcon: const Icon(Icons.lock_reset_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value.length < 4) {
                            return 'Mínimo 4 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: saving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: saving
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          setDialogState(() => saving = true);
                          try {
                            final client = await ref.read(
                              authenticatedSyncApiClientProvider.future,
                            );
                            if (client == null) {
                              throw StateError('Sin conexión con el servidor.');
                            }
                            await client.updateUser(
                              id: user.id,
                              displayName: displayNameController.text.trim(),
                              role: selectedRole,
                              isActive: isActive,
                              password:
                                  passwordController.text.trim().isNotEmpty
                                      ? passwordController.text.trim()
                                      : null,
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Empleado actualizado.'),
                                ),
                              );
                            }
                            await _loadUsers();
                          } catch (e) {
                            setDialogState(() => saving = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Guardar Cambios'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteUser(AppUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Eliminar empleado?'),
          content: Text(
            'Se eliminará el acceso de "${user.displayName}" (${user.username}).',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final client =
            await ref.read(authenticatedSyncApiClientProvider.future);
        if (client == null) {
          throw StateError('Sin conexión con el servidor.');
        }
        await client.deleteUser(user.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Empleado eliminado.')),
          );
        }
        await _loadUsers();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCreds = ref.watch(syncCredentialsProvider).valueOrNull;

    final filteredUsers = _users.where((user) {
      if (_searchQuery.isEmpty) {
        return true;
      }
      final q = _searchQuery.toLowerCase();
      return user.username.toLowerCase().contains(q) ||
          user.displayName.toLowerCase().contains(q) ||
          user.role.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: const Text('Empleados y Roles'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar lista',
            onPressed: _loading ? null : _loadUsers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateUserDialog,
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Nuevo Empleado'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar empleado por nombre o usuario',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
            ),
          ),
          Expanded(
            child: _buildBody(filteredUsers, currentCreds),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(List<AppUser> users, SyncCredentials? currentCreds) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.cloud_off, size: 48, color: Colors.orange),
              const SizedBox(height: 12),
              Text(
                'No se pudo conectar con el servidor:',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadUsers,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (users.isEmpty) {
      return const Center(
        child: Text(
          'No se encontraron empleados.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final user = users[index];
          final isSelf = currentCreds?.username == user.username;
          final roleObj = userRoleFromString(user.role);

          return Card(
            elevation: 1,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.isActive
                    ? (roleObj.isAdmin
                        ? Colors.amber.shade700
                        : Colors.blue.shade600)
                    : Colors.grey.shade400,
                child: Icon(
                  roleObj.isAdmin ? Icons.shield : Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      user.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration:
                            user.isActive ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                  if (isSelf)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        'Vos',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 2),
                  Text('@${user.username} • Rol: ${roleObj.displayLabel}'),
                  const SizedBox(height: 2),
                  Text(
                    user.isActive
                        ? 'Estado: Activo'
                        : 'Estado: Inactivo (Bloqueado)',
                    style: TextStyle(
                      fontSize: 12,
                      color: user.isActive ? Colors.green.shade700 : Colors.red,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (action) {
                  if (action == 'edit') {
                    _openEditUserDialog(user, currentCreds);
                  } else if (action == 'delete') {
                    _confirmDeleteUser(user);
                  }
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.edit_outlined, size: 20),
                        SizedBox(width: 8),
                        Text('Editar / Clave'),
                      ],
                    ),
                  ),
                  if (!isSelf)
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete_outline,
                              color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              onTap: () => _openEditUserDialog(user, currentCreds),
            ),
          );
        },
      ),
    );
  }
}

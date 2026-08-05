// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, parentId, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? parentId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Category(
      {required this.id,
      required this.name,
      this.parentId,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Category copyWith(
          {String? id,
          String? name,
          Value<String?> parentId = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parentId, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? parentId,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaxProfilesTable extends TaxProfiles
    with TableInfo<$TaxProfilesTable, TaxProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaxProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rateBpsMeta =
      const VerificationMeta('rateBps');
  @override
  late final GeneratedColumn<int> rateBps = GeneratedColumn<int>(
      'rate_bps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, rateBps, isDefault, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tax_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<TaxProfile> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('rate_bps')) {
      context.handle(_rateBpsMeta,
          rateBps.isAcceptableOrUnknown(data['rate_bps']!, _rateBpsMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaxProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaxProfile(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      rateBps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rate_bps'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TaxProfilesTable createAlias(String alias) {
    return $TaxProfilesTable(attachedDatabase, alias);
  }
}

class TaxProfile extends DataClass implements Insertable<TaxProfile> {
  final String id;
  final String name;
  final int rateBps;
  final bool isDefault;
  final bool isActive;
  final DateTime createdAt;
  const TaxProfile(
      {required this.id,
      required this.name,
      required this.rateBps,
      required this.isDefault,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['rate_bps'] = Variable<int>(rateBps);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaxProfilesCompanion toCompanion(bool nullToAbsent) {
    return TaxProfilesCompanion(
      id: Value(id),
      name: Value(name),
      rateBps: Value(rateBps),
      isDefault: Value(isDefault),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory TaxProfile.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaxProfile(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      rateBps: serializer.fromJson<int>(json['rateBps']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'rateBps': serializer.toJson<int>(rateBps),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaxProfile copyWith(
          {String? id,
          String? name,
          int? rateBps,
          bool? isDefault,
          bool? isActive,
          DateTime? createdAt}) =>
      TaxProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        rateBps: rateBps ?? this.rateBps,
        isDefault: isDefault ?? this.isDefault,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  TaxProfile copyWithCompanion(TaxProfilesCompanion data) {
    return TaxProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      rateBps: data.rateBps.present ? data.rateBps.value : this.rateBps,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaxProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rateBps: $rateBps, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, rateBps, isDefault, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaxProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.rateBps == this.rateBps &&
          other.isDefault == this.isDefault &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class TaxProfilesCompanion extends UpdateCompanion<TaxProfile> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rateBps;
  final Value<bool> isDefault;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaxProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rateBps = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaxProfilesCompanion.insert({
    required String id,
    required String name,
    this.rateBps = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<TaxProfile> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rateBps,
    Expression<bool>? isDefault,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rateBps != null) 'rate_bps': rateBps,
      if (isDefault != null) 'is_default': isDefault,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaxProfilesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? rateBps,
      Value<bool>? isDefault,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TaxProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rateBps: rateBps ?? this.rateBps,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rateBps.present) {
      map['rate_bps'] = Variable<int>(rateBps.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaxProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rateBps: $rateBps, ')
          ..write('isDefault: $isDefault, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalNameMeta =
      const VerificationMeta('legalName');
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
      'legal_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cuitMeta = const VerificationMeta('cuit');
  @override
  late final GeneratedColumn<String> cuit = GeneratedColumn<String>(
      'cuit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        legalName,
        cuit,
        phone,
        email,
        address,
        notes,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(Insertable<Supplier> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(_legalNameMeta,
          legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta));
    }
    if (data.containsKey('cuit')) {
      context.handle(
          _cuitMeta, cuit.isAcceptableOrUnknown(data['cuit']!, _cuitMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      legalName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_name']),
      cuit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cuit']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final String id;
  final String name;
  final String? legalName;
  final String? cuit;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Supplier(
      {required this.id,
      required this.name,
      this.legalName,
      this.cuit,
      this.phone,
      this.email,
      this.address,
      this.notes,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || legalName != null) {
      map['legal_name'] = Variable<String>(legalName);
    }
    if (!nullToAbsent || cuit != null) {
      map['cuit'] = Variable<String>(cuit);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      legalName: legalName == null && nullToAbsent
          ? const Value.absent()
          : Value(legalName),
      cuit: cuit == null && nullToAbsent ? const Value.absent() : Value(cuit),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Supplier.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      legalName: serializer.fromJson<String?>(json['legalName']),
      cuit: serializer.fromJson<String?>(json['cuit']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'legalName': serializer.toJson<String?>(legalName),
      'cuit': serializer.toJson<String?>(cuit),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Supplier copyWith(
          {String? id,
          String? name,
          Value<String?> legalName = const Value.absent(),
          Value<String?> cuit = const Value.absent(),
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Supplier(
        id: id ?? this.id,
        name: name ?? this.name,
        legalName: legalName.present ? legalName.value : this.legalName,
        cuit: cuit.present ? cuit.value : this.cuit,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      cuit: data.cuit.present ? data.cuit.value : this.cuit,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('legalName: $legalName, ')
          ..write('cuit: $cuit, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, legalName, cuit, phone, email,
      address, notes, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.legalName == this.legalName &&
          other.cuit == this.cuit &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> legalName;
  final Value<String?> cuit;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.legalName = const Value.absent(),
    this.cuit = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SuppliersCompanion.insert({
    required String id,
    required String name,
    this.legalName = const Value.absent(),
    this.cuit = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Supplier> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? legalName,
    Expression<String>? cuit,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (legalName != null) 'legal_name': legalName,
      if (cuit != null) 'cuit': cuit,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SuppliersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? legalName,
      Value<String?>? cuit,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      legalName: legalName ?? this.legalName,
      cuit: cuit ?? this.cuit,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (cuit.present) {
      map['cuit'] = Variable<String>(cuit.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('legalName: $legalName, ')
          ..write('cuit: $cuit, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _documentMeta =
      const VerificationMeta('document');
  @override
  late final GeneratedColumn<String> document = GeneratedColumn<String>(
      'document', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        phone,
        email,
        document,
        address,
        notes,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<Customer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('document')) {
      context.handle(_documentMeta,
          document.isAcceptableOrUnknown(data['document']!, _documentMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      document: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? document;
  final String? address;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Customer(
      {required this.id,
      required this.name,
      this.phone,
      this.email,
      this.document,
      this.address,
      this.notes,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || document != null) {
      map['document'] = Variable<String>(document);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone:
          phone == null && nullToAbsent ? const Value.absent() : Value(phone),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      document: document == null && nullToAbsent
          ? const Value.absent()
          : Value(document),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      document: serializer.fromJson<String?>(json['document']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'document': serializer.toJson<String?>(document),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith(
          {String? id,
          String? name,
          Value<String?> phone = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> document = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone.present ? phone.value : this.phone,
        email: email.present ? email.value : this.email,
        document: document.present ? document.value : this.document,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      document: data.document.present ? data.document.value : this.document,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('document: $document, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phone, email, document, address,
      notes, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.document == this.document &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> document;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.document = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.document = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? document,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (document != null) 'document': document,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? phone,
      Value<String?>? email,
      Value<String?>? document,
      Value<String?>? address,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      document: document ?? this.document,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (document.present) {
      map['document'] = Variable<String>(document.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('document: $document, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _internalCodeMeta =
      const VerificationMeta('internalCode');
  @override
  late final GeneratedColumn<String> internalCode = GeneratedColumn<String>(
      'internal_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _subcategoryMeta =
      const VerificationMeta('subcategory');
  @override
  late final GeneratedColumn<String> subcategory = GeneratedColumn<String>(
      'subcategory', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attributesJsonMeta =
      const VerificationMeta('attributesJson');
  @override
  late final GeneratedColumn<String> attributesJson = GeneratedColumn<String>(
      'attributes_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('unit'));
  static const VerificationMeta _unitsPerPackMeta =
      const VerificationMeta('unitsPerPack');
  @override
  late final GeneratedColumn<int> unitsPerPack = GeneratedColumn<int>(
      'units_per_pack', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _stockTotalMeta =
      const VerificationMeta('stockTotal');
  @override
  late final GeneratedColumn<int> stockTotal = GeneratedColumn<int>(
      'stock_total', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockReservedMeta =
      const VerificationMeta('stockReserved');
  @override
  late final GeneratedColumn<int> stockReserved = GeneratedColumn<int>(
      'stock_reserved', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockMinMeta =
      const VerificationMeta('stockMin');
  @override
  late final GeneratedColumn<int> stockMin = GeneratedColumn<int>(
      'stock_min', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stockMaxMeta =
      const VerificationMeta('stockMax');
  @override
  late final GeneratedColumn<int> stockMax = GeneratedColumn<int>(
      'stock_max', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _costCentsMeta =
      const VerificationMeta('costCents');
  @override
  late final GeneratedColumn<int> costCents = GeneratedColumn<int>(
      'cost_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _salePriceCentsMeta =
      const VerificationMeta('salePriceCents');
  @override
  late final GeneratedColumn<int> salePriceCents = GeneratedColumn<int>(
      'sale_price_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxProfileIdMeta =
      const VerificationMeta('taxProfileId');
  @override
  late final GeneratedColumn<String> taxProfileId = GeneratedColumn<String>(
      'tax_profile_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tax_profiles (id)'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        internalCode,
        barcode,
        name,
        categoryId,
        subcategory,
        brand,
        description,
        attributesJson,
        unit,
        unitsPerPack,
        stockTotal,
        stockReserved,
        stockMin,
        stockMax,
        costCents,
        salePriceCents,
        taxProfileId,
        isActive,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<Product> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('internal_code')) {
      context.handle(
          _internalCodeMeta,
          internalCode.isAcceptableOrUnknown(
              data['internal_code']!, _internalCodeMeta));
    } else if (isInserting) {
      context.missing(_internalCodeMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('subcategory')) {
      context.handle(
          _subcategoryMeta,
          subcategory.isAcceptableOrUnknown(
              data['subcategory']!, _subcategoryMeta));
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('attributes_json')) {
      context.handle(
          _attributesJsonMeta,
          attributesJson.isAcceptableOrUnknown(
              data['attributes_json']!, _attributesJsonMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('units_per_pack')) {
      context.handle(
          _unitsPerPackMeta,
          unitsPerPack.isAcceptableOrUnknown(
              data['units_per_pack']!, _unitsPerPackMeta));
    }
    if (data.containsKey('stock_total')) {
      context.handle(
          _stockTotalMeta,
          stockTotal.isAcceptableOrUnknown(
              data['stock_total']!, _stockTotalMeta));
    }
    if (data.containsKey('stock_reserved')) {
      context.handle(
          _stockReservedMeta,
          stockReserved.isAcceptableOrUnknown(
              data['stock_reserved']!, _stockReservedMeta));
    }
    if (data.containsKey('stock_min')) {
      context.handle(_stockMinMeta,
          stockMin.isAcceptableOrUnknown(data['stock_min']!, _stockMinMeta));
    }
    if (data.containsKey('stock_max')) {
      context.handle(_stockMaxMeta,
          stockMax.isAcceptableOrUnknown(data['stock_max']!, _stockMaxMeta));
    }
    if (data.containsKey('cost_cents')) {
      context.handle(_costCentsMeta,
          costCents.isAcceptableOrUnknown(data['cost_cents']!, _costCentsMeta));
    }
    if (data.containsKey('sale_price_cents')) {
      context.handle(
          _salePriceCentsMeta,
          salePriceCents.isAcceptableOrUnknown(
              data['sale_price_cents']!, _salePriceCentsMeta));
    }
    if (data.containsKey('tax_profile_id')) {
      context.handle(
          _taxProfileIdMeta,
          taxProfileId.isAcceptableOrUnknown(
              data['tax_profile_id']!, _taxProfileIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      internalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}internal_code'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      subcategory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subcategory']),
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      attributesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attributes_json']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      unitsPerPack: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}units_per_pack'])!,
      stockTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_total'])!,
      stockReserved: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_reserved'])!,
      stockMin: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_min'])!,
      stockMax: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_max']),
      costCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost_cents'])!,
      salePriceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_price_cents'])!,
      taxProfileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tax_profile_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String internalCode;
  final String? barcode;
  final String name;
  final String? categoryId;
  final String? subcategory;
  final String? brand;
  final String? description;
  final String? attributesJson;
  final String unit;
  final int unitsPerPack;
  final int stockTotal;
  final int stockReserved;
  final int stockMin;
  final int? stockMax;
  final int costCents;
  final int salePriceCents;
  final String? taxProfileId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product(
      {required this.id,
      required this.internalCode,
      this.barcode,
      required this.name,
      this.categoryId,
      this.subcategory,
      this.brand,
      this.description,
      this.attributesJson,
      required this.unit,
      required this.unitsPerPack,
      required this.stockTotal,
      required this.stockReserved,
      required this.stockMin,
      this.stockMax,
      required this.costCents,
      required this.salePriceCents,
      this.taxProfileId,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['internal_code'] = Variable<String>(internalCode);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || subcategory != null) {
      map['subcategory'] = Variable<String>(subcategory);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || attributesJson != null) {
      map['attributes_json'] = Variable<String>(attributesJson);
    }
    map['unit'] = Variable<String>(unit);
    map['units_per_pack'] = Variable<int>(unitsPerPack);
    map['stock_total'] = Variable<int>(stockTotal);
    map['stock_reserved'] = Variable<int>(stockReserved);
    map['stock_min'] = Variable<int>(stockMin);
    if (!nullToAbsent || stockMax != null) {
      map['stock_max'] = Variable<int>(stockMax);
    }
    map['cost_cents'] = Variable<int>(costCents);
    map['sale_price_cents'] = Variable<int>(salePriceCents);
    if (!nullToAbsent || taxProfileId != null) {
      map['tax_profile_id'] = Variable<String>(taxProfileId);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      internalCode: Value(internalCode),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      name: Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      subcategory: subcategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subcategory),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      attributesJson: attributesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attributesJson),
      unit: Value(unit),
      unitsPerPack: Value(unitsPerPack),
      stockTotal: Value(stockTotal),
      stockReserved: Value(stockReserved),
      stockMin: Value(stockMin),
      stockMax: stockMax == null && nullToAbsent
          ? const Value.absent()
          : Value(stockMax),
      costCents: Value(costCents),
      salePriceCents: Value(salePriceCents),
      taxProfileId: taxProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(taxProfileId),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      internalCode: serializer.fromJson<String>(json['internalCode']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      subcategory: serializer.fromJson<String?>(json['subcategory']),
      brand: serializer.fromJson<String?>(json['brand']),
      description: serializer.fromJson<String?>(json['description']),
      attributesJson: serializer.fromJson<String?>(json['attributesJson']),
      unit: serializer.fromJson<String>(json['unit']),
      unitsPerPack: serializer.fromJson<int>(json['unitsPerPack']),
      stockTotal: serializer.fromJson<int>(json['stockTotal']),
      stockReserved: serializer.fromJson<int>(json['stockReserved']),
      stockMin: serializer.fromJson<int>(json['stockMin']),
      stockMax: serializer.fromJson<int?>(json['stockMax']),
      costCents: serializer.fromJson<int>(json['costCents']),
      salePriceCents: serializer.fromJson<int>(json['salePriceCents']),
      taxProfileId: serializer.fromJson<String?>(json['taxProfileId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'internalCode': serializer.toJson<String>(internalCode),
      'barcode': serializer.toJson<String?>(barcode),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String?>(categoryId),
      'subcategory': serializer.toJson<String?>(subcategory),
      'brand': serializer.toJson<String?>(brand),
      'description': serializer.toJson<String?>(description),
      'attributesJson': serializer.toJson<String?>(attributesJson),
      'unit': serializer.toJson<String>(unit),
      'unitsPerPack': serializer.toJson<int>(unitsPerPack),
      'stockTotal': serializer.toJson<int>(stockTotal),
      'stockReserved': serializer.toJson<int>(stockReserved),
      'stockMin': serializer.toJson<int>(stockMin),
      'stockMax': serializer.toJson<int?>(stockMax),
      'costCents': serializer.toJson<int>(costCents),
      'salePriceCents': serializer.toJson<int>(salePriceCents),
      'taxProfileId': serializer.toJson<String?>(taxProfileId),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith(
          {String? id,
          String? internalCode,
          Value<String?> barcode = const Value.absent(),
          String? name,
          Value<String?> categoryId = const Value.absent(),
          Value<String?> subcategory = const Value.absent(),
          Value<String?> brand = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> attributesJson = const Value.absent(),
          String? unit,
          int? unitsPerPack,
          int? stockTotal,
          int? stockReserved,
          int? stockMin,
          Value<int?> stockMax = const Value.absent(),
          int? costCents,
          int? salePriceCents,
          Value<String?> taxProfileId = const Value.absent(),
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Product(
        id: id ?? this.id,
        internalCode: internalCode ?? this.internalCode,
        barcode: barcode.present ? barcode.value : this.barcode,
        name: name ?? this.name,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        subcategory: subcategory.present ? subcategory.value : this.subcategory,
        brand: brand.present ? brand.value : this.brand,
        description: description.present ? description.value : this.description,
        attributesJson:
            attributesJson.present ? attributesJson.value : this.attributesJson,
        unit: unit ?? this.unit,
        unitsPerPack: unitsPerPack ?? this.unitsPerPack,
        stockTotal: stockTotal ?? this.stockTotal,
        stockReserved: stockReserved ?? this.stockReserved,
        stockMin: stockMin ?? this.stockMin,
        stockMax: stockMax.present ? stockMax.value : this.stockMax,
        costCents: costCents ?? this.costCents,
        salePriceCents: salePriceCents ?? this.salePriceCents,
        taxProfileId:
            taxProfileId.present ? taxProfileId.value : this.taxProfileId,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      internalCode: data.internalCode.present
          ? data.internalCode.value
          : this.internalCode,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      name: data.name.present ? data.name.value : this.name,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      subcategory:
          data.subcategory.present ? data.subcategory.value : this.subcategory,
      brand: data.brand.present ? data.brand.value : this.brand,
      description:
          data.description.present ? data.description.value : this.description,
      attributesJson: data.attributesJson.present
          ? data.attributesJson.value
          : this.attributesJson,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitsPerPack: data.unitsPerPack.present
          ? data.unitsPerPack.value
          : this.unitsPerPack,
      stockTotal:
          data.stockTotal.present ? data.stockTotal.value : this.stockTotal,
      stockReserved: data.stockReserved.present
          ? data.stockReserved.value
          : this.stockReserved,
      stockMin: data.stockMin.present ? data.stockMin.value : this.stockMin,
      stockMax: data.stockMax.present ? data.stockMax.value : this.stockMax,
      costCents: data.costCents.present ? data.costCents.value : this.costCents,
      salePriceCents: data.salePriceCents.present
          ? data.salePriceCents.value
          : this.salePriceCents,
      taxProfileId: data.taxProfileId.present
          ? data.taxProfileId.value
          : this.taxProfileId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('internalCode: $internalCode, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategory: $subcategory, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('attributesJson: $attributesJson, ')
          ..write('unit: $unit, ')
          ..write('unitsPerPack: $unitsPerPack, ')
          ..write('stockTotal: $stockTotal, ')
          ..write('stockReserved: $stockReserved, ')
          ..write('stockMin: $stockMin, ')
          ..write('stockMax: $stockMax, ')
          ..write('costCents: $costCents, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('taxProfileId: $taxProfileId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        internalCode,
        barcode,
        name,
        categoryId,
        subcategory,
        brand,
        description,
        attributesJson,
        unit,
        unitsPerPack,
        stockTotal,
        stockReserved,
        stockMin,
        stockMax,
        costCents,
        salePriceCents,
        taxProfileId,
        isActive,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.internalCode == this.internalCode &&
          other.barcode == this.barcode &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.subcategory == this.subcategory &&
          other.brand == this.brand &&
          other.description == this.description &&
          other.attributesJson == this.attributesJson &&
          other.unit == this.unit &&
          other.unitsPerPack == this.unitsPerPack &&
          other.stockTotal == this.stockTotal &&
          other.stockReserved == this.stockReserved &&
          other.stockMin == this.stockMin &&
          other.stockMax == this.stockMax &&
          other.costCents == this.costCents &&
          other.salePriceCents == this.salePriceCents &&
          other.taxProfileId == this.taxProfileId &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> internalCode;
  final Value<String?> barcode;
  final Value<String> name;
  final Value<String?> categoryId;
  final Value<String?> subcategory;
  final Value<String?> brand;
  final Value<String?> description;
  final Value<String?> attributesJson;
  final Value<String> unit;
  final Value<int> unitsPerPack;
  final Value<int> stockTotal;
  final Value<int> stockReserved;
  final Value<int> stockMin;
  final Value<int?> stockMax;
  final Value<int> costCents;
  final Value<int> salePriceCents;
  final Value<String?> taxProfileId;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.internalCode = const Value.absent(),
    this.barcode = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.attributesJson = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitsPerPack = const Value.absent(),
    this.stockTotal = const Value.absent(),
    this.stockReserved = const Value.absent(),
    this.stockMin = const Value.absent(),
    this.stockMax = const Value.absent(),
    this.costCents = const Value.absent(),
    this.salePriceCents = const Value.absent(),
    this.taxProfileId = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String internalCode,
    this.barcode = const Value.absent(),
    required String name,
    this.categoryId = const Value.absent(),
    this.subcategory = const Value.absent(),
    this.brand = const Value.absent(),
    this.description = const Value.absent(),
    this.attributesJson = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitsPerPack = const Value.absent(),
    this.stockTotal = const Value.absent(),
    this.stockReserved = const Value.absent(),
    this.stockMin = const Value.absent(),
    this.stockMax = const Value.absent(),
    this.costCents = const Value.absent(),
    this.salePriceCents = const Value.absent(),
    this.taxProfileId = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        internalCode = Value(internalCode),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? internalCode,
    Expression<String>? barcode,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? subcategory,
    Expression<String>? brand,
    Expression<String>? description,
    Expression<String>? attributesJson,
    Expression<String>? unit,
    Expression<int>? unitsPerPack,
    Expression<int>? stockTotal,
    Expression<int>? stockReserved,
    Expression<int>? stockMin,
    Expression<int>? stockMax,
    Expression<int>? costCents,
    Expression<int>? salePriceCents,
    Expression<String>? taxProfileId,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (internalCode != null) 'internal_code': internalCode,
      if (barcode != null) 'barcode': barcode,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (subcategory != null) 'subcategory': subcategory,
      if (brand != null) 'brand': brand,
      if (description != null) 'description': description,
      if (attributesJson != null) 'attributes_json': attributesJson,
      if (unit != null) 'unit': unit,
      if (unitsPerPack != null) 'units_per_pack': unitsPerPack,
      if (stockTotal != null) 'stock_total': stockTotal,
      if (stockReserved != null) 'stock_reserved': stockReserved,
      if (stockMin != null) 'stock_min': stockMin,
      if (stockMax != null) 'stock_max': stockMax,
      if (costCents != null) 'cost_cents': costCents,
      if (salePriceCents != null) 'sale_price_cents': salePriceCents,
      if (taxProfileId != null) 'tax_profile_id': taxProfileId,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String>? internalCode,
      Value<String?>? barcode,
      Value<String>? name,
      Value<String?>? categoryId,
      Value<String?>? subcategory,
      Value<String?>? brand,
      Value<String?>? description,
      Value<String?>? attributesJson,
      Value<String>? unit,
      Value<int>? unitsPerPack,
      Value<int>? stockTotal,
      Value<int>? stockReserved,
      Value<int>? stockMin,
      Value<int?>? stockMax,
      Value<int>? costCents,
      Value<int>? salePriceCents,
      Value<String?>? taxProfileId,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ProductsCompanion(
      id: id ?? this.id,
      internalCode: internalCode ?? this.internalCode,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      subcategory: subcategory ?? this.subcategory,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      attributesJson: attributesJson ?? this.attributesJson,
      unit: unit ?? this.unit,
      unitsPerPack: unitsPerPack ?? this.unitsPerPack,
      stockTotal: stockTotal ?? this.stockTotal,
      stockReserved: stockReserved ?? this.stockReserved,
      stockMin: stockMin ?? this.stockMin,
      stockMax: stockMax ?? this.stockMax,
      costCents: costCents ?? this.costCents,
      salePriceCents: salePriceCents ?? this.salePriceCents,
      taxProfileId: taxProfileId ?? this.taxProfileId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (internalCode.present) {
      map['internal_code'] = Variable<String>(internalCode.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (subcategory.present) {
      map['subcategory'] = Variable<String>(subcategory.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (attributesJson.present) {
      map['attributes_json'] = Variable<String>(attributesJson.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitsPerPack.present) {
      map['units_per_pack'] = Variable<int>(unitsPerPack.value);
    }
    if (stockTotal.present) {
      map['stock_total'] = Variable<int>(stockTotal.value);
    }
    if (stockReserved.present) {
      map['stock_reserved'] = Variable<int>(stockReserved.value);
    }
    if (stockMin.present) {
      map['stock_min'] = Variable<int>(stockMin.value);
    }
    if (stockMax.present) {
      map['stock_max'] = Variable<int>(stockMax.value);
    }
    if (costCents.present) {
      map['cost_cents'] = Variable<int>(costCents.value);
    }
    if (salePriceCents.present) {
      map['sale_price_cents'] = Variable<int>(salePriceCents.value);
    }
    if (taxProfileId.present) {
      map['tax_profile_id'] = Variable<String>(taxProfileId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('internalCode: $internalCode, ')
          ..write('barcode: $barcode, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategory: $subcategory, ')
          ..write('brand: $brand, ')
          ..write('description: $description, ')
          ..write('attributesJson: $attributesJson, ')
          ..write('unit: $unit, ')
          ..write('unitsPerPack: $unitsPerPack, ')
          ..write('stockTotal: $stockTotal, ')
          ..write('stockReserved: $stockReserved, ')
          ..write('stockMin: $stockMin, ')
          ..write('stockMax: $stockMax, ')
          ..write('costCents: $costCents, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('taxProfileId: $taxProfileId, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductBatchesTable extends ProductBatches
    with TableInfo<$ProductBatchesTable, ProductBatche> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _batchCodeMeta =
      const VerificationMeta('batchCode');
  @override
  late final GeneratedColumn<String> batchCode = GeneratedColumn<String>(
      'batch_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _receivedAtMeta =
      const VerificationMeta('receivedAt');
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
      'received_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiresAtMeta =
      const VerificationMeta('expiresAt');
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
      'expires_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _quantityTotalMeta =
      const VerificationMeta('quantityTotal');
  @override
  late final GeneratedColumn<int> quantityTotal = GeneratedColumn<int>(
      'quantity_total', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityReservedMeta =
      const VerificationMeta('quantityReserved');
  @override
  late final GeneratedColumn<int> quantityReserved = GeneratedColumn<int>(
      'quantity_reserved', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitCostCentsMeta =
      const VerificationMeta('unitCostCents');
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
      'unit_cost_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('active'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        batchCode,
        supplierId,
        receivedAt,
        expiresAt,
        quantityTotal,
        quantityReserved,
        unitCostCents,
        status,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_batches';
  @override
  VerificationContext validateIntegrity(Insertable<ProductBatche> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('batch_code')) {
      context.handle(_batchCodeMeta,
          batchCode.isAcceptableOrUnknown(data['batch_code']!, _batchCodeMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('received_at')) {
      context.handle(
          _receivedAtMeta,
          receivedAt.isAcceptableOrUnknown(
              data['received_at']!, _receivedAtMeta));
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(_expiresAtMeta,
          expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta));
    }
    if (data.containsKey('quantity_total')) {
      context.handle(
          _quantityTotalMeta,
          quantityTotal.isAcceptableOrUnknown(
              data['quantity_total']!, _quantityTotalMeta));
    } else if (isInserting) {
      context.missing(_quantityTotalMeta);
    }
    if (data.containsKey('quantity_reserved')) {
      context.handle(
          _quantityReservedMeta,
          quantityReserved.isAcceptableOrUnknown(
              data['quantity_reserved']!, _quantityReservedMeta));
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
          _unitCostCentsMeta,
          unitCostCents.isAcceptableOrUnknown(
              data['unit_cost_cents']!, _unitCostCentsMeta));
    } else if (isInserting) {
      context.missing(_unitCostCentsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductBatche map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductBatche(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      batchCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_code']),
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id']),
      receivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}received_at'])!,
      expiresAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expires_at']),
      quantityTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_total'])!,
      quantityReserved: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_reserved'])!,
      unitCostCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_cents'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ProductBatchesTable createAlias(String alias) {
    return $ProductBatchesTable(attachedDatabase, alias);
  }
}

class ProductBatche extends DataClass implements Insertable<ProductBatche> {
  final String id;
  final String productId;
  final String? batchCode;
  final String? supplierId;
  final DateTime receivedAt;
  final DateTime? expiresAt;
  final int quantityTotal;
  final int quantityReserved;
  final int unitCostCents;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProductBatche(
      {required this.id,
      required this.productId,
      this.batchCode,
      this.supplierId,
      required this.receivedAt,
      this.expiresAt,
      required this.quantityTotal,
      required this.quantityReserved,
      required this.unitCostCents,
      required this.status,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || batchCode != null) {
      map['batch_code'] = Variable<String>(batchCode);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['received_at'] = Variable<DateTime>(receivedAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['quantity_total'] = Variable<int>(quantityTotal);
    map['quantity_reserved'] = Variable<int>(quantityReserved);
    map['unit_cost_cents'] = Variable<int>(unitCostCents);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductBatchesCompanion toCompanion(bool nullToAbsent) {
    return ProductBatchesCompanion(
      id: Value(id),
      productId: Value(productId),
      batchCode: batchCode == null && nullToAbsent
          ? const Value.absent()
          : Value(batchCode),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      receivedAt: Value(receivedAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      quantityTotal: Value(quantityTotal),
      quantityReserved: Value(quantityReserved),
      unitCostCents: Value(unitCostCents),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProductBatche.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductBatche(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      batchCode: serializer.fromJson<String?>(json['batchCode']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      quantityTotal: serializer.fromJson<int>(json['quantityTotal']),
      quantityReserved: serializer.fromJson<int>(json['quantityReserved']),
      unitCostCents: serializer.fromJson<int>(json['unitCostCents']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'batchCode': serializer.toJson<String?>(batchCode),
      'supplierId': serializer.toJson<String?>(supplierId),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'quantityTotal': serializer.toJson<int>(quantityTotal),
      'quantityReserved': serializer.toJson<int>(quantityReserved),
      'unitCostCents': serializer.toJson<int>(unitCostCents),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProductBatche copyWith(
          {String? id,
          String? productId,
          Value<String?> batchCode = const Value.absent(),
          Value<String?> supplierId = const Value.absent(),
          DateTime? receivedAt,
          Value<DateTime?> expiresAt = const Value.absent(),
          int? quantityTotal,
          int? quantityReserved,
          int? unitCostCents,
          String? status,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ProductBatche(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        batchCode: batchCode.present ? batchCode.value : this.batchCode,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        receivedAt: receivedAt ?? this.receivedAt,
        expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
        quantityTotal: quantityTotal ?? this.quantityTotal,
        quantityReserved: quantityReserved ?? this.quantityReserved,
        unitCostCents: unitCostCents ?? this.unitCostCents,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ProductBatche copyWithCompanion(ProductBatchesCompanion data) {
    return ProductBatche(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      batchCode: data.batchCode.present ? data.batchCode.value : this.batchCode,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      quantityTotal: data.quantityTotal.present
          ? data.quantityTotal.value
          : this.quantityTotal,
      quantityReserved: data.quantityReserved.present
          ? data.quantityReserved.value
          : this.quantityReserved,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductBatche(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchCode: $batchCode, ')
          ..write('supplierId: $supplierId, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('quantityTotal: $quantityTotal, ')
          ..write('quantityReserved: $quantityReserved, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productId,
      batchCode,
      supplierId,
      receivedAt,
      expiresAt,
      quantityTotal,
      quantityReserved,
      unitCostCents,
      status,
      notes,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductBatche &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.batchCode == this.batchCode &&
          other.supplierId == this.supplierId &&
          other.receivedAt == this.receivedAt &&
          other.expiresAt == this.expiresAt &&
          other.quantityTotal == this.quantityTotal &&
          other.quantityReserved == this.quantityReserved &&
          other.unitCostCents == this.unitCostCents &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductBatchesCompanion extends UpdateCompanion<ProductBatche> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> batchCode;
  final Value<String?> supplierId;
  final Value<DateTime> receivedAt;
  final Value<DateTime?> expiresAt;
  final Value<int> quantityTotal;
  final Value<int> quantityReserved;
  final Value<int> unitCostCents;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProductBatchesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.batchCode = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.quantityTotal = const Value.absent(),
    this.quantityReserved = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductBatchesCompanion.insert({
    required String id,
    required String productId,
    this.batchCode = const Value.absent(),
    this.supplierId = const Value.absent(),
    required DateTime receivedAt,
    this.expiresAt = const Value.absent(),
    required int quantityTotal,
    this.quantityReserved = const Value.absent(),
    required int unitCostCents,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        receivedAt = Value(receivedAt),
        quantityTotal = Value(quantityTotal),
        unitCostCents = Value(unitCostCents),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ProductBatche> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? batchCode,
    Expression<String>? supplierId,
    Expression<DateTime>? receivedAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? quantityTotal,
    Expression<int>? quantityReserved,
    Expression<int>? unitCostCents,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (batchCode != null) 'batch_code': batchCode,
      if (supplierId != null) 'supplier_id': supplierId,
      if (receivedAt != null) 'received_at': receivedAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (quantityTotal != null) 'quantity_total': quantityTotal,
      if (quantityReserved != null) 'quantity_reserved': quantityReserved,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductBatchesCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String?>? batchCode,
      Value<String?>? supplierId,
      Value<DateTime>? receivedAt,
      Value<DateTime?>? expiresAt,
      Value<int>? quantityTotal,
      Value<int>? quantityReserved,
      Value<int>? unitCostCents,
      Value<String>? status,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ProductBatchesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      batchCode: batchCode ?? this.batchCode,
      supplierId: supplierId ?? this.supplierId,
      receivedAt: receivedAt ?? this.receivedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      quantityTotal: quantityTotal ?? this.quantityTotal,
      quantityReserved: quantityReserved ?? this.quantityReserved,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (batchCode.present) {
      map['batch_code'] = Variable<String>(batchCode.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (quantityTotal.present) {
      map['quantity_total'] = Variable<int>(quantityTotal.value);
    }
    if (quantityReserved.present) {
      map['quantity_reserved'] = Variable<int>(quantityReserved.value);
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductBatchesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchCode: $batchCode, ')
          ..write('supplierId: $supplierId, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('quantityTotal: $quantityTotal, ')
          ..write('quantityReserved: $quantityReserved, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTable extends Purchases
    with TableInfo<$PurchasesTable, Purchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _subtotalCentsMeta =
      const VerificationMeta('subtotalCents');
  @override
  late final GeneratedColumn<int> subtotalCents = GeneratedColumn<int>(
      'subtotal_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxCentsMeta =
      const VerificationMeta('taxCents');
  @override
  late final GeneratedColumn<int> taxCents = GeneratedColumn<int>(
      'tax_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalCentsMeta =
      const VerificationMeta('totalCents');
  @override
  late final GeneratedColumn<int> totalCents = GeneratedColumn<int>(
      'total_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        supplierId,
        status,
        subtotalCents,
        taxCents,
        totalCents,
        notes,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases';
  @override
  VerificationContext validateIntegrity(Insertable<Purchase> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('subtotal_cents')) {
      context.handle(
          _subtotalCentsMeta,
          subtotalCents.isAcceptableOrUnknown(
              data['subtotal_cents']!, _subtotalCentsMeta));
    }
    if (data.containsKey('tax_cents')) {
      context.handle(_taxCentsMeta,
          taxCents.isAcceptableOrUnknown(data['tax_cents']!, _taxCentsMeta));
    }
    if (data.containsKey('total_cents')) {
      context.handle(
          _totalCentsMeta,
          totalCents.isAcceptableOrUnknown(
              data['total_cents']!, _totalCentsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Purchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Purchase(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      subtotalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtotal_cents'])!,
      taxCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_cents'])!,
      totalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_cents'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PurchasesTable createAlias(String alias) {
    return $PurchasesTable(attachedDatabase, alias);
  }
}

class Purchase extends DataClass implements Insertable<Purchase> {
  final String id;
  final String? supplierId;
  final String status;
  final int subtotalCents;
  final int taxCents;
  final int totalCents;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Purchase(
      {required this.id,
      this.supplierId,
      required this.status,
      required this.subtotalCents,
      required this.taxCents,
      required this.totalCents,
      this.notes,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['status'] = Variable<String>(status);
    map['subtotal_cents'] = Variable<int>(subtotalCents);
    map['tax_cents'] = Variable<int>(taxCents);
    map['total_cents'] = Variable<int>(totalCents);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PurchasesCompanion toCompanion(bool nullToAbsent) {
    return PurchasesCompanion(
      id: Value(id),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      status: Value(status),
      subtotalCents: Value(subtotalCents),
      taxCents: Value(taxCents),
      totalCents: Value(totalCents),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Purchase.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Purchase(
      id: serializer.fromJson<String>(json['id']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      status: serializer.fromJson<String>(json['status']),
      subtotalCents: serializer.fromJson<int>(json['subtotalCents']),
      taxCents: serializer.fromJson<int>(json['taxCents']),
      totalCents: serializer.fromJson<int>(json['totalCents']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'supplierId': serializer.toJson<String?>(supplierId),
      'status': serializer.toJson<String>(status),
      'subtotalCents': serializer.toJson<int>(subtotalCents),
      'taxCents': serializer.toJson<int>(taxCents),
      'totalCents': serializer.toJson<int>(totalCents),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Purchase copyWith(
          {String? id,
          Value<String?> supplierId = const Value.absent(),
          String? status,
          int? subtotalCents,
          int? taxCents,
          int? totalCents,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Purchase(
        id: id ?? this.id,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        status: status ?? this.status,
        subtotalCents: subtotalCents ?? this.subtotalCents,
        taxCents: taxCents ?? this.taxCents,
        totalCents: totalCents ?? this.totalCents,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Purchase copyWithCompanion(PurchasesCompanion data) {
    return Purchase(
      id: data.id.present ? data.id.value : this.id,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      status: data.status.present ? data.status.value : this.status,
      subtotalCents: data.subtotalCents.present
          ? data.subtotalCents.value
          : this.subtotalCents,
      taxCents: data.taxCents.present ? data.taxCents.value : this.taxCents,
      totalCents:
          data.totalCents.present ? data.totalCents.value : this.totalCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Purchase(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('status: $status, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('totalCents: $totalCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, supplierId, status, subtotalCents,
      taxCents, totalCents, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Purchase &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.status == this.status &&
          other.subtotalCents == this.subtotalCents &&
          other.taxCents == this.taxCents &&
          other.totalCents == this.totalCents &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PurchasesCompanion extends UpdateCompanion<Purchase> {
  final Value<String> id;
  final Value<String?> supplierId;
  final Value<String> status;
  final Value<int> subtotalCents;
  final Value<int> taxCents;
  final Value<int> totalCents;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PurchasesCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotalCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesCompanion.insert({
    required String id,
    this.supplierId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotalCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Purchase> custom({
    Expression<String>? id,
    Expression<String>? supplierId,
    Expression<String>? status,
    Expression<int>? subtotalCents,
    Expression<int>? taxCents,
    Expression<int>? totalCents,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (status != null) 'status': status,
      if (subtotalCents != null) 'subtotal_cents': subtotalCents,
      if (taxCents != null) 'tax_cents': taxCents,
      if (totalCents != null) 'total_cents': totalCents,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? supplierId,
      Value<String>? status,
      Value<int>? subtotalCents,
      Value<int>? taxCents,
      Value<int>? totalCents,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PurchasesCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      status: status ?? this.status,
      subtotalCents: subtotalCents ?? this.subtotalCents,
      taxCents: taxCents ?? this.taxCents,
      totalCents: totalCents ?? this.totalCents,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subtotalCents.present) {
      map['subtotal_cents'] = Variable<int>(subtotalCents.value);
    }
    if (taxCents.present) {
      map['tax_cents'] = Variable<int>(taxCents.value);
    }
    if (totalCents.present) {
      map['total_cents'] = Variable<int>(totalCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('status: $status, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('totalCents: $totalCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTable extends PurchaseItems
    with TableInfo<$PurchaseItemsTable, PurchaseItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES purchases (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostCentsMeta =
      const VerificationMeta('unitCostCents');
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
      'unit_cost_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxRateBpsMeta =
      const VerificationMeta('taxRateBps');
  @override
  late final GeneratedColumn<int> taxRateBps = GeneratedColumn<int>(
      'tax_rate_bps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalCentsMeta =
      const VerificationMeta('lineTotalCents');
  @override
  late final GeneratedColumn<int> lineTotalCents = GeneratedColumn<int>(
      'line_total_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_batches (id)'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        purchaseId,
        productId,
        quantity,
        unitCostCents,
        taxRateBps,
        lineTotalCents,
        batchId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items';
  @override
  VerificationContext validateIntegrity(Insertable<PurchaseItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
          _unitCostCentsMeta,
          unitCostCents.isAcceptableOrUnknown(
              data['unit_cost_cents']!, _unitCostCentsMeta));
    } else if (isInserting) {
      context.missing(_unitCostCentsMeta);
    }
    if (data.containsKey('tax_rate_bps')) {
      context.handle(
          _taxRateBpsMeta,
          taxRateBps.isAcceptableOrUnknown(
              data['tax_rate_bps']!, _taxRateBpsMeta));
    }
    if (data.containsKey('line_total_cents')) {
      context.handle(
          _lineTotalCentsMeta,
          lineTotalCents.isAcceptableOrUnknown(
              data['line_total_cents']!, _lineTotalCentsMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitCostCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_cents'])!,
      taxRateBps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_rate_bps'])!,
      lineTotalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total_cents'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id']),
    );
  }

  @override
  $PurchaseItemsTable createAlias(String alias) {
    return $PurchaseItemsTable(attachedDatabase, alias);
  }
}

class PurchaseItem extends DataClass implements Insertable<PurchaseItem> {
  final String id;
  final String purchaseId;
  final String productId;
  final int quantity;
  final int unitCostCents;
  final int taxRateBps;
  final int lineTotalCents;
  final String? batchId;
  const PurchaseItem(
      {required this.id,
      required this.purchaseId,
      required this.productId,
      required this.quantity,
      required this.unitCostCents,
      required this.taxRateBps,
      required this.lineTotalCents,
      this.batchId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_cost_cents'] = Variable<int>(unitCostCents);
    map['tax_rate_bps'] = Variable<int>(taxRateBps);
    map['line_total_cents'] = Variable<int>(lineTotalCents);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    return map;
  }

  PurchaseItemsCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitCostCents: Value(unitCostCents),
      taxRateBps: Value(taxRateBps),
      lineTotalCents: Value(lineTotalCents),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
    );
  }

  factory PurchaseItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItem(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitCostCents: serializer.fromJson<int>(json['unitCostCents']),
      taxRateBps: serializer.fromJson<int>(json['taxRateBps']),
      lineTotalCents: serializer.fromJson<int>(json['lineTotalCents']),
      batchId: serializer.fromJson<String?>(json['batchId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitCostCents': serializer.toJson<int>(unitCostCents),
      'taxRateBps': serializer.toJson<int>(taxRateBps),
      'lineTotalCents': serializer.toJson<int>(lineTotalCents),
      'batchId': serializer.toJson<String?>(batchId),
    };
  }

  PurchaseItem copyWith(
          {String? id,
          String? purchaseId,
          String? productId,
          int? quantity,
          int? unitCostCents,
          int? taxRateBps,
          int? lineTotalCents,
          Value<String?> batchId = const Value.absent()}) =>
      PurchaseItem(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitCostCents: unitCostCents ?? this.unitCostCents,
        taxRateBps: taxRateBps ?? this.taxRateBps,
        lineTotalCents: lineTotalCents ?? this.lineTotalCents,
        batchId: batchId.present ? batchId.value : this.batchId,
      );
  PurchaseItem copyWithCompanion(PurchaseItemsCompanion data) {
    return PurchaseItem(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      taxRateBps:
          data.taxRateBps.present ? data.taxRateBps.value : this.taxRateBps,
      lineTotalCents: data.lineTotalCents.present
          ? data.lineTotalCents.value
          : this.lineTotalCents,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItem(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('lineTotalCents: $lineTotalCents, ')
          ..write('batchId: $batchId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseId, productId, quantity,
      unitCostCents, taxRateBps, lineTotalCents, batchId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItem &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitCostCents == this.unitCostCents &&
          other.taxRateBps == this.taxRateBps &&
          other.lineTotalCents == this.lineTotalCents &&
          other.batchId == this.batchId);
}

class PurchaseItemsCompanion extends UpdateCompanion<PurchaseItem> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<String> productId;
  final Value<int> quantity;
  final Value<int> unitCostCents;
  final Value<int> taxRateBps;
  final Value<int> lineTotalCents;
  final Value<String?> batchId;
  final Value<int> rowid;
  const PurchaseItemsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.taxRateBps = const Value.absent(),
    this.lineTotalCents = const Value.absent(),
    this.batchId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseItemsCompanion.insert({
    required String id,
    required String purchaseId,
    required String productId,
    required int quantity,
    required int unitCostCents,
    this.taxRateBps = const Value.absent(),
    this.lineTotalCents = const Value.absent(),
    this.batchId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchaseId = Value(purchaseId),
        productId = Value(productId),
        quantity = Value(quantity),
        unitCostCents = Value(unitCostCents);
  static Insertable<PurchaseItem> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<int>? unitCostCents,
    Expression<int>? taxRateBps,
    Expression<int>? lineTotalCents,
    Expression<String>? batchId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (taxRateBps != null) 'tax_rate_bps': taxRateBps,
      if (lineTotalCents != null) 'line_total_cents': lineTotalCents,
      if (batchId != null) 'batch_id': batchId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? purchaseId,
      Value<String>? productId,
      Value<int>? quantity,
      Value<int>? unitCostCents,
      Value<int>? taxRateBps,
      Value<int>? lineTotalCents,
      Value<String?>? batchId,
      Value<int>? rowid}) {
    return PurchaseItemsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      taxRateBps: taxRateBps ?? this.taxRateBps,
      lineTotalCents: lineTotalCents ?? this.lineTotalCents,
      batchId: batchId ?? this.batchId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (taxRateBps.present) {
      map['tax_rate_bps'] = Variable<int>(taxRateBps.value);
    }
    if (lineTotalCents.present) {
      map['line_total_cents'] = Variable<int>(lineTotalCents.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('lineTotalCents: $lineTotalCents, ')
          ..write('batchId: $batchId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReservationsTable extends Reservations
    with TableInfo<$ReservationsTable, Reservation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _canceledAtMeta =
      const VerificationMeta('canceledAt');
  @override
  late final GeneratedColumn<DateTime> canceledAt = GeneratedColumn<DateTime>(
      'canceled_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _confirmedAtMeta =
      const VerificationMeta('confirmedAt');
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
      'confirmed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerId,
        status,
        notes,
        createdAt,
        updatedAt,
        canceledAt,
        confirmedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservations';
  @override
  VerificationContext validateIntegrity(Insertable<Reservation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('canceled_at')) {
      context.handle(
          _canceledAtMeta,
          canceledAt.isAcceptableOrUnknown(
              data['canceled_at']!, _canceledAtMeta));
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
          _confirmedAtMeta,
          confirmedAt.isAcceptableOrUnknown(
              data['confirmed_at']!, _confirmedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reservation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reservation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      canceledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}canceled_at']),
      confirmedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}confirmed_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $ReservationsTable createAlias(String alias) {
    return $ReservationsTable(attachedDatabase, alias);
  }
}

class Reservation extends DataClass implements Insertable<Reservation> {
  final String id;
  final String? customerId;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? canceledAt;
  final DateTime? confirmedAt;
  final DateTime? deletedAt;
  const Reservation(
      {required this.id,
      this.customerId,
      required this.status,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.canceledAt,
      this.confirmedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || canceledAt != null) {
      map['canceled_at'] = Variable<DateTime>(canceledAt);
    }
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ReservationsCompanion toCompanion(bool nullToAbsent) {
    return ReservationsCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      status: Value(status),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      canceledAt: canceledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(canceledAt),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Reservation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reservation(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      canceledAt: serializer.fromJson<DateTime?>(json['canceledAt']),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'canceledAt': serializer.toJson<DateTime?>(canceledAt),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Reservation copyWith(
          {String? id,
          Value<String?> customerId = const Value.absent(),
          String? status,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> canceledAt = const Value.absent(),
          Value<DateTime?> confirmedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      Reservation(
        id: id ?? this.id,
        customerId: customerId.present ? customerId.value : this.customerId,
        status: status ?? this.status,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        canceledAt: canceledAt.present ? canceledAt.value : this.canceledAt,
        confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  Reservation copyWithCompanion(ReservationsCompanion data) {
    return Reservation(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      canceledAt:
          data.canceledAt.present ? data.canceledAt.value : this.canceledAt,
      confirmedAt:
          data.confirmedAt.present ? data.confirmedAt.value : this.confirmedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reservation(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('canceledAt: $canceledAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, customerId, status, notes, createdAt,
      updatedAt, canceledAt, confirmedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reservation &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.canceledAt == this.canceledAt &&
          other.confirmedAt == this.confirmedAt &&
          other.deletedAt == this.deletedAt);
}

class ReservationsCompanion extends UpdateCompanion<Reservation> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<String> status;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> canceledAt;
  final Value<DateTime?> confirmedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ReservationsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.canceledAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationsCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.canceledAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Reservation> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? canceledAt,
    Expression<DateTime>? confirmedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (canceledAt != null) 'canceled_at': canceledAt,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? customerId,
      Value<String>? status,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? canceledAt,
      Value<DateTime?>? confirmedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return ReservationsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (canceledAt.present) {
      map['canceled_at'] = Variable<DateTime>(canceledAt.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('canceledAt: $canceledAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReservationItemsTable extends ReservationItems
    with TableInfo<$ReservationItemsTable, ReservationItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReservationItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reservationIdMeta =
      const VerificationMeta('reservationId');
  @override
  late final GeneratedColumn<String> reservationId = GeneratedColumn<String>(
      'reservation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES reservations (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceCentsMeta =
      const VerificationMeta('unitPriceCents');
  @override
  late final GeneratedColumn<int> unitPriceCents = GeneratedColumn<int>(
      'unit_price_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitCostCentsMeta =
      const VerificationMeta('unitCostCents');
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
      'unit_cost_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxRateBpsMeta =
      const VerificationMeta('taxRateBps');
  @override
  late final GeneratedColumn<int> taxRateBps = GeneratedColumn<int>(
      'tax_rate_bps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountCentsMeta =
      const VerificationMeta('discountCents');
  @override
  late final GeneratedColumn<int> discountCents = GeneratedColumn<int>(
      'discount_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalCentsMeta =
      const VerificationMeta('lineTotalCents');
  @override
  late final GeneratedColumn<int> lineTotalCents = GeneratedColumn<int>(
      'line_total_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        reservationId,
        productId,
        quantity,
        unitPriceCents,
        unitCostCents,
        taxRateBps,
        discountCents,
        lineTotalCents
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reservation_items';
  @override
  VerificationContext validateIntegrity(Insertable<ReservationItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('reservation_id')) {
      context.handle(
          _reservationIdMeta,
          reservationId.isAcceptableOrUnknown(
              data['reservation_id']!, _reservationIdMeta));
    } else if (isInserting) {
      context.missing(_reservationIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_cents')) {
      context.handle(
          _unitPriceCentsMeta,
          unitPriceCents.isAcceptableOrUnknown(
              data['unit_price_cents']!, _unitPriceCentsMeta));
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
          _unitCostCentsMeta,
          unitCostCents.isAcceptableOrUnknown(
              data['unit_cost_cents']!, _unitCostCentsMeta));
    }
    if (data.containsKey('tax_rate_bps')) {
      context.handle(
          _taxRateBpsMeta,
          taxRateBps.isAcceptableOrUnknown(
              data['tax_rate_bps']!, _taxRateBpsMeta));
    }
    if (data.containsKey('discount_cents')) {
      context.handle(
          _discountCentsMeta,
          discountCents.isAcceptableOrUnknown(
              data['discount_cents']!, _discountCentsMeta));
    }
    if (data.containsKey('line_total_cents')) {
      context.handle(
          _lineTotalCentsMeta,
          lineTotalCents.isAcceptableOrUnknown(
              data['line_total_cents']!, _lineTotalCentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReservationItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReservationItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      reservationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reservation_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitPriceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_price_cents'])!,
      unitCostCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_cents'])!,
      taxRateBps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_rate_bps'])!,
      discountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_cents'])!,
      lineTotalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total_cents'])!,
    );
  }

  @override
  $ReservationItemsTable createAlias(String alias) {
    return $ReservationItemsTable(attachedDatabase, alias);
  }
}

class ReservationItem extends DataClass implements Insertable<ReservationItem> {
  final String id;
  final String reservationId;
  final String productId;
  final int quantity;
  final int unitPriceCents;
  final int unitCostCents;
  final int taxRateBps;
  final int discountCents;
  final int lineTotalCents;
  const ReservationItem(
      {required this.id,
      required this.reservationId,
      required this.productId,
      required this.quantity,
      required this.unitPriceCents,
      required this.unitCostCents,
      required this.taxRateBps,
      required this.discountCents,
      required this.lineTotalCents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['reservation_id'] = Variable<String>(reservationId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_cents'] = Variable<int>(unitPriceCents);
    map['unit_cost_cents'] = Variable<int>(unitCostCents);
    map['tax_rate_bps'] = Variable<int>(taxRateBps);
    map['discount_cents'] = Variable<int>(discountCents);
    map['line_total_cents'] = Variable<int>(lineTotalCents);
    return map;
  }

  ReservationItemsCompanion toCompanion(bool nullToAbsent) {
    return ReservationItemsCompanion(
      id: Value(id),
      reservationId: Value(reservationId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPriceCents: Value(unitPriceCents),
      unitCostCents: Value(unitCostCents),
      taxRateBps: Value(taxRateBps),
      discountCents: Value(discountCents),
      lineTotalCents: Value(lineTotalCents),
    );
  }

  factory ReservationItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReservationItem(
      id: serializer.fromJson<String>(json['id']),
      reservationId: serializer.fromJson<String>(json['reservationId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceCents: serializer.fromJson<int>(json['unitPriceCents']),
      unitCostCents: serializer.fromJson<int>(json['unitCostCents']),
      taxRateBps: serializer.fromJson<int>(json['taxRateBps']),
      discountCents: serializer.fromJson<int>(json['discountCents']),
      lineTotalCents: serializer.fromJson<int>(json['lineTotalCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'reservationId': serializer.toJson<String>(reservationId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceCents': serializer.toJson<int>(unitPriceCents),
      'unitCostCents': serializer.toJson<int>(unitCostCents),
      'taxRateBps': serializer.toJson<int>(taxRateBps),
      'discountCents': serializer.toJson<int>(discountCents),
      'lineTotalCents': serializer.toJson<int>(lineTotalCents),
    };
  }

  ReservationItem copyWith(
          {String? id,
          String? reservationId,
          String? productId,
          int? quantity,
          int? unitPriceCents,
          int? unitCostCents,
          int? taxRateBps,
          int? discountCents,
          int? lineTotalCents}) =>
      ReservationItem(
        id: id ?? this.id,
        reservationId: reservationId ?? this.reservationId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitPriceCents: unitPriceCents ?? this.unitPriceCents,
        unitCostCents: unitCostCents ?? this.unitCostCents,
        taxRateBps: taxRateBps ?? this.taxRateBps,
        discountCents: discountCents ?? this.discountCents,
        lineTotalCents: lineTotalCents ?? this.lineTotalCents,
      );
  ReservationItem copyWithCompanion(ReservationItemsCompanion data) {
    return ReservationItem(
      id: data.id.present ? data.id.value : this.id,
      reservationId: data.reservationId.present
          ? data.reservationId.value
          : this.reservationId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceCents: data.unitPriceCents.present
          ? data.unitPriceCents.value
          : this.unitPriceCents,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      taxRateBps:
          data.taxRateBps.present ? data.taxRateBps.value : this.taxRateBps,
      discountCents: data.discountCents.present
          ? data.discountCents.value
          : this.discountCents,
      lineTotalCents: data.lineTotalCents.present
          ? data.lineTotalCents.value
          : this.lineTotalCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReservationItem(')
          ..write('id: $id, ')
          ..write('reservationId: $reservationId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('discountCents: $discountCents, ')
          ..write('lineTotalCents: $lineTotalCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, reservationId, productId, quantity,
      unitPriceCents, unitCostCents, taxRateBps, discountCents, lineTotalCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReservationItem &&
          other.id == this.id &&
          other.reservationId == this.reservationId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPriceCents == this.unitPriceCents &&
          other.unitCostCents == this.unitCostCents &&
          other.taxRateBps == this.taxRateBps &&
          other.discountCents == this.discountCents &&
          other.lineTotalCents == this.lineTotalCents);
}

class ReservationItemsCompanion extends UpdateCompanion<ReservationItem> {
  final Value<String> id;
  final Value<String> reservationId;
  final Value<String> productId;
  final Value<int> quantity;
  final Value<int> unitPriceCents;
  final Value<int> unitCostCents;
  final Value<int> taxRateBps;
  final Value<int> discountCents;
  final Value<int> lineTotalCents;
  final Value<int> rowid;
  const ReservationItemsCompanion({
    this.id = const Value.absent(),
    this.reservationId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceCents = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.taxRateBps = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.lineTotalCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReservationItemsCompanion.insert({
    required String id,
    required String reservationId,
    required String productId,
    required int quantity,
    this.unitPriceCents = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.taxRateBps = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.lineTotalCents = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        reservationId = Value(reservationId),
        productId = Value(productId),
        quantity = Value(quantity);
  static Insertable<ReservationItem> custom({
    Expression<String>? id,
    Expression<String>? reservationId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<int>? unitPriceCents,
    Expression<int>? unitCostCents,
    Expression<int>? taxRateBps,
    Expression<int>? discountCents,
    Expression<int>? lineTotalCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reservationId != null) 'reservation_id': reservationId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceCents != null) 'unit_price_cents': unitPriceCents,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (taxRateBps != null) 'tax_rate_bps': taxRateBps,
      if (discountCents != null) 'discount_cents': discountCents,
      if (lineTotalCents != null) 'line_total_cents': lineTotalCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReservationItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? reservationId,
      Value<String>? productId,
      Value<int>? quantity,
      Value<int>? unitPriceCents,
      Value<int>? unitCostCents,
      Value<int>? taxRateBps,
      Value<int>? discountCents,
      Value<int>? lineTotalCents,
      Value<int>? rowid}) {
    return ReservationItemsCompanion(
      id: id ?? this.id,
      reservationId: reservationId ?? this.reservationId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      taxRateBps: taxRateBps ?? this.taxRateBps,
      discountCents: discountCents ?? this.discountCents,
      lineTotalCents: lineTotalCents ?? this.lineTotalCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (reservationId.present) {
      map['reservation_id'] = Variable<String>(reservationId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceCents.present) {
      map['unit_price_cents'] = Variable<int>(unitPriceCents.value);
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (taxRateBps.present) {
      map['tax_rate_bps'] = Variable<int>(taxRateBps.value);
    }
    if (discountCents.present) {
      map['discount_cents'] = Variable<int>(discountCents.value);
    }
    if (lineTotalCents.present) {
      map['line_total_cents'] = Variable<int>(lineTotalCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReservationItemsCompanion(')
          ..write('id: $id, ')
          ..write('reservationId: $reservationId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('discountCents: $discountCents, ')
          ..write('lineTotalCents: $lineTotalCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _reservationIdMeta =
      const VerificationMeta('reservationId');
  @override
  late final GeneratedColumn<String> reservationId = GeneratedColumn<String>(
      'reservation_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES reservations (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _subtotalCentsMeta =
      const VerificationMeta('subtotalCents');
  @override
  late final GeneratedColumn<int> subtotalCents = GeneratedColumn<int>(
      'subtotal_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxCentsMeta =
      const VerificationMeta('taxCents');
  @override
  late final GeneratedColumn<int> taxCents = GeneratedColumn<int>(
      'tax_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountCentsMeta =
      const VerificationMeta('discountCents');
  @override
  late final GeneratedColumn<int> discountCents = GeneratedColumn<int>(
      'discount_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalCentsMeta =
      const VerificationMeta('totalCents');
  @override
  late final GeneratedColumn<int> totalCents = GeneratedColumn<int>(
      'total_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _estimatedProfitCentsMeta =
      const VerificationMeta('estimatedProfitCents');
  @override
  late final GeneratedColumn<int> estimatedProfitCents = GeneratedColumn<int>(
      'estimated_profit_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _confirmedAtMeta =
      const VerificationMeta('confirmedAt');
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
      'confirmed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _canceledAtMeta =
      const VerificationMeta('canceledAt');
  @override
  late final GeneratedColumn<DateTime> canceledAt = GeneratedColumn<DateTime>(
      'canceled_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        customerId,
        reservationId,
        status,
        subtotalCents,
        taxCents,
        discountCents,
        totalCents,
        estimatedProfitCents,
        notes,
        createdAt,
        updatedAt,
        confirmedAt,
        canceledAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(Insertable<Sale> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('reservation_id')) {
      context.handle(
          _reservationIdMeta,
          reservationId.isAcceptableOrUnknown(
              data['reservation_id']!, _reservationIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('subtotal_cents')) {
      context.handle(
          _subtotalCentsMeta,
          subtotalCents.isAcceptableOrUnknown(
              data['subtotal_cents']!, _subtotalCentsMeta));
    }
    if (data.containsKey('tax_cents')) {
      context.handle(_taxCentsMeta,
          taxCents.isAcceptableOrUnknown(data['tax_cents']!, _taxCentsMeta));
    }
    if (data.containsKey('discount_cents')) {
      context.handle(
          _discountCentsMeta,
          discountCents.isAcceptableOrUnknown(
              data['discount_cents']!, _discountCentsMeta));
    }
    if (data.containsKey('total_cents')) {
      context.handle(
          _totalCentsMeta,
          totalCents.isAcceptableOrUnknown(
              data['total_cents']!, _totalCentsMeta));
    }
    if (data.containsKey('estimated_profit_cents')) {
      context.handle(
          _estimatedProfitCentsMeta,
          estimatedProfitCents.isAcceptableOrUnknown(
              data['estimated_profit_cents']!, _estimatedProfitCentsMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
          _confirmedAtMeta,
          confirmedAt.isAcceptableOrUnknown(
              data['confirmed_at']!, _confirmedAtMeta));
    }
    if (data.containsKey('canceled_at')) {
      context.handle(
          _canceledAtMeta,
          canceledAt.isAcceptableOrUnknown(
              data['canceled_at']!, _canceledAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      reservationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reservation_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      subtotalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtotal_cents'])!,
      taxCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_cents'])!,
      discountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_cents'])!,
      totalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_cents'])!,
      estimatedProfitCents: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}estimated_profit_cents'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      confirmedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}confirmed_at']),
      canceledAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}canceled_at']),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String? customerId;
  final String? reservationId;
  final String status;
  final int subtotalCents;
  final int taxCents;
  final int discountCents;
  final int totalCents;
  final int estimatedProfitCents;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? confirmedAt;
  final DateTime? canceledAt;
  const Sale(
      {required this.id,
      this.customerId,
      this.reservationId,
      required this.status,
      required this.subtotalCents,
      required this.taxCents,
      required this.discountCents,
      required this.totalCents,
      required this.estimatedProfitCents,
      this.notes,
      required this.createdAt,
      required this.updatedAt,
      this.confirmedAt,
      this.canceledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || reservationId != null) {
      map['reservation_id'] = Variable<String>(reservationId);
    }
    map['status'] = Variable<String>(status);
    map['subtotal_cents'] = Variable<int>(subtotalCents);
    map['tax_cents'] = Variable<int>(taxCents);
    map['discount_cents'] = Variable<int>(discountCents);
    map['total_cents'] = Variable<int>(totalCents);
    map['estimated_profit_cents'] = Variable<int>(estimatedProfitCents);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    }
    if (!nullToAbsent || canceledAt != null) {
      map['canceled_at'] = Variable<DateTime>(canceledAt);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      reservationId: reservationId == null && nullToAbsent
          ? const Value.absent()
          : Value(reservationId),
      status: Value(status),
      subtotalCents: Value(subtotalCents),
      taxCents: Value(taxCents),
      discountCents: Value(discountCents),
      totalCents: Value(totalCents),
      estimatedProfitCents: Value(estimatedProfitCents),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
      canceledAt: canceledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(canceledAt),
    );
  }

  factory Sale.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      reservationId: serializer.fromJson<String?>(json['reservationId']),
      status: serializer.fromJson<String>(json['status']),
      subtotalCents: serializer.fromJson<int>(json['subtotalCents']),
      taxCents: serializer.fromJson<int>(json['taxCents']),
      discountCents: serializer.fromJson<int>(json['discountCents']),
      totalCents: serializer.fromJson<int>(json['totalCents']),
      estimatedProfitCents:
          serializer.fromJson<int>(json['estimatedProfitCents']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
      canceledAt: serializer.fromJson<DateTime?>(json['canceledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'reservationId': serializer.toJson<String?>(reservationId),
      'status': serializer.toJson<String>(status),
      'subtotalCents': serializer.toJson<int>(subtotalCents),
      'taxCents': serializer.toJson<int>(taxCents),
      'discountCents': serializer.toJson<int>(discountCents),
      'totalCents': serializer.toJson<int>(totalCents),
      'estimatedProfitCents': serializer.toJson<int>(estimatedProfitCents),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
      'canceledAt': serializer.toJson<DateTime?>(canceledAt),
    };
  }

  Sale copyWith(
          {String? id,
          Value<String?> customerId = const Value.absent(),
          Value<String?> reservationId = const Value.absent(),
          String? status,
          int? subtotalCents,
          int? taxCents,
          int? discountCents,
          int? totalCents,
          int? estimatedProfitCents,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> confirmedAt = const Value.absent(),
          Value<DateTime?> canceledAt = const Value.absent()}) =>
      Sale(
        id: id ?? this.id,
        customerId: customerId.present ? customerId.value : this.customerId,
        reservationId:
            reservationId.present ? reservationId.value : this.reservationId,
        status: status ?? this.status,
        subtotalCents: subtotalCents ?? this.subtotalCents,
        taxCents: taxCents ?? this.taxCents,
        discountCents: discountCents ?? this.discountCents,
        totalCents: totalCents ?? this.totalCents,
        estimatedProfitCents: estimatedProfitCents ?? this.estimatedProfitCents,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
        canceledAt: canceledAt.present ? canceledAt.value : this.canceledAt,
      );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      reservationId: data.reservationId.present
          ? data.reservationId.value
          : this.reservationId,
      status: data.status.present ? data.status.value : this.status,
      subtotalCents: data.subtotalCents.present
          ? data.subtotalCents.value
          : this.subtotalCents,
      taxCents: data.taxCents.present ? data.taxCents.value : this.taxCents,
      discountCents: data.discountCents.present
          ? data.discountCents.value
          : this.discountCents,
      totalCents:
          data.totalCents.present ? data.totalCents.value : this.totalCents,
      estimatedProfitCents: data.estimatedProfitCents.present
          ? data.estimatedProfitCents.value
          : this.estimatedProfitCents,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      confirmedAt:
          data.confirmedAt.present ? data.confirmedAt.value : this.confirmedAt,
      canceledAt:
          data.canceledAt.present ? data.canceledAt.value : this.canceledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('reservationId: $reservationId, ')
          ..write('status: $status, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('discountCents: $discountCents, ')
          ..write('totalCents: $totalCents, ')
          ..write('estimatedProfitCents: $estimatedProfitCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('canceledAt: $canceledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      customerId,
      reservationId,
      status,
      subtotalCents,
      taxCents,
      discountCents,
      totalCents,
      estimatedProfitCents,
      notes,
      createdAt,
      updatedAt,
      confirmedAt,
      canceledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.reservationId == this.reservationId &&
          other.status == this.status &&
          other.subtotalCents == this.subtotalCents &&
          other.taxCents == this.taxCents &&
          other.discountCents == this.discountCents &&
          other.totalCents == this.totalCents &&
          other.estimatedProfitCents == this.estimatedProfitCents &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.confirmedAt == this.confirmedAt &&
          other.canceledAt == this.canceledAt);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<String?> reservationId;
  final Value<String> status;
  final Value<int> subtotalCents;
  final Value<int> taxCents;
  final Value<int> discountCents;
  final Value<int> totalCents;
  final Value<int> estimatedProfitCents;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> confirmedAt;
  final Value<DateTime?> canceledAt;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.reservationId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotalCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.estimatedProfitCents = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.canceledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    this.reservationId = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotalCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.totalCents = const Value.absent(),
    this.estimatedProfitCents = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.confirmedAt = const Value.absent(),
    this.canceledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? reservationId,
    Expression<String>? status,
    Expression<int>? subtotalCents,
    Expression<int>? taxCents,
    Expression<int>? discountCents,
    Expression<int>? totalCents,
    Expression<int>? estimatedProfitCents,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? confirmedAt,
    Expression<DateTime>? canceledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (reservationId != null) 'reservation_id': reservationId,
      if (status != null) 'status': status,
      if (subtotalCents != null) 'subtotal_cents': subtotalCents,
      if (taxCents != null) 'tax_cents': taxCents,
      if (discountCents != null) 'discount_cents': discountCents,
      if (totalCents != null) 'total_cents': totalCents,
      if (estimatedProfitCents != null)
        'estimated_profit_cents': estimatedProfitCents,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (canceledAt != null) 'canceled_at': canceledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? customerId,
      Value<String?>? reservationId,
      Value<String>? status,
      Value<int>? subtotalCents,
      Value<int>? taxCents,
      Value<int>? discountCents,
      Value<int>? totalCents,
      Value<int>? estimatedProfitCents,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? confirmedAt,
      Value<DateTime?>? canceledAt,
      Value<int>? rowid}) {
    return SalesCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      reservationId: reservationId ?? this.reservationId,
      status: status ?? this.status,
      subtotalCents: subtotalCents ?? this.subtotalCents,
      taxCents: taxCents ?? this.taxCents,
      discountCents: discountCents ?? this.discountCents,
      totalCents: totalCents ?? this.totalCents,
      estimatedProfitCents: estimatedProfitCents ?? this.estimatedProfitCents,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      canceledAt: canceledAt ?? this.canceledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (reservationId.present) {
      map['reservation_id'] = Variable<String>(reservationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (subtotalCents.present) {
      map['subtotal_cents'] = Variable<int>(subtotalCents.value);
    }
    if (taxCents.present) {
      map['tax_cents'] = Variable<int>(taxCents.value);
    }
    if (discountCents.present) {
      map['discount_cents'] = Variable<int>(discountCents.value);
    }
    if (totalCents.present) {
      map['total_cents'] = Variable<int>(totalCents.value);
    }
    if (estimatedProfitCents.present) {
      map['estimated_profit_cents'] = Variable<int>(estimatedProfitCents.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (canceledAt.present) {
      map['canceled_at'] = Variable<DateTime>(canceledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('reservationId: $reservationId, ')
          ..write('status: $status, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('discountCents: $discountCents, ')
          ..write('totalCents: $totalCents, ')
          ..write('estimatedProfitCents: $estimatedProfitCents, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('canceledAt: $canceledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceCentsMeta =
      const VerificationMeta('unitPriceCents');
  @override
  late final GeneratedColumn<int> unitPriceCents = GeneratedColumn<int>(
      'unit_price_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostCentsMeta =
      const VerificationMeta('unitCostCents');
  @override
  late final GeneratedColumn<int> unitCostCents = GeneratedColumn<int>(
      'unit_cost_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxRateBpsMeta =
      const VerificationMeta('taxRateBps');
  @override
  late final GeneratedColumn<int> taxRateBps = GeneratedColumn<int>(
      'tax_rate_bps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountCentsMeta =
      const VerificationMeta('discountCents');
  @override
  late final GeneratedColumn<int> discountCents = GeneratedColumn<int>(
      'discount_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxCentsMeta =
      const VerificationMeta('taxCents');
  @override
  late final GeneratedColumn<int> taxCents = GeneratedColumn<int>(
      'tax_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lineTotalCentsMeta =
      const VerificationMeta('lineTotalCents');
  @override
  late final GeneratedColumn<int> lineTotalCents = GeneratedColumn<int>(
      'line_total_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lineProfitCentsMeta =
      const VerificationMeta('lineProfitCents');
  @override
  late final GeneratedColumn<int> lineProfitCents = GeneratedColumn<int>(
      'line_profit_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saleId,
        productId,
        quantity,
        unitPriceCents,
        unitCostCents,
        taxRateBps,
        discountCents,
        taxCents,
        lineTotalCents,
        lineProfitCents
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_cents')) {
      context.handle(
          _unitPriceCentsMeta,
          unitPriceCents.isAcceptableOrUnknown(
              data['unit_price_cents']!, _unitPriceCentsMeta));
    } else if (isInserting) {
      context.missing(_unitPriceCentsMeta);
    }
    if (data.containsKey('unit_cost_cents')) {
      context.handle(
          _unitCostCentsMeta,
          unitCostCents.isAcceptableOrUnknown(
              data['unit_cost_cents']!, _unitCostCentsMeta));
    } else if (isInserting) {
      context.missing(_unitCostCentsMeta);
    }
    if (data.containsKey('tax_rate_bps')) {
      context.handle(
          _taxRateBpsMeta,
          taxRateBps.isAcceptableOrUnknown(
              data['tax_rate_bps']!, _taxRateBpsMeta));
    }
    if (data.containsKey('discount_cents')) {
      context.handle(
          _discountCentsMeta,
          discountCents.isAcceptableOrUnknown(
              data['discount_cents']!, _discountCentsMeta));
    }
    if (data.containsKey('tax_cents')) {
      context.handle(_taxCentsMeta,
          taxCents.isAcceptableOrUnknown(data['tax_cents']!, _taxCentsMeta));
    }
    if (data.containsKey('line_total_cents')) {
      context.handle(
          _lineTotalCentsMeta,
          lineTotalCents.isAcceptableOrUnknown(
              data['line_total_cents']!, _lineTotalCentsMeta));
    } else if (isInserting) {
      context.missing(_lineTotalCentsMeta);
    }
    if (data.containsKey('line_profit_cents')) {
      context.handle(
          _lineProfitCentsMeta,
          lineProfitCents.isAcceptableOrUnknown(
              data['line_profit_cents']!, _lineProfitCentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitPriceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_price_cents'])!,
      unitCostCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_cost_cents'])!,
      taxRateBps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_rate_bps'])!,
      discountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}discount_cents'])!,
      taxCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_cents'])!,
      lineTotalCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_total_cents'])!,
      lineProfitCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_profit_cents'])!,
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final String id;
  final String saleId;
  final String productId;
  final int quantity;
  final int unitPriceCents;
  final int unitCostCents;
  final int taxRateBps;
  final int discountCents;
  final int taxCents;
  final int lineTotalCents;
  final int lineProfitCents;
  const SaleItem(
      {required this.id,
      required this.saleId,
      required this.productId,
      required this.quantity,
      required this.unitPriceCents,
      required this.unitCostCents,
      required this.taxRateBps,
      required this.discountCents,
      required this.taxCents,
      required this.lineTotalCents,
      required this.lineProfitCents});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_cents'] = Variable<int>(unitPriceCents);
    map['unit_cost_cents'] = Variable<int>(unitCostCents);
    map['tax_rate_bps'] = Variable<int>(taxRateBps);
    map['discount_cents'] = Variable<int>(discountCents);
    map['tax_cents'] = Variable<int>(taxCents);
    map['line_total_cents'] = Variable<int>(lineTotalCents);
    map['line_profit_cents'] = Variable<int>(lineProfitCents);
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPriceCents: Value(unitPriceCents),
      unitCostCents: Value(unitCostCents),
      taxRateBps: Value(taxRateBps),
      discountCents: Value(discountCents),
      taxCents: Value(taxCents),
      lineTotalCents: Value(lineTotalCents),
      lineProfitCents: Value(lineProfitCents),
    );
  }

  factory SaleItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceCents: serializer.fromJson<int>(json['unitPriceCents']),
      unitCostCents: serializer.fromJson<int>(json['unitCostCents']),
      taxRateBps: serializer.fromJson<int>(json['taxRateBps']),
      discountCents: serializer.fromJson<int>(json['discountCents']),
      taxCents: serializer.fromJson<int>(json['taxCents']),
      lineTotalCents: serializer.fromJson<int>(json['lineTotalCents']),
      lineProfitCents: serializer.fromJson<int>(json['lineProfitCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceCents': serializer.toJson<int>(unitPriceCents),
      'unitCostCents': serializer.toJson<int>(unitCostCents),
      'taxRateBps': serializer.toJson<int>(taxRateBps),
      'discountCents': serializer.toJson<int>(discountCents),
      'taxCents': serializer.toJson<int>(taxCents),
      'lineTotalCents': serializer.toJson<int>(lineTotalCents),
      'lineProfitCents': serializer.toJson<int>(lineProfitCents),
    };
  }

  SaleItem copyWith(
          {String? id,
          String? saleId,
          String? productId,
          int? quantity,
          int? unitPriceCents,
          int? unitCostCents,
          int? taxRateBps,
          int? discountCents,
          int? taxCents,
          int? lineTotalCents,
          int? lineProfitCents}) =>
      SaleItem(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitPriceCents: unitPriceCents ?? this.unitPriceCents,
        unitCostCents: unitCostCents ?? this.unitCostCents,
        taxRateBps: taxRateBps ?? this.taxRateBps,
        discountCents: discountCents ?? this.discountCents,
        taxCents: taxCents ?? this.taxCents,
        lineTotalCents: lineTotalCents ?? this.lineTotalCents,
        lineProfitCents: lineProfitCents ?? this.lineProfitCents,
      );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceCents: data.unitPriceCents.present
          ? data.unitPriceCents.value
          : this.unitPriceCents,
      unitCostCents: data.unitCostCents.present
          ? data.unitCostCents.value
          : this.unitCostCents,
      taxRateBps:
          data.taxRateBps.present ? data.taxRateBps.value : this.taxRateBps,
      discountCents: data.discountCents.present
          ? data.discountCents.value
          : this.discountCents,
      taxCents: data.taxCents.present ? data.taxCents.value : this.taxCents,
      lineTotalCents: data.lineTotalCents.present
          ? data.lineTotalCents.value
          : this.lineTotalCents,
      lineProfitCents: data.lineProfitCents.present
          ? data.lineProfitCents.value
          : this.lineProfitCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('discountCents: $discountCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('lineTotalCents: $lineTotalCents, ')
          ..write('lineProfitCents: $lineProfitCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      saleId,
      productId,
      quantity,
      unitPriceCents,
      unitCostCents,
      taxRateBps,
      discountCents,
      taxCents,
      lineTotalCents,
      lineProfitCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPriceCents == this.unitPriceCents &&
          other.unitCostCents == this.unitCostCents &&
          other.taxRateBps == this.taxRateBps &&
          other.discountCents == this.discountCents &&
          other.taxCents == this.taxCents &&
          other.lineTotalCents == this.lineTotalCents &&
          other.lineProfitCents == this.lineProfitCents);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<int> quantity;
  final Value<int> unitPriceCents;
  final Value<int> unitCostCents;
  final Value<int> taxRateBps;
  final Value<int> discountCents;
  final Value<int> taxCents;
  final Value<int> lineTotalCents;
  final Value<int> lineProfitCents;
  final Value<int> rowid;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceCents = const Value.absent(),
    this.unitCostCents = const Value.absent(),
    this.taxRateBps = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    this.lineTotalCents = const Value.absent(),
    this.lineProfitCents = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required int quantity,
    required int unitPriceCents,
    required int unitCostCents,
    this.taxRateBps = const Value.absent(),
    this.discountCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    required int lineTotalCents,
    this.lineProfitCents = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        productId = Value(productId),
        quantity = Value(quantity),
        unitPriceCents = Value(unitPriceCents),
        unitCostCents = Value(unitCostCents),
        lineTotalCents = Value(lineTotalCents);
  static Insertable<SaleItem> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<int>? unitPriceCents,
    Expression<int>? unitCostCents,
    Expression<int>? taxRateBps,
    Expression<int>? discountCents,
    Expression<int>? taxCents,
    Expression<int>? lineTotalCents,
    Expression<int>? lineProfitCents,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceCents != null) 'unit_price_cents': unitPriceCents,
      if (unitCostCents != null) 'unit_cost_cents': unitCostCents,
      if (taxRateBps != null) 'tax_rate_bps': taxRateBps,
      if (discountCents != null) 'discount_cents': discountCents,
      if (taxCents != null) 'tax_cents': taxCents,
      if (lineTotalCents != null) 'line_total_cents': lineTotalCents,
      if (lineProfitCents != null) 'line_profit_cents': lineProfitCents,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<String>? productId,
      Value<int>? quantity,
      Value<int>? unitPriceCents,
      Value<int>? unitCostCents,
      Value<int>? taxRateBps,
      Value<int>? discountCents,
      Value<int>? taxCents,
      Value<int>? lineTotalCents,
      Value<int>? lineProfitCents,
      Value<int>? rowid}) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      unitCostCents: unitCostCents ?? this.unitCostCents,
      taxRateBps: taxRateBps ?? this.taxRateBps,
      discountCents: discountCents ?? this.discountCents,
      taxCents: taxCents ?? this.taxCents,
      lineTotalCents: lineTotalCents ?? this.lineTotalCents,
      lineProfitCents: lineProfitCents ?? this.lineProfitCents,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceCents.present) {
      map['unit_price_cents'] = Variable<int>(unitPriceCents.value);
    }
    if (unitCostCents.present) {
      map['unit_cost_cents'] = Variable<int>(unitCostCents.value);
    }
    if (taxRateBps.present) {
      map['tax_rate_bps'] = Variable<int>(taxRateBps.value);
    }
    if (discountCents.present) {
      map['discount_cents'] = Variable<int>(discountCents.value);
    }
    if (taxCents.present) {
      map['tax_cents'] = Variable<int>(taxCents.value);
    }
    if (lineTotalCents.present) {
      map['line_total_cents'] = Variable<int>(lineTotalCents.value);
    }
    if (lineProfitCents.present) {
      map['line_profit_cents'] = Variable<int>(lineProfitCents.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('unitCostCents: $unitCostCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('discountCents: $discountCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('lineTotalCents: $lineTotalCents, ')
          ..write('lineProfitCents: $lineProfitCents, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BatchAllocationsTable extends BatchAllocations
    with TableInfo<$BatchAllocationsTable, BatchAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_batches (id)'));
  static const VerificationMeta _reservationItemIdMeta =
      const VerificationMeta('reservationItemId');
  @override
  late final GeneratedColumn<String> reservationItemId =
      GeneratedColumn<String>('reservation_item_id', aliasedName, true,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'REFERENCES reservation_items (id)'));
  static const VerificationMeta _saleItemIdMeta =
      const VerificationMeta('saleItemId');
  @override
  late final GeneratedColumn<String> saleItemId = GeneratedColumn<String>(
      'sale_item_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sale_items (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityReservedMeta =
      const VerificationMeta('quantityReserved');
  @override
  late final GeneratedColumn<int> quantityReserved = GeneratedColumn<int>(
      'quantity_reserved', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _quantitySoldMeta =
      const VerificationMeta('quantitySold');
  @override
  late final GeneratedColumn<int> quantitySold = GeneratedColumn<int>(
      'quantity_sold', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
      'state', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('reserved'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        batchId,
        reservationItemId,
        saleItemId,
        quantity,
        quantityReserved,
        quantitySold,
        state,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batch_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<BatchAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('reservation_item_id')) {
      context.handle(
          _reservationItemIdMeta,
          reservationItemId.isAcceptableOrUnknown(
              data['reservation_item_id']!, _reservationItemIdMeta));
    }
    if (data.containsKey('sale_item_id')) {
      context.handle(
          _saleItemIdMeta,
          saleItemId.isAcceptableOrUnknown(
              data['sale_item_id']!, _saleItemIdMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('quantity_reserved')) {
      context.handle(
          _quantityReservedMeta,
          quantityReserved.isAcceptableOrUnknown(
              data['quantity_reserved']!, _quantityReservedMeta));
    }
    if (data.containsKey('quantity_sold')) {
      context.handle(
          _quantitySoldMeta,
          quantitySold.isAcceptableOrUnknown(
              data['quantity_sold']!, _quantitySoldMeta));
    }
    if (data.containsKey('state')) {
      context.handle(
          _stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BatchAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatchAllocation(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id'])!,
      reservationItemId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reservation_item_id']),
      saleItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_item_id']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      quantityReserved: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_reserved'])!,
      quantitySold: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_sold'])!,
      state: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BatchAllocationsTable createAlias(String alias) {
    return $BatchAllocationsTable(attachedDatabase, alias);
  }
}

class BatchAllocation extends DataClass implements Insertable<BatchAllocation> {
  final String id;
  final String productId;
  final String batchId;
  final String? reservationItemId;
  final String? saleItemId;
  final int quantity;
  final int quantityReserved;
  final int quantitySold;
  final String state;
  final DateTime createdAt;
  const BatchAllocation(
      {required this.id,
      required this.productId,
      required this.batchId,
      this.reservationItemId,
      this.saleItemId,
      required this.quantity,
      required this.quantityReserved,
      required this.quantitySold,
      required this.state,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['batch_id'] = Variable<String>(batchId);
    if (!nullToAbsent || reservationItemId != null) {
      map['reservation_item_id'] = Variable<String>(reservationItemId);
    }
    if (!nullToAbsent || saleItemId != null) {
      map['sale_item_id'] = Variable<String>(saleItemId);
    }
    map['quantity'] = Variable<int>(quantity);
    map['quantity_reserved'] = Variable<int>(quantityReserved);
    map['quantity_sold'] = Variable<int>(quantitySold);
    map['state'] = Variable<String>(state);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BatchAllocationsCompanion toCompanion(bool nullToAbsent) {
    return BatchAllocationsCompanion(
      id: Value(id),
      productId: Value(productId),
      batchId: Value(batchId),
      reservationItemId: reservationItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(reservationItemId),
      saleItemId: saleItemId == null && nullToAbsent
          ? const Value.absent()
          : Value(saleItemId),
      quantity: Value(quantity),
      quantityReserved: Value(quantityReserved),
      quantitySold: Value(quantitySold),
      state: Value(state),
      createdAt: Value(createdAt),
    );
  }

  factory BatchAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatchAllocation(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      batchId: serializer.fromJson<String>(json['batchId']),
      reservationItemId:
          serializer.fromJson<String?>(json['reservationItemId']),
      saleItemId: serializer.fromJson<String?>(json['saleItemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      quantityReserved: serializer.fromJson<int>(json['quantityReserved']),
      quantitySold: serializer.fromJson<int>(json['quantitySold']),
      state: serializer.fromJson<String>(json['state']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'batchId': serializer.toJson<String>(batchId),
      'reservationItemId': serializer.toJson<String?>(reservationItemId),
      'saleItemId': serializer.toJson<String?>(saleItemId),
      'quantity': serializer.toJson<int>(quantity),
      'quantityReserved': serializer.toJson<int>(quantityReserved),
      'quantitySold': serializer.toJson<int>(quantitySold),
      'state': serializer.toJson<String>(state),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BatchAllocation copyWith(
          {String? id,
          String? productId,
          String? batchId,
          Value<String?> reservationItemId = const Value.absent(),
          Value<String?> saleItemId = const Value.absent(),
          int? quantity,
          int? quantityReserved,
          int? quantitySold,
          String? state,
          DateTime? createdAt}) =>
      BatchAllocation(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        batchId: batchId ?? this.batchId,
        reservationItemId: reservationItemId.present
            ? reservationItemId.value
            : this.reservationItemId,
        saleItemId: saleItemId.present ? saleItemId.value : this.saleItemId,
        quantity: quantity ?? this.quantity,
        quantityReserved: quantityReserved ?? this.quantityReserved,
        quantitySold: quantitySold ?? this.quantitySold,
        state: state ?? this.state,
        createdAt: createdAt ?? this.createdAt,
      );
  BatchAllocation copyWithCompanion(BatchAllocationsCompanion data) {
    return BatchAllocation(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      reservationItemId: data.reservationItemId.present
          ? data.reservationItemId.value
          : this.reservationItemId,
      saleItemId:
          data.saleItemId.present ? data.saleItemId.value : this.saleItemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      quantityReserved: data.quantityReserved.present
          ? data.quantityReserved.value
          : this.quantityReserved,
      quantitySold: data.quantitySold.present
          ? data.quantitySold.value
          : this.quantitySold,
      state: data.state.present ? data.state.value : this.state,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatchAllocation(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchId: $batchId, ')
          ..write('reservationItemId: $reservationItemId, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('quantity: $quantity, ')
          ..write('quantityReserved: $quantityReserved, ')
          ..write('quantitySold: $quantitySold, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, batchId, reservationItemId,
      saleItemId, quantity, quantityReserved, quantitySold, state, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatchAllocation &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.batchId == this.batchId &&
          other.reservationItemId == this.reservationItemId &&
          other.saleItemId == this.saleItemId &&
          other.quantity == this.quantity &&
          other.quantityReserved == this.quantityReserved &&
          other.quantitySold == this.quantitySold &&
          other.state == this.state &&
          other.createdAt == this.createdAt);
}

class BatchAllocationsCompanion extends UpdateCompanion<BatchAllocation> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> batchId;
  final Value<String?> reservationItemId;
  final Value<String?> saleItemId;
  final Value<int> quantity;
  final Value<int> quantityReserved;
  final Value<int> quantitySold;
  final Value<String> state;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BatchAllocationsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.reservationItemId = const Value.absent(),
    this.saleItemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.quantityReserved = const Value.absent(),
    this.quantitySold = const Value.absent(),
    this.state = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BatchAllocationsCompanion.insert({
    required String id,
    required String productId,
    required String batchId,
    this.reservationItemId = const Value.absent(),
    this.saleItemId = const Value.absent(),
    required int quantity,
    this.quantityReserved = const Value.absent(),
    this.quantitySold = const Value.absent(),
    this.state = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        batchId = Value(batchId),
        quantity = Value(quantity),
        createdAt = Value(createdAt);
  static Insertable<BatchAllocation> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? batchId,
    Expression<String>? reservationItemId,
    Expression<String>? saleItemId,
    Expression<int>? quantity,
    Expression<int>? quantityReserved,
    Expression<int>? quantitySold,
    Expression<String>? state,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (batchId != null) 'batch_id': batchId,
      if (reservationItemId != null) 'reservation_item_id': reservationItemId,
      if (saleItemId != null) 'sale_item_id': saleItemId,
      if (quantity != null) 'quantity': quantity,
      if (quantityReserved != null) 'quantity_reserved': quantityReserved,
      if (quantitySold != null) 'quantity_sold': quantitySold,
      if (state != null) 'state': state,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BatchAllocationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? batchId,
      Value<String?>? reservationItemId,
      Value<String?>? saleItemId,
      Value<int>? quantity,
      Value<int>? quantityReserved,
      Value<int>? quantitySold,
      Value<String>? state,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return BatchAllocationsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      batchId: batchId ?? this.batchId,
      reservationItemId: reservationItemId ?? this.reservationItemId,
      saleItemId: saleItemId ?? this.saleItemId,
      quantity: quantity ?? this.quantity,
      quantityReserved: quantityReserved ?? this.quantityReserved,
      quantitySold: quantitySold ?? this.quantitySold,
      state: state ?? this.state,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (reservationItemId.present) {
      map['reservation_item_id'] = Variable<String>(reservationItemId.value);
    }
    if (saleItemId.present) {
      map['sale_item_id'] = Variable<String>(saleItemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (quantityReserved.present) {
      map['quantity_reserved'] = Variable<int>(quantityReserved.value);
    }
    if (quantitySold.present) {
      map['quantity_sold'] = Variable<int>(quantitySold.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchId: $batchId, ')
          ..write('reservationItemId: $reservationItemId, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('quantity: $quantity, ')
          ..write('quantityReserved: $quantityReserved, ')
          ..write('quantitySold: $quantitySold, ')
          ..write('state: $state, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_batches (id)'));
  static const VerificationMeta _movementTypeMeta =
      const VerificationMeta('movementType');
  @override
  late final GeneratedColumn<String> movementType = GeneratedColumn<String>(
      'movement_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stockBeforeMeta =
      const VerificationMeta('stockBefore');
  @override
  late final GeneratedColumn<int> stockBefore = GeneratedColumn<int>(
      'stock_before', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _stockAfterMeta =
      const VerificationMeta('stockAfter');
  @override
  late final GeneratedColumn<int> stockAfter = GeneratedColumn<int>(
      'stock_after', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _referenceTypeMeta =
      const VerificationMeta('referenceType');
  @override
  late final GeneratedColumn<String> referenceType = GeneratedColumn<String>(
      'reference_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observationsMeta =
      const VerificationMeta('observations');
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
      'observations', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        batchId,
        movementType,
        quantity,
        stockBefore,
        stockAfter,
        referenceType,
        referenceId,
        reason,
        observations,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(Insertable<StockMovement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    }
    if (data.containsKey('movement_type')) {
      context.handle(
          _movementTypeMeta,
          movementType.isAcceptableOrUnknown(
              data['movement_type']!, _movementTypeMeta));
    } else if (isInserting) {
      context.missing(_movementTypeMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('stock_before')) {
      context.handle(
          _stockBeforeMeta,
          stockBefore.isAcceptableOrUnknown(
              data['stock_before']!, _stockBeforeMeta));
    } else if (isInserting) {
      context.missing(_stockBeforeMeta);
    }
    if (data.containsKey('stock_after')) {
      context.handle(
          _stockAfterMeta,
          stockAfter.isAcceptableOrUnknown(
              data['stock_after']!, _stockAfterMeta));
    } else if (isInserting) {
      context.missing(_stockAfterMeta);
    }
    if (data.containsKey('reference_type')) {
      context.handle(
          _referenceTypeMeta,
          referenceType.isAcceptableOrUnknown(
              data['reference_type']!, _referenceTypeMeta));
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('observations')) {
      context.handle(
          _observationsMeta,
          observations.isAcceptableOrUnknown(
              data['observations']!, _observationsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id']),
      movementType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}movement_type'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      stockBefore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_before'])!,
      stockAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}stock_after'])!,
      referenceType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_type']),
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      observations: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}observations']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovement extends DataClass implements Insertable<StockMovement> {
  final String id;
  final String productId;
  final String? batchId;
  final String movementType;
  final int quantity;
  final int stockBefore;
  final int stockAfter;
  final String? referenceType;
  final String? referenceId;
  final String? reason;
  final String? observations;
  final DateTime createdAt;
  const StockMovement(
      {required this.id,
      required this.productId,
      this.batchId,
      required this.movementType,
      required this.quantity,
      required this.stockBefore,
      required this.stockAfter,
      this.referenceType,
      this.referenceId,
      this.reason,
      this.observations,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    if (!nullToAbsent || batchId != null) {
      map['batch_id'] = Variable<String>(batchId);
    }
    map['movement_type'] = Variable<String>(movementType);
    map['quantity'] = Variable<int>(quantity);
    map['stock_before'] = Variable<int>(stockBefore);
    map['stock_after'] = Variable<int>(stockAfter);
    if (!nullToAbsent || referenceType != null) {
      map['reference_type'] = Variable<String>(referenceType);
    }
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      productId: Value(productId),
      batchId: batchId == null && nullToAbsent
          ? const Value.absent()
          : Value(batchId),
      movementType: Value(movementType),
      quantity: Value(quantity),
      stockBefore: Value(stockBefore),
      stockAfter: Value(stockAfter),
      referenceType: referenceType == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceType),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovement(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      batchId: serializer.fromJson<String?>(json['batchId']),
      movementType: serializer.fromJson<String>(json['movementType']),
      quantity: serializer.fromJson<int>(json['quantity']),
      stockBefore: serializer.fromJson<int>(json['stockBefore']),
      stockAfter: serializer.fromJson<int>(json['stockAfter']),
      referenceType: serializer.fromJson<String?>(json['referenceType']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      reason: serializer.fromJson<String?>(json['reason']),
      observations: serializer.fromJson<String?>(json['observations']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'batchId': serializer.toJson<String?>(batchId),
      'movementType': serializer.toJson<String>(movementType),
      'quantity': serializer.toJson<int>(quantity),
      'stockBefore': serializer.toJson<int>(stockBefore),
      'stockAfter': serializer.toJson<int>(stockAfter),
      'referenceType': serializer.toJson<String?>(referenceType),
      'referenceId': serializer.toJson<String?>(referenceId),
      'reason': serializer.toJson<String?>(reason),
      'observations': serializer.toJson<String?>(observations),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockMovement copyWith(
          {String? id,
          String? productId,
          Value<String?> batchId = const Value.absent(),
          String? movementType,
          int? quantity,
          int? stockBefore,
          int? stockAfter,
          Value<String?> referenceType = const Value.absent(),
          Value<String?> referenceId = const Value.absent(),
          Value<String?> reason = const Value.absent(),
          Value<String?> observations = const Value.absent(),
          DateTime? createdAt}) =>
      StockMovement(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        batchId: batchId.present ? batchId.value : this.batchId,
        movementType: movementType ?? this.movementType,
        quantity: quantity ?? this.quantity,
        stockBefore: stockBefore ?? this.stockBefore,
        stockAfter: stockAfter ?? this.stockAfter,
        referenceType:
            referenceType.present ? referenceType.value : this.referenceType,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        reason: reason.present ? reason.value : this.reason,
        observations:
            observations.present ? observations.value : this.observations,
        createdAt: createdAt ?? this.createdAt,
      );
  StockMovement copyWithCompanion(StockMovementsCompanion data) {
    return StockMovement(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      movementType: data.movementType.present
          ? data.movementType.value
          : this.movementType,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      stockBefore:
          data.stockBefore.present ? data.stockBefore.value : this.stockBefore,
      stockAfter:
          data.stockAfter.present ? data.stockAfter.value : this.stockAfter,
      referenceType: data.referenceType.present
          ? data.referenceType.value
          : this.referenceType,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      reason: data.reason.present ? data.reason.value : this.reason,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovement(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchId: $batchId, ')
          ..write('movementType: $movementType, ')
          ..write('quantity: $quantity, ')
          ..write('stockBefore: $stockBefore, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('reason: $reason, ')
          ..write('observations: $observations, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productId,
      batchId,
      movementType,
      quantity,
      stockBefore,
      stockAfter,
      referenceType,
      referenceId,
      reason,
      observations,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovement &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.batchId == this.batchId &&
          other.movementType == this.movementType &&
          other.quantity == this.quantity &&
          other.stockBefore == this.stockBefore &&
          other.stockAfter == this.stockAfter &&
          other.referenceType == this.referenceType &&
          other.referenceId == this.referenceId &&
          other.reason == this.reason &&
          other.observations == this.observations &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovement> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String?> batchId;
  final Value<String> movementType;
  final Value<int> quantity;
  final Value<int> stockBefore;
  final Value<int> stockAfter;
  final Value<String?> referenceType;
  final Value<String?> referenceId;
  final Value<String?> reason;
  final Value<String?> observations;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.movementType = const Value.absent(),
    this.quantity = const Value.absent(),
    this.stockBefore = const Value.absent(),
    this.stockAfter = const Value.absent(),
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.reason = const Value.absent(),
    this.observations = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String productId,
    this.batchId = const Value.absent(),
    required String movementType,
    required int quantity,
    required int stockBefore,
    required int stockAfter,
    this.referenceType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.reason = const Value.absent(),
    this.observations = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        movementType = Value(movementType),
        quantity = Value(quantity),
        stockBefore = Value(stockBefore),
        stockAfter = Value(stockAfter),
        createdAt = Value(createdAt);
  static Insertable<StockMovement> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? batchId,
    Expression<String>? movementType,
    Expression<int>? quantity,
    Expression<int>? stockBefore,
    Expression<int>? stockAfter,
    Expression<String>? referenceType,
    Expression<String>? referenceId,
    Expression<String>? reason,
    Expression<String>? observations,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (batchId != null) 'batch_id': batchId,
      if (movementType != null) 'movement_type': movementType,
      if (quantity != null) 'quantity': quantity,
      if (stockBefore != null) 'stock_before': stockBefore,
      if (stockAfter != null) 'stock_after': stockAfter,
      if (referenceType != null) 'reference_type': referenceType,
      if (referenceId != null) 'reference_id': referenceId,
      if (reason != null) 'reason': reason,
      if (observations != null) 'observations': observations,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String?>? batchId,
      Value<String>? movementType,
      Value<int>? quantity,
      Value<int>? stockBefore,
      Value<int>? stockAfter,
      Value<String?>? referenceType,
      Value<String?>? referenceId,
      Value<String?>? reason,
      Value<String?>? observations,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      batchId: batchId ?? this.batchId,
      movementType: movementType ?? this.movementType,
      quantity: quantity ?? this.quantity,
      stockBefore: stockBefore ?? this.stockBefore,
      stockAfter: stockAfter ?? this.stockAfter,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      reason: reason ?? this.reason,
      observations: observations ?? this.observations,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (movementType.present) {
      map['movement_type'] = Variable<String>(movementType.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (stockBefore.present) {
      map['stock_before'] = Variable<int>(stockBefore.value);
    }
    if (stockAfter.present) {
      map['stock_after'] = Variable<int>(stockAfter.value);
    }
    if (referenceType.present) {
      map['reference_type'] = Variable<String>(referenceType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchId: $batchId, ')
          ..write('movementType: $movementType, ')
          ..write('quantity: $quantity, ')
          ..write('stockBefore: $stockBefore, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('referenceType: $referenceType, ')
          ..write('referenceId: $referenceId, ')
          ..write('reason: $reason, ')
          ..write('observations: $observations, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnsTable extends Returns with TableInfo<$ReturnsTable, Return> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sales (id)'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, saleId, status, reason, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'returns';
  @override
  VerificationContext validateIntegrity(Insertable<Return> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Return map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Return(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReturnsTable createAlias(String alias) {
    return $ReturnsTable(attachedDatabase, alias);
  }
}

class Return extends DataClass implements Insertable<Return> {
  final String id;
  final String saleId;
  final String status;
  final String? reason;
  final DateTime createdAt;
  const Return(
      {required this.id,
      required this.saleId,
      required this.status,
      this.reason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReturnsCompanion toCompanion(bool nullToAbsent) {
    return ReturnsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      status: Value(status),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory Return.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Return(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      status: serializer.fromJson<String>(json['status']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'status': serializer.toJson<String>(status),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Return copyWith(
          {String? id,
          String? saleId,
          String? status,
          Value<String?> reason = const Value.absent(),
          DateTime? createdAt}) =>
      Return(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        status: status ?? this.status,
        reason: reason.present ? reason.value : this.reason,
        createdAt: createdAt ?? this.createdAt,
      );
  Return copyWithCompanion(ReturnsCompanion data) {
    return Return(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      status: data.status.present ? data.status.value : this.status,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Return(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saleId, status, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Return &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.status == this.status &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class ReturnsCompanion extends UpdateCompanion<Return> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> status;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ReturnsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnsCompanion.insert({
    required String id,
    required String saleId,
    this.status = const Value.absent(),
    this.reason = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        createdAt = Value(createdAt);
  static Insertable<Return> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? status,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (status != null) 'status': status,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnsCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<String>? status,
      Value<String?>? reason,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ReturnsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('status: $status, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnItemsTable extends ReturnItems
    with TableInfo<$ReturnItemsTable, ReturnItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _returnIdMeta =
      const VerificationMeta('returnId');
  @override
  late final GeneratedColumn<String> returnId = GeneratedColumn<String>(
      'return_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES returns (id)'));
  static const VerificationMeta _saleItemIdMeta =
      const VerificationMeta('saleItemId');
  @override
  late final GeneratedColumn<String> saleItemId = GeneratedColumn<String>(
      'sale_item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES sale_items (id)'));
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<String> batchId = GeneratedColumn<String>(
      'batch_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES product_batches (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, returnId, saleItemId, batchId, quantity];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_items';
  @override
  VerificationContext validateIntegrity(Insertable<ReturnItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('return_id')) {
      context.handle(_returnIdMeta,
          returnId.isAcceptableOrUnknown(data['return_id']!, _returnIdMeta));
    } else if (isInserting) {
      context.missing(_returnIdMeta);
    }
    if (data.containsKey('sale_item_id')) {
      context.handle(
          _saleItemIdMeta,
          saleItemId.isAcceptableOrUnknown(
              data['sale_item_id']!, _saleItemIdMeta));
    } else if (isInserting) {
      context.missing(_saleItemIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      returnId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}return_id'])!,
      saleItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_item_id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $ReturnItemsTable createAlias(String alias) {
    return $ReturnItemsTable(attachedDatabase, alias);
  }
}

class ReturnItem extends DataClass implements Insertable<ReturnItem> {
  final String id;
  final String returnId;
  final String saleItemId;
  final String batchId;
  final int quantity;
  const ReturnItem(
      {required this.id,
      required this.returnId,
      required this.saleItemId,
      required this.batchId,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['return_id'] = Variable<String>(returnId);
    map['sale_item_id'] = Variable<String>(saleItemId);
    map['batch_id'] = Variable<String>(batchId);
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  ReturnItemsCompanion toCompanion(bool nullToAbsent) {
    return ReturnItemsCompanion(
      id: Value(id),
      returnId: Value(returnId),
      saleItemId: Value(saleItemId),
      batchId: Value(batchId),
      quantity: Value(quantity),
    );
  }

  factory ReturnItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnItem(
      id: serializer.fromJson<String>(json['id']),
      returnId: serializer.fromJson<String>(json['returnId']),
      saleItemId: serializer.fromJson<String>(json['saleItemId']),
      batchId: serializer.fromJson<String>(json['batchId']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'returnId': serializer.toJson<String>(returnId),
      'saleItemId': serializer.toJson<String>(saleItemId),
      'batchId': serializer.toJson<String>(batchId),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  ReturnItem copyWith(
          {String? id,
          String? returnId,
          String? saleItemId,
          String? batchId,
          int? quantity}) =>
      ReturnItem(
        id: id ?? this.id,
        returnId: returnId ?? this.returnId,
        saleItemId: saleItemId ?? this.saleItemId,
        batchId: batchId ?? this.batchId,
        quantity: quantity ?? this.quantity,
      );
  ReturnItem copyWithCompanion(ReturnItemsCompanion data) {
    return ReturnItem(
      id: data.id.present ? data.id.value : this.id,
      returnId: data.returnId.present ? data.returnId.value : this.returnId,
      saleItemId:
          data.saleItemId.present ? data.saleItemId.value : this.saleItemId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnItem(')
          ..write('id: $id, ')
          ..write('returnId: $returnId, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, returnId, saleItemId, batchId, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnItem &&
          other.id == this.id &&
          other.returnId == this.returnId &&
          other.saleItemId == this.saleItemId &&
          other.batchId == this.batchId &&
          other.quantity == this.quantity);
}

class ReturnItemsCompanion extends UpdateCompanion<ReturnItem> {
  final Value<String> id;
  final Value<String> returnId;
  final Value<String> saleItemId;
  final Value<String> batchId;
  final Value<int> quantity;
  final Value<int> rowid;
  const ReturnItemsCompanion({
    this.id = const Value.absent(),
    this.returnId = const Value.absent(),
    this.saleItemId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnItemsCompanion.insert({
    required String id,
    required String returnId,
    required String saleItemId,
    required String batchId,
    required int quantity,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        returnId = Value(returnId),
        saleItemId = Value(saleItemId),
        batchId = Value(batchId),
        quantity = Value(quantity);
  static Insertable<ReturnItem> custom({
    Expression<String>? id,
    Expression<String>? returnId,
    Expression<String>? saleItemId,
    Expression<String>? batchId,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (returnId != null) 'return_id': returnId,
      if (saleItemId != null) 'sale_item_id': saleItemId,
      if (batchId != null) 'batch_id': batchId,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? returnId,
      Value<String>? saleItemId,
      Value<String>? batchId,
      Value<int>? quantity,
      Value<int>? rowid}) {
    return ReturnItemsCompanion(
      id: id ?? this.id,
      returnId: returnId ?? this.returnId,
      saleItemId: saleItemId ?? this.saleItemId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (returnId.present) {
      map['return_id'] = Variable<String>(returnId.value);
    }
    if (saleItemId.present) {
      map['sale_item_id'] = Variable<String>(saleItemId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<String>(batchId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnItemsCompanion(')
          ..write('id: $id, ')
          ..write('returnId: $returnId, ')
          ..write('saleItemId: $saleItemId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final String id;
  final String name;
  final bool isActive;
  const ExpenseCategory(
      {required this.id, required this.name, required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ExpenseCategory copyWith({String? id, String? name, bool? isActive}) =>
      ExpenseCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
      );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    required String id,
    required String name,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<ExpenseCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_categories (id)'));
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES suppliers (id)'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _amountCentsMeta =
      const VerificationMeta('amountCents');
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
      'amount_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxCentsMeta =
      const VerificationMeta('taxCents');
  @override
  late final GeneratedColumn<int> taxCents = GeneratedColumn<int>(
      'tax_cents', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        categoryId,
        supplierId,
        description,
        amountCents,
        taxCents,
        paymentMethod,
        notes,
        isActive,
        occurredAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
          _amountCentsMeta,
          amountCents.isAcceptableOrUnknown(
              data['amount_cents']!, _amountCentsMeta));
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('tax_cents')) {
      context.handle(_taxCentsMeta,
          taxCents.isAcceptableOrUnknown(data['tax_cents']!, _taxCentsMeta));
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      amountCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_cents'])!,
      taxCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_cents'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final String name;
  final String? categoryId;
  final String? supplierId;
  final String? description;
  final int amountCents;
  final int taxCents;
  final String? paymentMethod;
  final String? notes;
  final bool isActive;
  final DateTime occurredAt;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Expense(
      {required this.id,
      required this.name,
      this.categoryId,
      this.supplierId,
      this.description,
      required this.amountCents,
      required this.taxCents,
      this.paymentMethod,
      this.notes,
      required this.isActive,
      required this.occurredAt,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['amount_cents'] = Variable<int>(amountCents);
    map['tax_cents'] = Variable<int>(taxCents);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      name: Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      amountCents: Value(amountCents),
      taxCents: Value(taxCents),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      occurredAt: Value(occurredAt),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      description: serializer.fromJson<String?>(json['description']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      taxCents: serializer.fromJson<int>(json['taxCents']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<String?>(categoryId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'description': serializer.toJson<String?>(description),
      'amountCents': serializer.toJson<int>(amountCents),
      'taxCents': serializer.toJson<int>(taxCents),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  Expense copyWith(
          {String? id,
          String? name,
          Value<String?> categoryId = const Value.absent(),
          Value<String?> supplierId = const Value.absent(),
          Value<String?> description = const Value.absent(),
          int? amountCents,
          int? taxCents,
          Value<String?> paymentMethod = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          DateTime? occurredAt,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        description: description.present ? description.value : this.description,
        amountCents: amountCents ?? this.amountCents,
        taxCents: taxCents ?? this.taxCents,
        paymentMethod:
            paymentMethod.present ? paymentMethod.value : this.paymentMethod,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        occurredAt: occurredAt ?? this.occurredAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      description:
          data.description.present ? data.description.value : this.description,
      amountCents:
          data.amountCents.present ? data.amountCents.value : this.amountCents,
      taxCents: data.taxCents.present ? data.taxCents.value : this.taxCents,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('supplierId: $supplierId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      categoryId,
      supplierId,
      description,
      amountCents,
      taxCents,
      paymentMethod,
      notes,
      isActive,
      occurredAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.supplierId == this.supplierId &&
          other.description == this.description &&
          other.amountCents == this.amountCents &&
          other.taxCents == this.taxCents &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.occurredAt == this.occurredAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> categoryId;
  final Value<String?> supplierId;
  final Value<String?> description;
  final Value<int> amountCents;
  final Value<int> taxCents;
  final Value<String?> paymentMethod;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> occurredAt;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.description = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.taxCents = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String name,
    this.categoryId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.description = const Value.absent(),
    required int amountCents,
    this.taxCents = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime occurredAt,
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amountCents = Value(amountCents),
        occurredAt = Value(occurredAt),
        createdAt = Value(createdAt);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryId,
    Expression<String>? supplierId,
    Expression<String>? description,
    Expression<int>? amountCents,
    Expression<int>? taxCents,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? occurredAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (description != null) 'description': description,
      if (amountCents != null) 'amount_cents': amountCents,
      if (taxCents != null) 'tax_cents': taxCents,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? categoryId,
      Value<String?>? supplierId,
      Value<String?>? description,
      Value<int>? amountCents,
      Value<int>? taxCents,
      Value<String?>? paymentMethod,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<DateTime>? occurredAt,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      taxCents: taxCents ?? this.taxCents,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (taxCents.present) {
      map['tax_cents'] = Variable<int>(taxCents.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('supplierId: $supplierId, ')
          ..write('description: $description, ')
          ..write('amountCents: $amountCents, ')
          ..write('taxCents: $taxCents, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceHistoryTable extends PriceHistory
    with TableInfo<$PriceHistoryTable, PriceHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _costCentsMeta =
      const VerificationMeta('costCents');
  @override
  late final GeneratedColumn<int> costCents = GeneratedColumn<int>(
      'cost_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _salePriceCentsMeta =
      const VerificationMeta('salePriceCents');
  @override
  late final GeneratedColumn<int> salePriceCents = GeneratedColumn<int>(
      'sale_price_cents', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxRateBpsMeta =
      const VerificationMeta('taxRateBps');
  @override
  late final GeneratedColumn<int> taxRateBps = GeneratedColumn<int>(
      'tax_rate_bps', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, costCents, salePriceCents, taxRateBps, reason, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_history';
  @override
  VerificationContext validateIntegrity(Insertable<PriceHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('cost_cents')) {
      context.handle(_costCentsMeta,
          costCents.isAcceptableOrUnknown(data['cost_cents']!, _costCentsMeta));
    } else if (isInserting) {
      context.missing(_costCentsMeta);
    }
    if (data.containsKey('sale_price_cents')) {
      context.handle(
          _salePriceCentsMeta,
          salePriceCents.isAcceptableOrUnknown(
              data['sale_price_cents']!, _salePriceCentsMeta));
    } else if (isInserting) {
      context.missing(_salePriceCentsMeta);
    }
    if (data.containsKey('tax_rate_bps')) {
      context.handle(
          _taxRateBpsMeta,
          taxRateBps.isAcceptableOrUnknown(
              data['tax_rate_bps']!, _taxRateBpsMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      costCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cost_cents'])!,
      salePriceCents: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sale_price_cents'])!,
      taxRateBps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_rate_bps'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PriceHistoryTable createAlias(String alias) {
    return $PriceHistoryTable(attachedDatabase, alias);
  }
}

class PriceHistoryData extends DataClass
    implements Insertable<PriceHistoryData> {
  final String id;
  final String productId;
  final int costCents;
  final int salePriceCents;
  final int taxRateBps;
  final String? reason;
  final DateTime createdAt;
  const PriceHistoryData(
      {required this.id,
      required this.productId,
      required this.costCents,
      required this.salePriceCents,
      required this.taxRateBps,
      this.reason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['cost_cents'] = Variable<int>(costCents);
    map['sale_price_cents'] = Variable<int>(salePriceCents);
    map['tax_rate_bps'] = Variable<int>(taxRateBps);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PriceHistoryCompanion toCompanion(bool nullToAbsent) {
    return PriceHistoryCompanion(
      id: Value(id),
      productId: Value(productId),
      costCents: Value(costCents),
      salePriceCents: Value(salePriceCents),
      taxRateBps: Value(taxRateBps),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory PriceHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceHistoryData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      costCents: serializer.fromJson<int>(json['costCents']),
      salePriceCents: serializer.fromJson<int>(json['salePriceCents']),
      taxRateBps: serializer.fromJson<int>(json['taxRateBps']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'costCents': serializer.toJson<int>(costCents),
      'salePriceCents': serializer.toJson<int>(salePriceCents),
      'taxRateBps': serializer.toJson<int>(taxRateBps),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PriceHistoryData copyWith(
          {String? id,
          String? productId,
          int? costCents,
          int? salePriceCents,
          int? taxRateBps,
          Value<String?> reason = const Value.absent(),
          DateTime? createdAt}) =>
      PriceHistoryData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        costCents: costCents ?? this.costCents,
        salePriceCents: salePriceCents ?? this.salePriceCents,
        taxRateBps: taxRateBps ?? this.taxRateBps,
        reason: reason.present ? reason.value : this.reason,
        createdAt: createdAt ?? this.createdAt,
      );
  PriceHistoryData copyWithCompanion(PriceHistoryCompanion data) {
    return PriceHistoryData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      costCents: data.costCents.present ? data.costCents.value : this.costCents,
      salePriceCents: data.salePriceCents.present
          ? data.salePriceCents.value
          : this.salePriceCents,
      taxRateBps:
          data.taxRateBps.present ? data.taxRateBps.value : this.taxRateBps,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('costCents: $costCents, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, productId, costCents, salePriceCents, taxRateBps, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceHistoryData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.costCents == this.costCents &&
          other.salePriceCents == this.salePriceCents &&
          other.taxRateBps == this.taxRateBps &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class PriceHistoryCompanion extends UpdateCompanion<PriceHistoryData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<int> costCents;
  final Value<int> salePriceCents;
  final Value<int> taxRateBps;
  final Value<String?> reason;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PriceHistoryCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.costCents = const Value.absent(),
    this.salePriceCents = const Value.absent(),
    this.taxRateBps = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PriceHistoryCompanion.insert({
    required String id,
    required String productId,
    required int costCents,
    required int salePriceCents,
    this.taxRateBps = const Value.absent(),
    this.reason = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        costCents = Value(costCents),
        salePriceCents = Value(salePriceCents),
        createdAt = Value(createdAt);
  static Insertable<PriceHistoryData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<int>? costCents,
    Expression<int>? salePriceCents,
    Expression<int>? taxRateBps,
    Expression<String>? reason,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (costCents != null) 'cost_cents': costCents,
      if (salePriceCents != null) 'sale_price_cents': salePriceCents,
      if (taxRateBps != null) 'tax_rate_bps': taxRateBps,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PriceHistoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<int>? costCents,
      Value<int>? salePriceCents,
      Value<int>? taxRateBps,
      Value<String?>? reason,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PriceHistoryCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      costCents: costCents ?? this.costCents,
      salePriceCents: salePriceCents ?? this.salePriceCents,
      taxRateBps: taxRateBps ?? this.taxRateBps,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (costCents.present) {
      map['cost_cents'] = Variable<int>(costCents.value);
    }
    if (salePriceCents.present) {
      map['sale_price_cents'] = Variable<int>(salePriceCents.value);
    }
    if (taxRateBps.present) {
      map['tax_rate_bps'] = Variable<int>(taxRateBps.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceHistoryCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('costCents: $costCents, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('taxRateBps: $taxRateBps, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductOffersTable extends ProductOffers
    with TableInfo<$ProductOffersTable, ProductOffer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductOffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _offerTypeMeta =
      const VerificationMeta('offerType');
  @override
  late final GeneratedColumn<String> offerType = GeneratedColumn<String>(
      'offer_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startAtMeta =
      const VerificationMeta('startAt');
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
      'start_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
      'end_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _conditionsJsonMeta =
      const VerificationMeta('conditionsJson');
  @override
  late final GeneratedColumn<String> conditionsJson = GeneratedColumn<String>(
      'conditions_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        offerType,
        value,
        startAt,
        endAt,
        conditionsJson,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_offers';
  @override
  VerificationContext validateIntegrity(Insertable<ProductOffer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('offer_type')) {
      context.handle(_offerTypeMeta,
          offerType.isAcceptableOrUnknown(data['offer_type']!, _offerTypeMeta));
    } else if (isInserting) {
      context.missing(_offerTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('start_at')) {
      context.handle(_startAtMeta,
          startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta));
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
          _endAtMeta, endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta));
    }
    if (data.containsKey('conditions_json')) {
      context.handle(
          _conditionsJsonMeta,
          conditionsJson.isAcceptableOrUnknown(
              data['conditions_json']!, _conditionsJsonMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductOffer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductOffer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      offerType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}offer_type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
      startAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_at'])!,
      endAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_at']),
      conditionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions_json']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ProductOffersTable createAlias(String alias) {
    return $ProductOffersTable(attachedDatabase, alias);
  }
}

class ProductOffer extends DataClass implements Insertable<ProductOffer> {
  final String id;
  final String productId;
  final String offerType;
  final int value;
  final DateTime startAt;
  final DateTime? endAt;
  final String? conditionsJson;
  final bool isActive;
  const ProductOffer(
      {required this.id,
      required this.productId,
      required this.offerType,
      required this.value,
      required this.startAt,
      this.endAt,
      this.conditionsJson,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['offer_type'] = Variable<String>(offerType);
    map['value'] = Variable<int>(value);
    map['start_at'] = Variable<DateTime>(startAt);
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    if (!nullToAbsent || conditionsJson != null) {
      map['conditions_json'] = Variable<String>(conditionsJson);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductOffersCompanion toCompanion(bool nullToAbsent) {
    return ProductOffersCompanion(
      id: Value(id),
      productId: Value(productId),
      offerType: Value(offerType),
      value: Value(value),
      startAt: Value(startAt),
      endAt:
          endAt == null && nullToAbsent ? const Value.absent() : Value(endAt),
      conditionsJson: conditionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionsJson),
      isActive: Value(isActive),
    );
  }

  factory ProductOffer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductOffer(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      offerType: serializer.fromJson<String>(json['offerType']),
      value: serializer.fromJson<int>(json['value']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      conditionsJson: serializer.fromJson<String?>(json['conditionsJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'offerType': serializer.toJson<String>(offerType),
      'value': serializer.toJson<int>(value),
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'conditionsJson': serializer.toJson<String?>(conditionsJson),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ProductOffer copyWith(
          {String? id,
          String? productId,
          String? offerType,
          int? value,
          DateTime? startAt,
          Value<DateTime?> endAt = const Value.absent(),
          Value<String?> conditionsJson = const Value.absent(),
          bool? isActive}) =>
      ProductOffer(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        offerType: offerType ?? this.offerType,
        value: value ?? this.value,
        startAt: startAt ?? this.startAt,
        endAt: endAt.present ? endAt.value : this.endAt,
        conditionsJson:
            conditionsJson.present ? conditionsJson.value : this.conditionsJson,
        isActive: isActive ?? this.isActive,
      );
  ProductOffer copyWithCompanion(ProductOffersCompanion data) {
    return ProductOffer(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      offerType: data.offerType.present ? data.offerType.value : this.offerType,
      value: data.value.present ? data.value.value : this.value,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      conditionsJson: data.conditionsJson.present
          ? data.conditionsJson.value
          : this.conditionsJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductOffer(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('offerType: $offerType, ')
          ..write('value: $value, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('conditionsJson: $conditionsJson, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, offerType, value, startAt,
      endAt, conditionsJson, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductOffer &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.offerType == this.offerType &&
          other.value == this.value &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.conditionsJson == this.conditionsJson &&
          other.isActive == this.isActive);
}

class ProductOffersCompanion extends UpdateCompanion<ProductOffer> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> offerType;
  final Value<int> value;
  final Value<DateTime> startAt;
  final Value<DateTime?> endAt;
  final Value<String?> conditionsJson;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductOffersCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.offerType = const Value.absent(),
    this.value = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.conditionsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductOffersCompanion.insert({
    required String id,
    required String productId,
    required String offerType,
    required int value,
    required DateTime startAt,
    this.endAt = const Value.absent(),
    this.conditionsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        offerType = Value(offerType),
        value = Value(value),
        startAt = Value(startAt);
  static Insertable<ProductOffer> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? offerType,
    Expression<int>? value,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<String>? conditionsJson,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (offerType != null) 'offer_type': offerType,
      if (value != null) 'value': value,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (conditionsJson != null) 'conditions_json': conditionsJson,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductOffersCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? offerType,
      Value<int>? value,
      Value<DateTime>? startAt,
      Value<DateTime?>? endAt,
      Value<String?>? conditionsJson,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ProductOffersCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      offerType: offerType ?? this.offerType,
      value: value ?? this.value,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      conditionsJson: conditionsJson ?? this.conditionsJson,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (offerType.present) {
      map['offer_type'] = Variable<String>(offerType.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (conditionsJson.present) {
      map['conditions_json'] = Variable<String>(conditionsJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductOffersCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('offerType: $offerType, ')
          ..write('value: $value, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('conditionsJson: $conditionsJson, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductDiscountsTable extends ProductDiscounts
    with TableInfo<$ProductDiscountsTable, ProductDiscount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductDiscountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _discountTypeMeta =
      const VerificationMeta('discountType');
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
      'discount_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
      'value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _startAtMeta =
      const VerificationMeta('startAt');
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
      'start_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
      'end_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _conditionsJsonMeta =
      const VerificationMeta('conditionsJson');
  @override
  late final GeneratedColumn<String> conditionsJson = GeneratedColumn<String>(
      'conditions_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        discountType,
        value,
        startAt,
        endAt,
        conditionsJson,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_discounts';
  @override
  VerificationContext validateIntegrity(Insertable<ProductDiscount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('discount_type')) {
      context.handle(
          _discountTypeMeta,
          discountType.isAcceptableOrUnknown(
              data['discount_type']!, _discountTypeMeta));
    } else if (isInserting) {
      context.missing(_discountTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('start_at')) {
      context.handle(_startAtMeta,
          startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta));
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
          _endAtMeta, endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta));
    }
    if (data.containsKey('conditions_json')) {
      context.handle(
          _conditionsJsonMeta,
          conditionsJson.isAcceptableOrUnknown(
              data['conditions_json']!, _conditionsJsonMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductDiscount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductDiscount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      discountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discount_type'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}value'])!,
      startAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_at'])!,
      endAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_at']),
      conditionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conditions_json']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ProductDiscountsTable createAlias(String alias) {
    return $ProductDiscountsTable(attachedDatabase, alias);
  }
}

class ProductDiscount extends DataClass implements Insertable<ProductDiscount> {
  final String id;
  final String productId;
  final String discountType;
  final int value;
  final DateTime startAt;
  final DateTime? endAt;
  final String? conditionsJson;
  final bool isActive;
  const ProductDiscount(
      {required this.id,
      required this.productId,
      required this.discountType,
      required this.value,
      required this.startAt,
      this.endAt,
      this.conditionsJson,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['discount_type'] = Variable<String>(discountType);
    map['value'] = Variable<int>(value);
    map['start_at'] = Variable<DateTime>(startAt);
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    if (!nullToAbsent || conditionsJson != null) {
      map['conditions_json'] = Variable<String>(conditionsJson);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductDiscountsCompanion toCompanion(bool nullToAbsent) {
    return ProductDiscountsCompanion(
      id: Value(id),
      productId: Value(productId),
      discountType: Value(discountType),
      value: Value(value),
      startAt: Value(startAt),
      endAt:
          endAt == null && nullToAbsent ? const Value.absent() : Value(endAt),
      conditionsJson: conditionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(conditionsJson),
      isActive: Value(isActive),
    );
  }

  factory ProductDiscount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductDiscount(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      discountType: serializer.fromJson<String>(json['discountType']),
      value: serializer.fromJson<int>(json['value']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      conditionsJson: serializer.fromJson<String?>(json['conditionsJson']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'discountType': serializer.toJson<String>(discountType),
      'value': serializer.toJson<int>(value),
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'conditionsJson': serializer.toJson<String?>(conditionsJson),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ProductDiscount copyWith(
          {String? id,
          String? productId,
          String? discountType,
          int? value,
          DateTime? startAt,
          Value<DateTime?> endAt = const Value.absent(),
          Value<String?> conditionsJson = const Value.absent(),
          bool? isActive}) =>
      ProductDiscount(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        discountType: discountType ?? this.discountType,
        value: value ?? this.value,
        startAt: startAt ?? this.startAt,
        endAt: endAt.present ? endAt.value : this.endAt,
        conditionsJson:
            conditionsJson.present ? conditionsJson.value : this.conditionsJson,
        isActive: isActive ?? this.isActive,
      );
  ProductDiscount copyWithCompanion(ProductDiscountsCompanion data) {
    return ProductDiscount(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      value: data.value.present ? data.value.value : this.value,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      conditionsJson: data.conditionsJson.present
          ? data.conditionsJson.value
          : this.conditionsJson,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductDiscount(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('discountType: $discountType, ')
          ..write('value: $value, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('conditionsJson: $conditionsJson, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, discountType, value, startAt,
      endAt, conditionsJson, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductDiscount &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.discountType == this.discountType &&
          other.value == this.value &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.conditionsJson == this.conditionsJson &&
          other.isActive == this.isActive);
}

class ProductDiscountsCompanion extends UpdateCompanion<ProductDiscount> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> discountType;
  final Value<int> value;
  final Value<DateTime> startAt;
  final Value<DateTime?> endAt;
  final Value<String?> conditionsJson;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ProductDiscountsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.discountType = const Value.absent(),
    this.value = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.conditionsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductDiscountsCompanion.insert({
    required String id,
    required String productId,
    required String discountType,
    required int value,
    required DateTime startAt,
    this.endAt = const Value.absent(),
    this.conditionsJson = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        discountType = Value(discountType),
        value = Value(value),
        startAt = Value(startAt);
  static Insertable<ProductDiscount> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? discountType,
    Expression<int>? value,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<String>? conditionsJson,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (discountType != null) 'discount_type': discountType,
      if (value != null) 'value': value,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (conditionsJson != null) 'conditions_json': conditionsJson,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductDiscountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? discountType,
      Value<int>? value,
      Value<DateTime>? startAt,
      Value<DateTime?>? endAt,
      Value<String?>? conditionsJson,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ProductDiscountsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      discountType: discountType ?? this.discountType,
      value: value ?? this.value,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      conditionsJson: conditionsJson ?? this.conditionsJson,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (conditionsJson.present) {
      map['conditions_json'] = Variable<String>(conditionsJson.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductDiscountsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('discountType: $discountType, ')
          ..write('value: $value, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('conditionsJson: $conditionsJson, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsJsonMeta =
      const VerificationMeta('tagsJson');
  @override
  late final GeneratedColumn<String> tagsJson = GeneratedColumn<String>(
      'tags_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        content,
        tagsJson,
        isPinned,
        isArchived,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(Insertable<Note> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('tags_json')) {
      context.handle(_tagsJsonMeta,
          tagsJson.isAcceptableOrUnknown(data['tags_json']!, _tagsJsonMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      tagsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags_json']),
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String title;
  final String content;
  final String? tagsJson;
  final bool isPinned;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note(
      {required this.id,
      required this.title,
      required this.content,
      this.tagsJson,
      required this.isPinned,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || tagsJson != null) {
      map['tags_json'] = Variable<String>(tagsJson);
    }
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      tagsJson: tagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tagsJson),
      isPinned: Value(isPinned),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      tagsJson: serializer.fromJson<String?>(json['tagsJson']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'tagsJson': serializer.toJson<String?>(tagsJson),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith(
          {String? id,
          String? title,
          String? content,
          Value<String?> tagsJson = const Value.absent(),
          bool? isPinned,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        content: content ?? this.content,
        tagsJson: tagsJson.present ? tagsJson.value : this.tagsJson,
        isPinned: isPinned ?? this.isPinned,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      tagsJson: data.tagsJson.present ? data.tagsJson.value : this.tagsJson,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('isPinned: $isPinned, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, content, tagsJson, isPinned, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.tagsJson == this.tagsJson &&
          other.isPinned == this.isPinned &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<String?> tagsJson;
  final Value<bool> isPinned;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.tagsJson = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String title,
    required String content,
    this.tagsJson = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        content = Value(content),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? tagsJson,
    Expression<bool>? isPinned,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (tagsJson != null) 'tags_json': tagsJson,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? content,
      Value<String?>? tagsJson,
      Value<bool>? isPinned,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return NotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tagsJson: tagsJson ?? this.tagsJson,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (tagsJson.present) {
      map['tags_json'] = Variable<String>(tagsJson.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('tagsJson: $tagsJson, ')
          ..write('isPinned: $isPinned, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
      'due_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
      'priority', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('normal'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, description, dueAt, priority, status, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('due_at')) {
      context.handle(
          _dueAtMeta, dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta));
    } else if (isInserting) {
      context.missing(_dueAtMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_at'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String title;
  final String? description;
  final DateTime dueAt;
  final String priority;
  final String status;
  final DateTime? completedAt;
  const Reminder(
      {required this.id,
      required this.title,
      this.description,
      required this.dueAt,
      required this.priority,
      required this.status,
      this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['due_at'] = Variable<DateTime>(dueAt);
    map['priority'] = Variable<String>(priority);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dueAt: Value(dueAt),
      priority: Value(priority),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dueAt: serializer.fromJson<DateTime>(json['dueAt']),
      priority: serializer.fromJson<String>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dueAt': serializer.toJson<DateTime>(dueAt),
      'priority': serializer.toJson<String>(priority),
      'status': serializer.toJson<String>(status),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  Reminder copyWith(
          {String? id,
          String? title,
          Value<String?> description = const Value.absent(),
          DateTime? dueAt,
          String? priority,
          String? status,
          Value<DateTime?> completedAt = const Value.absent()}) =>
      Reminder(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dueAt: dueAt ?? this.dueAt,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueAt: $dueAt, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, description, dueAt, priority, status, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.dueAt == this.dueAt &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.completedAt == this.completedAt);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> dueAt;
  final Value<String> priority;
  final Value<String> status;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    required DateTime dueAt,
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        dueAt = Value(dueAt);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? dueAt,
    Expression<String>? priority,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dueAt != null) 'due_at': dueAt,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String?>? description,
      Value<DateTime>? dueAt,
      Value<String>? priority,
      Value<String>? status,
      Value<DateTime?>? completedAt,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueAt: dueAt ?? this.dueAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dueAt: $dueAt, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistsTable extends Checklists
    with TableInfo<$ChecklistsTable, Checklist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, isArchived, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklists';
  @override
  VerificationContext validateIntegrity(Insertable<Checklist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Checklist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checklist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ChecklistsTable createAlias(String alias) {
    return $ChecklistsTable(attachedDatabase, alias);
  }
}

class Checklist extends DataClass implements Insertable<Checklist> {
  final String id;
  final String title;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Checklist(
      {required this.id,
      required this.title,
      required this.isArchived,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChecklistsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistsCompanion(
      id: Value(id),
      title: Value(title),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Checklist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checklist(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Checklist copyWith(
          {String? id,
          String? title,
          bool? isArchived,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Checklist(
        id: id ?? this.id,
        title: title ?? this.title,
        isArchived: isArchived ?? this.isArchived,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Checklist copyWithCompanion(ChecklistsCompanion data) {
    return Checklist(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checklist(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, isArchived, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checklist &&
          other.id == this.id &&
          other.title == this.title &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChecklistsCompanion extends UpdateCompanion<Checklist> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChecklistsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistsCompanion.insert({
    required String id,
    required String title,
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Checklist> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<bool>? isArchived,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ChecklistsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistItemsTable extends ChecklistItems
    with TableInfo<$ChecklistItemsTable, ChecklistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _checklistIdMeta =
      const VerificationMeta('checklistId');
  @override
  late final GeneratedColumn<String> checklistId = GeneratedColumn<String>(
      'checklist_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES checklists (id)'));
  static const VerificationMeta _textValueMeta =
      const VerificationMeta('textValue');
  @override
  late final GeneratedColumn<String> textValue = GeneratedColumn<String>(
      'text_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _positionMeta =
      const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
      'position', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isDoneMeta = const VerificationMeta('isDone');
  @override
  late final GeneratedColumn<bool> isDone = GeneratedColumn<bool>(
      'is_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_done" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, checklistId, textValue, position, isDone];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_items';
  @override
  VerificationContext validateIntegrity(Insertable<ChecklistItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('checklist_id')) {
      context.handle(
          _checklistIdMeta,
          checklistId.isAcceptableOrUnknown(
              data['checklist_id']!, _checklistIdMeta));
    } else if (isInserting) {
      context.missing(_checklistIdMeta);
    }
    if (data.containsKey('text_value')) {
      context.handle(_textValueMeta,
          textValue.isAcceptableOrUnknown(data['text_value']!, _textValueMeta));
    } else if (isInserting) {
      context.missing(_textValueMeta);
    }
    if (data.containsKey('position')) {
      context.handle(_positionMeta,
          position.isAcceptableOrUnknown(data['position']!, _positionMeta));
    }
    if (data.containsKey('is_done')) {
      context.handle(_isDoneMeta,
          isDone.isAcceptableOrUnknown(data['is_done']!, _isDoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChecklistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      checklistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}checklist_id'])!,
      textValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_value'])!,
      position: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}position'])!,
      isDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_done'])!,
    );
  }

  @override
  $ChecklistItemsTable createAlias(String alias) {
    return $ChecklistItemsTable(attachedDatabase, alias);
  }
}

class ChecklistItem extends DataClass implements Insertable<ChecklistItem> {
  final String id;
  final String checklistId;
  final String textValue;
  final int position;
  final bool isDone;
  const ChecklistItem(
      {required this.id,
      required this.checklistId,
      required this.textValue,
      required this.position,
      required this.isDone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checklist_id'] = Variable<String>(checklistId);
    map['text_value'] = Variable<String>(textValue);
    map['position'] = Variable<int>(position);
    map['is_done'] = Variable<bool>(isDone);
    return map;
  }

  ChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistItemsCompanion(
      id: Value(id),
      checklistId: Value(checklistId),
      textValue: Value(textValue),
      position: Value(position),
      isDone: Value(isDone),
    );
  }

  factory ChecklistItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistItem(
      id: serializer.fromJson<String>(json['id']),
      checklistId: serializer.fromJson<String>(json['checklistId']),
      textValue: serializer.fromJson<String>(json['textValue']),
      position: serializer.fromJson<int>(json['position']),
      isDone: serializer.fromJson<bool>(json['isDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checklistId': serializer.toJson<String>(checklistId),
      'textValue': serializer.toJson<String>(textValue),
      'position': serializer.toJson<int>(position),
      'isDone': serializer.toJson<bool>(isDone),
    };
  }

  ChecklistItem copyWith(
          {String? id,
          String? checklistId,
          String? textValue,
          int? position,
          bool? isDone}) =>
      ChecklistItem(
        id: id ?? this.id,
        checklistId: checklistId ?? this.checklistId,
        textValue: textValue ?? this.textValue,
        position: position ?? this.position,
        isDone: isDone ?? this.isDone,
      );
  ChecklistItem copyWithCompanion(ChecklistItemsCompanion data) {
    return ChecklistItem(
      id: data.id.present ? data.id.value : this.id,
      checklistId:
          data.checklistId.present ? data.checklistId.value : this.checklistId,
      textValue: data.textValue.present ? data.textValue.value : this.textValue,
      position: data.position.present ? data.position.value : this.position,
      isDone: data.isDone.present ? data.isDone.value : this.isDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItem(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('textValue: $textValue, ')
          ..write('position: $position, ')
          ..write('isDone: $isDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, checklistId, textValue, position, isDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistItem &&
          other.id == this.id &&
          other.checklistId == this.checklistId &&
          other.textValue == this.textValue &&
          other.position == this.position &&
          other.isDone == this.isDone);
}

class ChecklistItemsCompanion extends UpdateCompanion<ChecklistItem> {
  final Value<String> id;
  final Value<String> checklistId;
  final Value<String> textValue;
  final Value<int> position;
  final Value<bool> isDone;
  final Value<int> rowid;
  const ChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.checklistId = const Value.absent(),
    this.textValue = const Value.absent(),
    this.position = const Value.absent(),
    this.isDone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistItemsCompanion.insert({
    required String id,
    required String checklistId,
    required String textValue,
    this.position = const Value.absent(),
    this.isDone = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        checklistId = Value(checklistId),
        textValue = Value(textValue);
  static Insertable<ChecklistItem> custom({
    Expression<String>? id,
    Expression<String>? checklistId,
    Expression<String>? textValue,
    Expression<int>? position,
    Expression<bool>? isDone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklistId != null) 'checklist_id': checklistId,
      if (textValue != null) 'text_value': textValue,
      if (position != null) 'position': position,
      if (isDone != null) 'is_done': isDone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? checklistId,
      Value<String>? textValue,
      Value<int>? position,
      Value<bool>? isDone,
      Value<int>? rowid}) {
    return ChecklistItemsCompanion(
      id: id ?? this.id,
      checklistId: checklistId ?? this.checklistId,
      textValue: textValue ?? this.textValue,
      position: position ?? this.position,
      isDone: isDone ?? this.isDone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checklistId.present) {
      map['checklist_id'] = Variable<String>(checklistId.value);
    }
    if (textValue.present) {
      map['text_value'] = Variable<String>(textValue.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (isDone.present) {
      map['is_done'] = Variable<bool>(isDone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('textValue: $textValue, ')
          ..write('position: $position, ')
          ..write('isDone: $isDone, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueJsonMeta =
      const VerificationMeta('valueJson');
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
      'value_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(_valueJsonMeta,
          valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta));
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      valueJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String valueJson;
  final DateTime updatedAt;
  const Setting(
      {required this.key, required this.valueJson, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith({String? key, String? valueJson, DateTime? updatedAt}) =>
      Setting(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String valueJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        valueJson = Value(valueJson),
        updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? key,
      Value<String>? valueJson,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SettingsCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogsTable extends AuditLogs
    with TableInfo<$AuditLogsTable, AuditLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beforeJsonMeta =
      const VerificationMeta('beforeJson');
  @override
  late final GeneratedColumn<String> beforeJson = GeneratedColumn<String>(
      'before_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _afterJsonMeta =
      const VerificationMeta('afterJson');
  @override
  late final GeneratedColumn<String> afterJson = GeneratedColumn<String>(
      'after_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        entityType,
        entityId,
        action,
        beforeJson,
        afterJson,
        createdAt,
        userId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_logs';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('before_json')) {
      context.handle(
          _beforeJsonMeta,
          beforeJson.isAcceptableOrUnknown(
              data['before_json']!, _beforeJsonMeta));
    }
    if (data.containsKey('after_json')) {
      context.handle(_afterJsonMeta,
          afterJson.isAcceptableOrUnknown(data['after_json']!, _afterJsonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      beforeJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}before_json']),
      afterJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}after_json']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
    );
  }

  @override
  $AuditLogsTable createAlias(String alias) {
    return $AuditLogsTable(attachedDatabase, alias);
  }
}

class AuditLog extends DataClass implements Insertable<AuditLog> {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String? beforeJson;
  final String? afterJson;
  final DateTime createdAt;
  final String? userId;
  const AuditLog(
      {required this.id,
      required this.entityType,
      required this.entityId,
      required this.action,
      this.beforeJson,
      this.afterJson,
      required this.createdAt,
      this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || beforeJson != null) {
      map['before_json'] = Variable<String>(beforeJson);
    }
    if (!nullToAbsent || afterJson != null) {
      map['after_json'] = Variable<String>(afterJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    return map;
  }

  AuditLogsCompanion toCompanion(bool nullToAbsent) {
    return AuditLogsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      beforeJson: beforeJson == null && nullToAbsent
          ? const Value.absent()
          : Value(beforeJson),
      afterJson: afterJson == null && nullToAbsent
          ? const Value.absent()
          : Value(afterJson),
      createdAt: Value(createdAt),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
    );
  }

  factory AuditLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLog(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      beforeJson: serializer.fromJson<String?>(json['beforeJson']),
      afterJson: serializer.fromJson<String?>(json['afterJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      userId: serializer.fromJson<String?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'beforeJson': serializer.toJson<String?>(beforeJson),
      'afterJson': serializer.toJson<String?>(afterJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'userId': serializer.toJson<String?>(userId),
    };
  }

  AuditLog copyWith(
          {String? id,
          String? entityType,
          String? entityId,
          String? action,
          Value<String?> beforeJson = const Value.absent(),
          Value<String?> afterJson = const Value.absent(),
          DateTime? createdAt,
          Value<String?> userId = const Value.absent()}) =>
      AuditLog(
        id: id ?? this.id,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        action: action ?? this.action,
        beforeJson: beforeJson.present ? beforeJson.value : this.beforeJson,
        afterJson: afterJson.present ? afterJson.value : this.afterJson,
        createdAt: createdAt ?? this.createdAt,
        userId: userId.present ? userId.value : this.userId,
      );
  AuditLog copyWithCompanion(AuditLogsCompanion data) {
    return AuditLog(
      id: data.id.present ? data.id.value : this.id,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      beforeJson:
          data.beforeJson.present ? data.beforeJson.value : this.beforeJson,
      afterJson: data.afterJson.present ? data.afterJson.value : this.afterJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLog(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entityType, entityId, action, beforeJson,
      afterJson, createdAt, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLog &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.beforeJson == this.beforeJson &&
          other.afterJson == this.afterJson &&
          other.createdAt == this.createdAt &&
          other.userId == this.userId);
}

class AuditLogsCompanion extends UpdateCompanion<AuditLog> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> beforeJson;
  final Value<String?> afterJson;
  final Value<DateTime> createdAt;
  final Value<String?> userId;
  final Value<int> rowid;
  const AuditLogsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.beforeJson = const Value.absent(),
    this.afterJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogsCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String action,
    this.beforeJson = const Value.absent(),
    this.afterJson = const Value.absent(),
    required DateTime createdAt,
    this.userId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityType = Value(entityType),
        entityId = Value(entityId),
        action = Value(action),
        createdAt = Value(createdAt);
  static Insertable<AuditLog> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? beforeJson,
    Expression<String>? afterJson,
    Expression<DateTime>? createdAt,
    Expression<String>? userId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (beforeJson != null) 'before_json': beforeJson,
      if (afterJson != null) 'after_json': afterJson,
      if (createdAt != null) 'created_at': createdAt,
      if (userId != null) 'user_id': userId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? action,
      Value<String?>? beforeJson,
      Value<String?>? afterJson,
      Value<DateTime>? createdAt,
      Value<String?>? userId,
      Value<int>? rowid}) {
    return AuditLogsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      beforeJson: beforeJson ?? this.beforeJson,
      afterJson: afterJson ?? this.afterJson,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (beforeJson.present) {
      map['before_json'] = Variable<String>(beforeJson.value);
    }
    if (afterJson.present) {
      map['after_json'] = Variable<String>(afterJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('beforeJson: $beforeJson, ')
          ..write('afterJson: $afterJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('userId: $userId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $TaxProfilesTable taxProfiles = $TaxProfilesTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductBatchesTable productBatches = $ProductBatchesTable(this);
  late final $PurchasesTable purchases = $PurchasesTable(this);
  late final $PurchaseItemsTable purchaseItems = $PurchaseItemsTable(this);
  late final $ReservationsTable reservations = $ReservationsTable(this);
  late final $ReservationItemsTable reservationItems =
      $ReservationItemsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $BatchAllocationsTable batchAllocations =
      $BatchAllocationsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $ReturnsTable returns = $ReturnsTable(this);
  late final $ReturnItemsTable returnItems = $ReturnItemsTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PriceHistoryTable priceHistory = $PriceHistoryTable(this);
  late final $ProductOffersTable productOffers = $ProductOffersTable(this);
  late final $ProductDiscountsTable productDiscounts =
      $ProductDiscountsTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $ChecklistsTable checklists = $ChecklistsTable(this);
  late final $ChecklistItemsTable checklistItems = $ChecklistItemsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $AuditLogsTable auditLogs = $AuditLogsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        categories,
        taxProfiles,
        suppliers,
        customers,
        products,
        productBatches,
        purchases,
        purchaseItems,
        reservations,
        reservationItems,
        sales,
        saleItems,
        batchAllocations,
        stockMovements,
        returns,
        returnItems,
        expenseCategories,
        expenses,
        priceHistory,
        productOffers,
        productDiscounts,
        notes,
        reminders,
        checklists,
        checklistItems,
        settings,
        auditLogs
      ];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String name,
  Value<String?> parentId,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentId,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.products,
          aliasName: 'categories__id__products__category_id');

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool parentId, bool productsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            parentId: parentId,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            parentId: parentId,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentId = false, productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$CategoriesTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$CategoriesTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<Category, $CategoriesTable,
                            Product>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .productsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (Category, $$CategoriesTableReferences),
    Category,
    PrefetchHooks Function({bool parentId, bool productsRefs})>;
typedef $$TaxProfilesTableCreateCompanionBuilder = TaxProfilesCompanion
    Function({
  required String id,
  required String name,
  Value<int> rateBps,
  Value<bool> isDefault,
  Value<bool> isActive,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TaxProfilesTableUpdateCompanionBuilder = TaxProfilesCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> rateBps,
  Value<bool> isDefault,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$TaxProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $TaxProfilesTable, TaxProfile> {
  $$TaxProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<Product>> _productsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.products,
          aliasName: 'tax_profiles__id__products__tax_profile_id');

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products).filter(
        (f) => f.taxProfileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TaxProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $TaxProfilesTable> {
  $$TaxProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rateBps => $composableBuilder(
      column: $table.rateBps, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.taxProfileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TaxProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $TaxProfilesTable> {
  $$TaxProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rateBps => $composableBuilder(
      column: $table.rateBps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TaxProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaxProfilesTable> {
  $$TaxProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get rateBps =>
      $composableBuilder(column: $table.rateBps, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.taxProfileId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TaxProfilesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TaxProfilesTable,
    TaxProfile,
    $$TaxProfilesTableFilterComposer,
    $$TaxProfilesTableOrderingComposer,
    $$TaxProfilesTableAnnotationComposer,
    $$TaxProfilesTableCreateCompanionBuilder,
    $$TaxProfilesTableUpdateCompanionBuilder,
    (TaxProfile, $$TaxProfilesTableReferences),
    TaxProfile,
    PrefetchHooks Function({bool productsRefs})> {
  $$TaxProfilesTableTableManager(_$AppDatabase db, $TaxProfilesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaxProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaxProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaxProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> rateBps = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaxProfilesCompanion(
            id: id,
            name: name,
            rateBps: rateBps,
            isDefault: isDefault,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<int> rateBps = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TaxProfilesCompanion.insert(
            id: id,
            name: name,
            rateBps: rateBps,
            isDefault: isDefault,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TaxProfilesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<TaxProfile, $TaxProfilesTable,
                            Product>(
                        currentTable: table,
                        referencedTable:
                            $$TaxProfilesTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TaxProfilesTableReferences(db, table, p0)
                                .productsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.taxProfileId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TaxProfilesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TaxProfilesTable,
    TaxProfile,
    $$TaxProfilesTableFilterComposer,
    $$TaxProfilesTableOrderingComposer,
    $$TaxProfilesTableAnnotationComposer,
    $$TaxProfilesTableCreateCompanionBuilder,
    $$TaxProfilesTableUpdateCompanionBuilder,
    (TaxProfile, $$TaxProfilesTableReferences),
    TaxProfile,
    PrefetchHooks Function({bool productsRefs})>;
typedef $$SuppliersTableCreateCompanionBuilder = SuppliersCompanion Function({
  required String id,
  required String name,
  Value<String?> legalName,
  Value<String?> cuit,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SuppliersTableUpdateCompanionBuilder = SuppliersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> legalName,
  Value<String?> cuit,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> address,
  Value<String?> notes,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$SuppliersTableReferences
    extends BaseReferences<_$AppDatabase, $SuppliersTable, Supplier> {
  $$SuppliersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductBatchesTable, List<ProductBatche>>
      _productBatchesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productBatches,
              aliasName: 'suppliers__id__product_batches__supplier_id');

  $$ProductBatchesTableProcessedTableManager get productBatchesRefs {
    final manager = $$ProductBatchesTableTableManager($_db, $_db.productBatches)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productBatchesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchasesTable, List<Purchase>>
      _purchasesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchases,
              aliasName: 'suppliers__id__purchases__supplier_id');

  $$PurchasesTableProcessedTableManager get purchasesRefs {
    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchasesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: 'suppliers__id__expenses__supplier_id');

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses)
        .filter((f) => f.supplierId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalName => $composableBuilder(
      column: $table.legalName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cuit => $composableBuilder(
      column: $table.cuit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> productBatchesRefs(
      Expression<bool> Function($$ProductBatchesTableFilterComposer f) f) {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableFilterComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchasesRefs(
      Expression<bool> Function($$PurchasesTableFilterComposer f) f) {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalName => $composableBuilder(
      column: $table.legalName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cuit => $composableBuilder(
      column: $table.cuit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get cuit =>
      $composableBuilder(column: $table.cuit, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productBatchesRefs<T extends Object>(
      Expression<T> Function($$ProductBatchesTableAnnotationComposer a) f) {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchasesRefs<T extends Object>(
      Expression<T> Function($$PurchasesTableAnnotationComposer a) f) {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.supplierId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SuppliersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function(
        {bool productBatchesRefs, bool purchasesRefs, bool expensesRefs})> {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> legalName = const Value.absent(),
            Value<String?> cuit = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion(
            id: id,
            name: name,
            legalName: legalName,
            cuit: cuit,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> legalName = const Value.absent(),
            Value<String?> cuit = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SuppliersCompanion.insert(
            id: id,
            name: name,
            legalName: legalName,
            cuit: cuit,
            phone: phone,
            email: email,
            address: address,
            notes: notes,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SuppliersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {productBatchesRefs = false,
              purchasesRefs = false,
              expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productBatchesRefs) db.productBatches,
                if (purchasesRefs) db.purchases,
                if (expensesRefs) db.expenses
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productBatchesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            ProductBatche>(
                        currentTable: table,
                        referencedTable: $$SuppliersTableReferences
                            ._productBatchesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .productBatchesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items),
                  if (purchasesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            Purchase>(
                        currentTable: table,
                        referencedTable:
                            $$SuppliersTableReferences._purchasesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .purchasesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items),
                  if (expensesRefs)
                    await $_getPrefetchedData<Supplier, $SuppliersTable,
                            Expense>(
                        currentTable: table,
                        referencedTable:
                            $$SuppliersTableReferences._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SuppliersTableReferences(db, table, p0)
                                .expensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.supplierId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SuppliersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SuppliersTable,
    Supplier,
    $$SuppliersTableFilterComposer,
    $$SuppliersTableOrderingComposer,
    $$SuppliersTableAnnotationComposer,
    $$SuppliersTableCreateCompanionBuilder,
    $$SuppliersTableUpdateCompanionBuilder,
    (Supplier, $$SuppliersTableReferences),
    Supplier,
    PrefetchHooks Function(
        {bool productBatchesRefs, bool purchasesRefs, bool expensesRefs})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  required String id,
  required String name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> document,
  Value<String?> address,
  Value<String?> notes,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> phone,
  Value<String?> email,
  Value<String?> document,
  Value<String?> address,
  Value<String?> notes,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReservationsTable, List<Reservation>>
      _reservationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reservations,
              aliasName: 'customers__id__reservations__customer_id');

  $$ReservationsTableProcessedTableManager get reservationsRefs {
    final manager = $$ReservationsTableTableManager($_db, $_db.reservations)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reservationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName: 'customers__id__sales__customer_id');

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> reservationsRefs(
      Expression<bool> Function($$ReservationsTableFilterComposer f) f) {
    final $$ReservationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableFilterComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get document => $composableBuilder(
      column: $table.document, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get document =>
      $composableBuilder(column: $table.document, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> reservationsRefs<T extends Object>(
      Expression<T> Function($$ReservationsTableAnnotationComposer a) f) {
    final $$ReservationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableAnnotationComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool reservationsRefs, bool salesRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> document = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            name: name,
            phone: phone,
            email: email,
            document: document,
            address: address,
            notes: notes,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> phone = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> document = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            name: name,
            phone: phone,
            email: email,
            document: document,
            address: address,
            notes: notes,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {reservationsRefs = false, salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reservationsRefs) db.reservations,
                if (salesRefs) db.sales
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reservationsRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable,
                            Reservation>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._reservationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .reservationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items),
                  if (salesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable, Sale>(
                        currentTable: table,
                        referencedTable:
                            $$CustomersTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0).salesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    Customer,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (Customer, $$CustomersTableReferences),
    Customer,
    PrefetchHooks Function({bool reservationsRefs, bool salesRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  required String id,
  required String internalCode,
  Value<String?> barcode,
  required String name,
  Value<String?> categoryId,
  Value<String?> subcategory,
  Value<String?> brand,
  Value<String?> description,
  Value<String?> attributesJson,
  Value<String> unit,
  Value<int> unitsPerPack,
  Value<int> stockTotal,
  Value<int> stockReserved,
  Value<int> stockMin,
  Value<int?> stockMax,
  Value<int> costCents,
  Value<int> salePriceCents,
  Value<String?> taxProfileId,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String> internalCode,
  Value<String?> barcode,
  Value<String> name,
  Value<String?> categoryId,
  Value<String?> subcategory,
  Value<String?> brand,
  Value<String?> description,
  Value<String?> attributesJson,
  Value<String> unit,
  Value<int> unitsPerPack,
  Value<int> stockTotal,
  Value<int> stockReserved,
  Value<int> stockMin,
  Value<int?> stockMax,
  Value<int> costCents,
  Value<int> salePriceCents,
  Value<String?> taxProfileId,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('products__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TaxProfilesTable _taxProfileIdTable(_$AppDatabase db) =>
      db.taxProfiles.createAlias('products__tax_profile_id__tax_profiles__id');

  $$TaxProfilesTableProcessedTableManager? get taxProfileId {
    final $_column = $_itemColumn<String>('tax_profile_id');
    if ($_column == null) return null;
    final manager = $$TaxProfilesTableTableManager($_db, $_db.taxProfiles)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taxProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductBatchesTable, List<ProductBatche>>
      _productBatchesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productBatches,
              aliasName: 'products__id__product_batches__product_id');

  $$ProductBatchesTableProcessedTableManager get productBatchesRefs {
    final manager = $$ProductBatchesTableTableManager($_db, $_db.productBatches)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productBatchesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: 'products__id__purchase_items__product_id');

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReservationItemsTable, List<ReservationItem>>
      _reservationItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reservationItems,
              aliasName: 'products__id__reservation_items__product_id');

  $$ReservationItemsTableProcessedTableManager get reservationItemsRefs {
    final manager = $$ReservationItemsTableTableManager(
            $_db, $_db.reservationItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_reservationItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
      _saleItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.saleItems,
              aliasName: 'products__id__sale_items__product_id');

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BatchAllocationsTable, List<BatchAllocation>>
      _batchAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.batchAllocations,
              aliasName: 'products__id__batch_allocations__product_id');

  $$BatchAllocationsTableProcessedTableManager get batchAllocationsRefs {
    final manager = $$BatchAllocationsTableTableManager(
            $_db, $_db.batchAllocations)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_batchAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
      _stockMovementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stockMovements,
              aliasName: 'products__id__stock_movements__product_id');

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PriceHistoryTable, List<PriceHistoryData>>
      _priceHistoryRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.priceHistory,
              aliasName: 'products__id__price_history__product_id');

  $$PriceHistoryTableProcessedTableManager get priceHistoryRefs {
    final manager = $$PriceHistoryTableTableManager($_db, $_db.priceHistory)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_priceHistoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProductOffersTable, List<ProductOffer>>
      _productOffersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productOffers,
              aliasName: 'products__id__product_offers__product_id');

  $$ProductOffersTableProcessedTableManager get productOffersRefs {
    final manager = $$ProductOffersTableTableManager($_db, $_db.productOffers)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productOffersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProductDiscountsTable, List<ProductDiscount>>
      _productDiscountsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.productDiscounts,
              aliasName: 'products__id__product_discounts__product_id');

  $$ProductDiscountsTableProcessedTableManager get productDiscountsRefs {
    final manager = $$ProductDiscountsTableTableManager(
            $_db, $_db.productDiscounts)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_productDiscountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get internalCode => $composableBuilder(
      column: $table.internalCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attributesJson => $composableBuilder(
      column: $table.attributesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitsPerPack => $composableBuilder(
      column: $table.unitsPerPack, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockTotal => $composableBuilder(
      column: $table.stockTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockReserved => $composableBuilder(
      column: $table.stockReserved, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockMin => $composableBuilder(
      column: $table.stockMin, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockMax => $composableBuilder(
      column: $table.stockMax, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get costCents => $composableBuilder(
      column: $table.costCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get salePriceCents => $composableBuilder(
      column: $table.salePriceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TaxProfilesTableFilterComposer get taxProfileId {
    final $$TaxProfilesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taxProfileId,
        referencedTable: $db.taxProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaxProfilesTableFilterComposer(
              $db: $db,
              $table: $db.taxProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productBatchesRefs(
      Expression<bool> Function($$ProductBatchesTableFilterComposer f) f) {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableFilterComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> reservationItemsRefs(
      Expression<bool> Function($$ReservationItemsTableFilterComposer f) f) {
    final $$ReservationItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableFilterComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> saleItemsRefs(
      Expression<bool> Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> batchAllocationsRefs(
      Expression<bool> Function($$BatchAllocationsTableFilterComposer f) f) {
    final $$BatchAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
      Expression<bool> Function($$StockMovementsTableFilterComposer f) f) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableFilterComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> priceHistoryRefs(
      Expression<bool> Function($$PriceHistoryTableFilterComposer f) f) {
    final $$PriceHistoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceHistory,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceHistoryTableFilterComposer(
              $db: $db,
              $table: $db.priceHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> productOffersRefs(
      Expression<bool> Function($$ProductOffersTableFilterComposer f) f) {
    final $$ProductOffersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productOffers,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOffersTableFilterComposer(
              $db: $db,
              $table: $db.productOffers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> productDiscountsRefs(
      Expression<bool> Function($$ProductDiscountsTableFilterComposer f) f) {
    final $$ProductDiscountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productDiscounts,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductDiscountsTableFilterComposer(
              $db: $db,
              $table: $db.productDiscounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get internalCode => $composableBuilder(
      column: $table.internalCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attributesJson => $composableBuilder(
      column: $table.attributesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitsPerPack => $composableBuilder(
      column: $table.unitsPerPack,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockTotal => $composableBuilder(
      column: $table.stockTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockReserved => $composableBuilder(
      column: $table.stockReserved,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockMin => $composableBuilder(
      column: $table.stockMin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockMax => $composableBuilder(
      column: $table.stockMax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get costCents => $composableBuilder(
      column: $table.costCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get salePriceCents => $composableBuilder(
      column: $table.salePriceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TaxProfilesTableOrderingComposer get taxProfileId {
    final $$TaxProfilesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taxProfileId,
        referencedTable: $db.taxProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaxProfilesTableOrderingComposer(
              $db: $db,
              $table: $db.taxProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get internalCode => $composableBuilder(
      column: $table.internalCode, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get subcategory => $composableBuilder(
      column: $table.subcategory, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get attributesJson => $composableBuilder(
      column: $table.attributesJson, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitsPerPack => $composableBuilder(
      column: $table.unitsPerPack, builder: (column) => column);

  GeneratedColumn<int> get stockTotal => $composableBuilder(
      column: $table.stockTotal, builder: (column) => column);

  GeneratedColumn<int> get stockReserved => $composableBuilder(
      column: $table.stockReserved, builder: (column) => column);

  GeneratedColumn<int> get stockMin =>
      $composableBuilder(column: $table.stockMin, builder: (column) => column);

  GeneratedColumn<int> get stockMax =>
      $composableBuilder(column: $table.stockMax, builder: (column) => column);

  GeneratedColumn<int> get costCents =>
      $composableBuilder(column: $table.costCents, builder: (column) => column);

  GeneratedColumn<int> get salePriceCents => $composableBuilder(
      column: $table.salePriceCents, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TaxProfilesTableAnnotationComposer get taxProfileId {
    final $$TaxProfilesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.taxProfileId,
        referencedTable: $db.taxProfiles,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TaxProfilesTableAnnotationComposer(
              $db: $db,
              $table: $db.taxProfiles,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productBatchesRefs<T extends Object>(
      Expression<T> Function($$ProductBatchesTableAnnotationComposer a) f) {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> reservationItemsRefs<T extends Object>(
      Expression<T> Function($$ReservationItemsTableAnnotationComposer a) f) {
    final $$ReservationItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> saleItemsRefs<T extends Object>(
      Expression<T> Function($$SaleItemsTableAnnotationComposer a) f) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> batchAllocationsRefs<T extends Object>(
      Expression<T> Function($$BatchAllocationsTableAnnotationComposer a) f) {
    final $$BatchAllocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
      Expression<T> Function($$StockMovementsTableAnnotationComposer a) f) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> priceHistoryRefs<T extends Object>(
      Expression<T> Function($$PriceHistoryTableAnnotationComposer a) f) {
    final $$PriceHistoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.priceHistory,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PriceHistoryTableAnnotationComposer(
              $db: $db,
              $table: $db.priceHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> productOffersRefs<T extends Object>(
      Expression<T> Function($$ProductOffersTableAnnotationComposer a) f) {
    final $$ProductOffersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productOffers,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductOffersTableAnnotationComposer(
              $db: $db,
              $table: $db.productOffers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> productDiscountsRefs<T extends Object>(
      Expression<T> Function($$ProductDiscountsTableAnnotationComposer a) f) {
    final $$ProductDiscountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.productDiscounts,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductDiscountsTableAnnotationComposer(
              $db: $db,
              $table: $db.productDiscounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool categoryId,
        bool taxProfileId,
        bool productBatchesRefs,
        bool purchaseItemsRefs,
        bool reservationItemsRefs,
        bool saleItemsRefs,
        bool batchAllocationsRefs,
        bool stockMovementsRefs,
        bool priceHistoryRefs,
        bool productOffersRefs,
        bool productDiscountsRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> internalCode = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> attributesJson = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> unitsPerPack = const Value.absent(),
            Value<int> stockTotal = const Value.absent(),
            Value<int> stockReserved = const Value.absent(),
            Value<int> stockMin = const Value.absent(),
            Value<int?> stockMax = const Value.absent(),
            Value<int> costCents = const Value.absent(),
            Value<int> salePriceCents = const Value.absent(),
            Value<String?> taxProfileId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            internalCode: internalCode,
            barcode: barcode,
            name: name,
            categoryId: categoryId,
            subcategory: subcategory,
            brand: brand,
            description: description,
            attributesJson: attributesJson,
            unit: unit,
            unitsPerPack: unitsPerPack,
            stockTotal: stockTotal,
            stockReserved: stockReserved,
            stockMin: stockMin,
            stockMax: stockMax,
            costCents: costCents,
            salePriceCents: salePriceCents,
            taxProfileId: taxProfileId,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String internalCode,
            Value<String?> barcode = const Value.absent(),
            required String name,
            Value<String?> categoryId = const Value.absent(),
            Value<String?> subcategory = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> attributesJson = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> unitsPerPack = const Value.absent(),
            Value<int> stockTotal = const Value.absent(),
            Value<int> stockReserved = const Value.absent(),
            Value<int> stockMin = const Value.absent(),
            Value<int?> stockMax = const Value.absent(),
            Value<int> costCents = const Value.absent(),
            Value<int> salePriceCents = const Value.absent(),
            Value<String?> taxProfileId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            internalCode: internalCode,
            barcode: barcode,
            name: name,
            categoryId: categoryId,
            subcategory: subcategory,
            brand: brand,
            description: description,
            attributesJson: attributesJson,
            unit: unit,
            unitsPerPack: unitsPerPack,
            stockTotal: stockTotal,
            stockReserved: stockReserved,
            stockMin: stockMin,
            stockMax: stockMax,
            costCents: costCents,
            salePriceCents: salePriceCents,
            taxProfileId: taxProfileId,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              taxProfileId = false,
              productBatchesRefs = false,
              purchaseItemsRefs = false,
              reservationItemsRefs = false,
              saleItemsRefs = false,
              batchAllocationsRefs = false,
              stockMovementsRefs = false,
              priceHistoryRefs = false,
              productOffersRefs = false,
              productDiscountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productBatchesRefs) db.productBatches,
                if (purchaseItemsRefs) db.purchaseItems,
                if (reservationItemsRefs) db.reservationItems,
                if (saleItemsRefs) db.saleItems,
                if (batchAllocationsRefs) db.batchAllocations,
                if (stockMovementsRefs) db.stockMovements,
                if (priceHistoryRefs) db.priceHistory,
                if (productOffersRefs) db.productOffers,
                if (productDiscountsRefs) db.productDiscounts
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ProductsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ProductsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (taxProfileId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.taxProfileId,
                    referencedTable:
                        $$ProductsTableReferences._taxProfileIdTable(db),
                    referencedColumn:
                        $$ProductsTableReferences._taxProfileIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productBatchesRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductBatche>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productBatchesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productBatchesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (reservationItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ReservationItem>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._reservationItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .reservationItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            SaleItem>(
                        currentTable: table,
                        referencedTable:
                            $$ProductsTableReferences._saleItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .saleItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (batchAllocationsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            BatchAllocation>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._batchAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .batchAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (stockMovementsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            StockMovement>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._stockMovementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .stockMovementsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (priceHistoryRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            PriceHistoryData>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._priceHistoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .priceHistoryRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (productOffersRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductOffer>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productOffersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productOffersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (productDiscountsRefs)
                    await $_getPrefetchedData<Product, $ProductsTable,
                            ProductDiscount>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._productDiscountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .productDiscountsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    Product,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (Product, $$ProductsTableReferences),
    Product,
    PrefetchHooks Function(
        {bool categoryId,
        bool taxProfileId,
        bool productBatchesRefs,
        bool purchaseItemsRefs,
        bool reservationItemsRefs,
        bool saleItemsRefs,
        bool batchAllocationsRefs,
        bool stockMovementsRefs,
        bool priceHistoryRefs,
        bool productOffersRefs,
        bool productDiscountsRefs})>;
typedef $$ProductBatchesTableCreateCompanionBuilder = ProductBatchesCompanion
    Function({
  required String id,
  required String productId,
  Value<String?> batchCode,
  Value<String?> supplierId,
  required DateTime receivedAt,
  Value<DateTime?> expiresAt,
  required int quantityTotal,
  Value<int> quantityReserved,
  required int unitCostCents,
  Value<String> status,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ProductBatchesTableUpdateCompanionBuilder = ProductBatchesCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<String?> batchCode,
  Value<String?> supplierId,
  Value<DateTime> receivedAt,
  Value<DateTime?> expiresAt,
  Value<int> quantityTotal,
  Value<int> quantityReserved,
  Value<int> unitCostCents,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ProductBatchesTableReferences
    extends BaseReferences<_$AppDatabase, $ProductBatchesTable, ProductBatche> {
  $$ProductBatchesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('product_batches__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('product_batches__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: 'product_batches__id__purchase_items__batch_id');

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$BatchAllocationsTable, List<BatchAllocation>>
      _batchAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.batchAllocations,
              aliasName: 'product_batches__id__batch_allocations__batch_id');

  $$BatchAllocationsTableProcessedTableManager get batchAllocationsRefs {
    final manager =
        $$BatchAllocationsTableTableManager($_db, $_db.batchAllocations)
            .filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_batchAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$StockMovementsTable, List<StockMovement>>
      _stockMovementsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.stockMovements,
              aliasName: 'product_batches__id__stock_movements__batch_id');

  $$StockMovementsTableProcessedTableManager get stockMovementsRefs {
    final manager = $$StockMovementsTableTableManager($_db, $_db.stockMovements)
        .filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovementsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReturnItemsTable, List<ReturnItem>>
      _returnItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.returnItems,
              aliasName: 'product_batches__id__return_items__batch_id');

  $$ReturnItemsTableProcessedTableManager get returnItemsRefs {
    final manager = $$ReturnItemsTableTableManager($_db, $_db.returnItems)
        .filter((f) => f.batchId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchCode => $composableBuilder(
      column: $table.batchCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityTotal => $composableBuilder(
      column: $table.quantityTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityReserved => $composableBuilder(
      column: $table.quantityReserved,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> batchAllocationsRefs(
      Expression<bool> Function($$BatchAllocationsTableFilterComposer f) f) {
    final $$BatchAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> stockMovementsRefs(
      Expression<bool> Function($$StockMovementsTableFilterComposer f) f) {
    final $$StockMovementsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableFilterComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> returnItemsRefs(
      Expression<bool> Function($$ReturnItemsTableFilterComposer f) f) {
    final $$ReturnItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnItems,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnItemsTableFilterComposer(
              $db: $db,
              $table: $db.returnItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchCode => $composableBuilder(
      column: $table.batchCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
      column: $table.expiresAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityTotal => $composableBuilder(
      column: $table.quantityTotal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityReserved => $composableBuilder(
      column: $table.quantityReserved,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchCode =>
      $composableBuilder(column: $table.batchCode, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get quantityTotal => $composableBuilder(
      column: $table.quantityTotal, builder: (column) => column);

  GeneratedColumn<int> get quantityReserved => $composableBuilder(
      column: $table.quantityReserved, builder: (column) => column);

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> batchAllocationsRefs<T extends Object>(
      Expression<T> Function($$BatchAllocationsTableAnnotationComposer a) f) {
    final $$BatchAllocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> stockMovementsRefs<T extends Object>(
      Expression<T> Function($$StockMovementsTableAnnotationComposer a) f) {
    final $$StockMovementsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.stockMovements,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$StockMovementsTableAnnotationComposer(
              $db: $db,
              $table: $db.stockMovements,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> returnItemsRefs<T extends Object>(
      Expression<T> Function($$ReturnItemsTableAnnotationComposer a) f) {
    final $$ReturnItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnItems,
        getReferencedColumn: (t) => t.batchId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductBatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductBatchesTable,
    ProductBatche,
    $$ProductBatchesTableFilterComposer,
    $$ProductBatchesTableOrderingComposer,
    $$ProductBatchesTableAnnotationComposer,
    $$ProductBatchesTableCreateCompanionBuilder,
    $$ProductBatchesTableUpdateCompanionBuilder,
    (ProductBatche, $$ProductBatchesTableReferences),
    ProductBatche,
    PrefetchHooks Function(
        {bool productId,
        bool supplierId,
        bool purchaseItemsRefs,
        bool batchAllocationsRefs,
        bool stockMovementsRefs,
        bool returnItemsRefs})> {
  $$ProductBatchesTableTableManager(
      _$AppDatabase db, $ProductBatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String?> batchCode = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<DateTime> receivedAt = const Value.absent(),
            Value<DateTime?> expiresAt = const Value.absent(),
            Value<int> quantityTotal = const Value.absent(),
            Value<int> quantityReserved = const Value.absent(),
            Value<int> unitCostCents = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductBatchesCompanion(
            id: id,
            productId: productId,
            batchCode: batchCode,
            supplierId: supplierId,
            receivedAt: receivedAt,
            expiresAt: expiresAt,
            quantityTotal: quantityTotal,
            quantityReserved: quantityReserved,
            unitCostCents: unitCostCents,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            Value<String?> batchCode = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            required DateTime receivedAt,
            Value<DateTime?> expiresAt = const Value.absent(),
            required int quantityTotal,
            Value<int> quantityReserved = const Value.absent(),
            required int unitCostCents,
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductBatchesCompanion.insert(
            id: id,
            productId: productId,
            batchCode: batchCode,
            supplierId: supplierId,
            receivedAt: receivedAt,
            expiresAt: expiresAt,
            quantityTotal: quantityTotal,
            quantityReserved: quantityReserved,
            unitCostCents: unitCostCents,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductBatchesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {productId = false,
              supplierId = false,
              purchaseItemsRefs = false,
              batchAllocationsRefs = false,
              stockMovementsRefs = false,
              returnItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseItemsRefs) db.purchaseItems,
                if (batchAllocationsRefs) db.batchAllocations,
                if (stockMovementsRefs) db.stockMovements,
                if (returnItemsRefs) db.returnItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductBatchesTableReferences._productIdTable(db),
                    referencedColumn:
                        $$ProductBatchesTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$ProductBatchesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$ProductBatchesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<ProductBatche, $ProductBatchesTable,
                            PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$ProductBatchesTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductBatchesTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.batchId == item.id),
                        typedResults: items),
                  if (batchAllocationsRefs)
                    await $_getPrefetchedData<ProductBatche,
                            $ProductBatchesTable, BatchAllocation>(
                        currentTable: table,
                        referencedTable: $$ProductBatchesTableReferences
                            ._batchAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductBatchesTableReferences(db, table, p0)
                                .batchAllocationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.batchId == item.id),
                        typedResults: items),
                  if (stockMovementsRefs)
                    await $_getPrefetchedData<ProductBatche,
                            $ProductBatchesTable, StockMovement>(
                        currentTable: table,
                        referencedTable: $$ProductBatchesTableReferences
                            ._stockMovementsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductBatchesTableReferences(db, table, p0)
                                .stockMovementsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.batchId == item.id),
                        typedResults: items),
                  if (returnItemsRefs)
                    await $_getPrefetchedData<ProductBatche,
                            $ProductBatchesTable, ReturnItem>(
                        currentTable: table,
                        referencedTable: $$ProductBatchesTableReferences
                            ._returnItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductBatchesTableReferences(db, table, p0)
                                .returnItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.batchId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductBatchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductBatchesTable,
    ProductBatche,
    $$ProductBatchesTableFilterComposer,
    $$ProductBatchesTableOrderingComposer,
    $$ProductBatchesTableAnnotationComposer,
    $$ProductBatchesTableCreateCompanionBuilder,
    $$ProductBatchesTableUpdateCompanionBuilder,
    (ProductBatche, $$ProductBatchesTableReferences),
    ProductBatche,
    PrefetchHooks Function(
        {bool productId,
        bool supplierId,
        bool purchaseItemsRefs,
        bool batchAllocationsRefs,
        bool stockMovementsRefs,
        bool returnItemsRefs})>;
typedef $$PurchasesTableCreateCompanionBuilder = PurchasesCompanion Function({
  required String id,
  Value<String?> supplierId,
  Value<String> status,
  Value<int> subtotalCents,
  Value<int> taxCents,
  Value<int> totalCents,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PurchasesTableUpdateCompanionBuilder = PurchasesCompanion Function({
  Value<String> id,
  Value<String?> supplierId,
  Value<String> status,
  Value<int> subtotalCents,
  Value<int> taxCents,
  Value<int> totalCents,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PurchasesTableReferences
    extends BaseReferences<_$AppDatabase, $PurchasesTable, Purchase> {
  $$PurchasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('purchases__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PurchaseItemsTable, List<PurchaseItem>>
      _purchaseItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.purchaseItems,
              aliasName: 'purchases__id__purchase_items__purchase_id');

  $$PurchaseItemsTableProcessedTableManager get purchaseItemsRefs {
    final manager = $$PurchaseItemsTableTableManager($_db, $_db.purchaseItems)
        .filter((f) => f.purchaseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_purchaseItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subtotalCents => $composableBuilder(
      column: $table.subtotalCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCents => $composableBuilder(
      column: $table.totalCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> purchaseItemsRefs(
      Expression<bool> Function($$PurchaseItemsTableFilterComposer f) f) {
    final $$PurchaseItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableFilterComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subtotalCents => $composableBuilder(
      column: $table.subtotalCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCents => $composableBuilder(
      column: $table.totalCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTable> {
  $$PurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get subtotalCents => $composableBuilder(
      column: $table.subtotalCents, builder: (column) => column);

  GeneratedColumn<int> get taxCents =>
      $composableBuilder(column: $table.taxCents, builder: (column) => column);

  GeneratedColumn<int> get totalCents => $composableBuilder(
      column: $table.totalCents, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> purchaseItemsRefs<T extends Object>(
      Expression<T> Function($$PurchaseItemsTableAnnotationComposer a) f) {
    final $$PurchaseItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.purchaseItems,
        getReferencedColumn: (t) => t.purchaseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchaseItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.purchaseItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PurchasesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function({bool supplierId, bool purchaseItemsRefs})> {
  $$PurchasesTableTableManager(_$AppDatabase db, $PurchasesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> subtotalCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            Value<int> totalCents = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesCompanion(
            id: id,
            supplierId: supplierId,
            status: status,
            subtotalCents: subtotalCents,
            taxCents: taxCents,
            totalCents: totalCents,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> supplierId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> subtotalCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            Value<int> totalCents = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesCompanion.insert(
            id: id,
            supplierId: supplierId,
            status: status,
            subtotalCents: subtotalCents,
            taxCents: taxCents,
            totalCents: totalCents,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchasesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {supplierId = false, purchaseItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (purchaseItemsRefs) db.purchaseItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$PurchasesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$PurchasesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (purchaseItemsRefs)
                    await $_getPrefetchedData<Purchase, $PurchasesTable,
                            PurchaseItem>(
                        currentTable: table,
                        referencedTable: $$PurchasesTableReferences
                            ._purchaseItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PurchasesTableReferences(db, table, p0)
                                .purchaseItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.purchaseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PurchasesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchasesTable,
    Purchase,
    $$PurchasesTableFilterComposer,
    $$PurchasesTableOrderingComposer,
    $$PurchasesTableAnnotationComposer,
    $$PurchasesTableCreateCompanionBuilder,
    $$PurchasesTableUpdateCompanionBuilder,
    (Purchase, $$PurchasesTableReferences),
    Purchase,
    PrefetchHooks Function({bool supplierId, bool purchaseItemsRefs})>;
typedef $$PurchaseItemsTableCreateCompanionBuilder = PurchaseItemsCompanion
    Function({
  required String id,
  required String purchaseId,
  required String productId,
  required int quantity,
  required int unitCostCents,
  Value<int> taxRateBps,
  Value<int> lineTotalCents,
  Value<String?> batchId,
  Value<int> rowid,
});
typedef $$PurchaseItemsTableUpdateCompanionBuilder = PurchaseItemsCompanion
    Function({
  Value<String> id,
  Value<String> purchaseId,
  Value<String> productId,
  Value<int> quantity,
  Value<int> unitCostCents,
  Value<int> taxRateBps,
  Value<int> lineTotalCents,
  Value<String?> batchId,
  Value<int> rowid,
});

final class $$PurchaseItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PurchaseItemsTable, PurchaseItem> {
  $$PurchaseItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PurchasesTable _purchaseIdTable(_$AppDatabase db) =>
      db.purchases.createAlias('purchase_items__purchase_id__purchases__id');

  $$PurchasesTableProcessedTableManager get purchaseId {
    final $_column = $_itemColumn<String>('purchase_id')!;

    final manager = $$PurchasesTableTableManager($_db, $_db.purchases)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('purchase_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.productBatches
          .createAlias('purchase_items__batch_id__product_batches__id');

  $$ProductBatchesTableProcessedTableManager? get batchId {
    final $_column = $_itemColumn<String>('batch_id');
    if ($_column == null) return null;
    final manager = $$ProductBatchesTableTableManager($_db, $_db.productBatches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PurchaseItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents,
      builder: (column) => ColumnFilters(column));

  $$PurchasesTableFilterComposer get purchaseId {
    final $$PurchasesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableFilterComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableFilterComposer get batchId {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableFilterComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents,
      builder: (column) => ColumnOrderings(column));

  $$PurchasesTableOrderingComposer get purchaseId {
    final $$PurchasesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableOrderingComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableOrderingComposer get batchId {
    final $$ProductBatchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableOrderingComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTable> {
  $$PurchaseItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => column);

  GeneratedColumn<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => column);

  GeneratedColumn<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents, builder: (column) => column);

  $$PurchasesTableAnnotationComposer get purchaseId {
    final $$PurchasesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.purchaseId,
        referencedTable: $db.purchases,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PurchasesTableAnnotationComposer(
              $db: $db,
              $table: $db.purchases,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableAnnotationComposer get batchId {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PurchaseItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseId, bool productId, bool batchId})> {
  $$PurchaseItemsTableTableManager(_$AppDatabase db, $PurchaseItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> purchaseId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> unitCostCents = const Value.absent(),
            Value<int> taxRateBps = const Value.absent(),
            Value<int> lineTotalCents = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchaseItemsCompanion(
            id: id,
            purchaseId: purchaseId,
            productId: productId,
            quantity: quantity,
            unitCostCents: unitCostCents,
            taxRateBps: taxRateBps,
            lineTotalCents: lineTotalCents,
            batchId: batchId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String purchaseId,
            required String productId,
            required int quantity,
            required int unitCostCents,
            Value<int> taxRateBps = const Value.absent(),
            Value<int> lineTotalCents = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchaseItemsCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            productId: productId,
            quantity: quantity,
            unitCostCents: unitCostCents,
            taxRateBps: taxRateBps,
            lineTotalCents: lineTotalCents,
            batchId: batchId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PurchaseItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {purchaseId = false, productId = false, batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (purchaseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.purchaseId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._purchaseIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._purchaseIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (batchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.batchId,
                    referencedTable:
                        $$PurchaseItemsTableReferences._batchIdTable(db),
                    referencedColumn:
                        $$PurchaseItemsTableReferences._batchIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PurchaseItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseItemsTable,
    PurchaseItem,
    $$PurchaseItemsTableFilterComposer,
    $$PurchaseItemsTableOrderingComposer,
    $$PurchaseItemsTableAnnotationComposer,
    $$PurchaseItemsTableCreateCompanionBuilder,
    $$PurchaseItemsTableUpdateCompanionBuilder,
    (PurchaseItem, $$PurchaseItemsTableReferences),
    PurchaseItem,
    PrefetchHooks Function({bool purchaseId, bool productId, bool batchId})>;
typedef $$ReservationsTableCreateCompanionBuilder = ReservationsCompanion
    Function({
  required String id,
  Value<String?> customerId,
  Value<String> status,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> canceledAt,
  Value<DateTime?> confirmedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$ReservationsTableUpdateCompanionBuilder = ReservationsCompanion
    Function({
  Value<String> id,
  Value<String?> customerId,
  Value<String> status,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> canceledAt,
  Value<DateTime?> confirmedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

final class $$ReservationsTableReferences
    extends BaseReferences<_$AppDatabase, $ReservationsTable, Reservation> {
  $$ReservationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('reservations__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ReservationItemsTable, List<ReservationItem>>
      _reservationItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reservationItems,
              aliasName: 'reservations__id__reservation_items__reservation_id');

  $$ReservationItemsTableProcessedTableManager get reservationItemsRefs {
    final manager =
        $$ReservationItemsTableTableManager($_db, $_db.reservationItems).filter(
            (f) => f.reservationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_reservationItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.sales,
          aliasName: 'reservations__id__sales__reservation_id');

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager($_db, $_db.sales).filter(
        (f) => f.reservationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReservationsTableFilterComposer
    extends Composer<_$AppDatabase, $ReservationsTable> {
  $$ReservationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get canceledAt => $composableBuilder(
      column: $table.canceledAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> reservationItemsRefs(
      Expression<bool> Function($$ReservationItemsTableFilterComposer f) f) {
    final $$ReservationItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.reservationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableFilterComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> salesRefs(
      Expression<bool> Function($$SalesTableFilterComposer f) f) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.reservationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReservationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReservationsTable> {
  $$ReservationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get canceledAt => $composableBuilder(
      column: $table.canceledAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReservationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReservationsTable> {
  $$ReservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get canceledAt => $composableBuilder(
      column: $table.canceledAt, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> reservationItemsRefs<T extends Object>(
      Expression<T> Function($$ReservationItemsTableAnnotationComposer a) f) {
    final $$ReservationItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.reservationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
      Expression<T> Function($$SalesTableAnnotationComposer a) f) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.reservationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReservationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReservationsTable,
    Reservation,
    $$ReservationsTableFilterComposer,
    $$ReservationsTableOrderingComposer,
    $$ReservationsTableAnnotationComposer,
    $$ReservationsTableCreateCompanionBuilder,
    $$ReservationsTableUpdateCompanionBuilder,
    (Reservation, $$ReservationsTableReferences),
    Reservation,
    PrefetchHooks Function(
        {bool customerId, bool reservationItemsRefs, bool salesRefs})> {
  $$ReservationsTableTableManager(_$AppDatabase db, $ReservationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> canceledAt = const Value.absent(),
            Value<DateTime?> confirmedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationsCompanion(
            id: id,
            customerId: customerId,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            canceledAt: canceledAt,
            confirmedAt: confirmedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> customerId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> canceledAt = const Value.absent(),
            Value<DateTime?> confirmedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationsCompanion.insert(
            id: id,
            customerId: customerId,
            status: status,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            canceledAt: canceledAt,
            confirmedAt: confirmedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReservationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false,
              reservationItemsRefs = false,
              salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (reservationItemsRefs) db.reservationItems,
                if (salesRefs) db.sales
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$ReservationsTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$ReservationsTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (reservationItemsRefs)
                    await $_getPrefetchedData<Reservation, $ReservationsTable,
                            ReservationItem>(
                        currentTable: table,
                        referencedTable: $$ReservationsTableReferences
                            ._reservationItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReservationsTableReferences(db, table, p0)
                                .reservationItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.reservationId == item.id),
                        typedResults: items),
                  if (salesRefs)
                    await $_getPrefetchedData<Reservation, $ReservationsTable,
                            Sale>(
                        currentTable: table,
                        referencedTable:
                            $$ReservationsTableReferences._salesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReservationsTableReferences(db, table, p0)
                                .salesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.reservationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReservationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReservationsTable,
    Reservation,
    $$ReservationsTableFilterComposer,
    $$ReservationsTableOrderingComposer,
    $$ReservationsTableAnnotationComposer,
    $$ReservationsTableCreateCompanionBuilder,
    $$ReservationsTableUpdateCompanionBuilder,
    (Reservation, $$ReservationsTableReferences),
    Reservation,
    PrefetchHooks Function(
        {bool customerId, bool reservationItemsRefs, bool salesRefs})>;
typedef $$ReservationItemsTableCreateCompanionBuilder
    = ReservationItemsCompanion Function({
  required String id,
  required String reservationId,
  required String productId,
  required int quantity,
  Value<int> unitPriceCents,
  Value<int> unitCostCents,
  Value<int> taxRateBps,
  Value<int> discountCents,
  Value<int> lineTotalCents,
  Value<int> rowid,
});
typedef $$ReservationItemsTableUpdateCompanionBuilder
    = ReservationItemsCompanion Function({
  Value<String> id,
  Value<String> reservationId,
  Value<String> productId,
  Value<int> quantity,
  Value<int> unitPriceCents,
  Value<int> unitCostCents,
  Value<int> taxRateBps,
  Value<int> discountCents,
  Value<int> lineTotalCents,
  Value<int> rowid,
});

final class $$ReservationItemsTableReferences extends BaseReferences<
    _$AppDatabase, $ReservationItemsTable, ReservationItem> {
  $$ReservationItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ReservationsTable _reservationIdTable(_$AppDatabase db) =>
      db.reservations
          .createAlias('reservation_items__reservation_id__reservations__id');

  $$ReservationsTableProcessedTableManager get reservationId {
    final $_column = $_itemColumn<String>('reservation_id')!;

    final manager = $$ReservationsTableTableManager($_db, $_db.reservations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reservationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('reservation_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BatchAllocationsTable,
      List<BatchAllocation>> _batchAllocationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.batchAllocations,
          aliasName:
              'reservation_items__id__batch_allocations__reservation_item_id');

  $$BatchAllocationsTableProcessedTableManager get batchAllocationsRefs {
    final manager =
        $$BatchAllocationsTableTableManager($_db, $_db.batchAllocations).filter(
            (f) =>
                f.reservationItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_batchAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReservationItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReservationItemsTable> {
  $$ReservationItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPriceCents => $composableBuilder(
      column: $table.unitPriceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountCents => $composableBuilder(
      column: $table.discountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents,
      builder: (column) => ColumnFilters(column));

  $$ReservationsTableFilterComposer get reservationId {
    final $$ReservationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationId,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableFilterComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> batchAllocationsRefs(
      Expression<bool> Function($$BatchAllocationsTableFilterComposer f) f) {
    final $$BatchAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.reservationItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReservationItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReservationItemsTable> {
  $$ReservationItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPriceCents => $composableBuilder(
      column: $table.unitPriceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountCents => $composableBuilder(
      column: $table.discountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents,
      builder: (column) => ColumnOrderings(column));

  $$ReservationsTableOrderingComposer get reservationId {
    final $$ReservationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationId,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableOrderingComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReservationItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReservationItemsTable> {
  $$ReservationItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceCents => $composableBuilder(
      column: $table.unitPriceCents, builder: (column) => column);

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => column);

  GeneratedColumn<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => column);

  GeneratedColumn<int> get discountCents => $composableBuilder(
      column: $table.discountCents, builder: (column) => column);

  GeneratedColumn<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents, builder: (column) => column);

  $$ReservationsTableAnnotationComposer get reservationId {
    final $$ReservationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationId,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableAnnotationComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> batchAllocationsRefs<T extends Object>(
      Expression<T> Function($$BatchAllocationsTableAnnotationComposer a) f) {
    final $$BatchAllocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.reservationItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReservationItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReservationItemsTable,
    ReservationItem,
    $$ReservationItemsTableFilterComposer,
    $$ReservationItemsTableOrderingComposer,
    $$ReservationItemsTableAnnotationComposer,
    $$ReservationItemsTableCreateCompanionBuilder,
    $$ReservationItemsTableUpdateCompanionBuilder,
    (ReservationItem, $$ReservationItemsTableReferences),
    ReservationItem,
    PrefetchHooks Function(
        {bool reservationId, bool productId, bool batchAllocationsRefs})> {
  $$ReservationItemsTableTableManager(
      _$AppDatabase db, $ReservationItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReservationItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReservationItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReservationItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> reservationId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> unitPriceCents = const Value.absent(),
            Value<int> unitCostCents = const Value.absent(),
            Value<int> taxRateBps = const Value.absent(),
            Value<int> discountCents = const Value.absent(),
            Value<int> lineTotalCents = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationItemsCompanion(
            id: id,
            reservationId: reservationId,
            productId: productId,
            quantity: quantity,
            unitPriceCents: unitPriceCents,
            unitCostCents: unitCostCents,
            taxRateBps: taxRateBps,
            discountCents: discountCents,
            lineTotalCents: lineTotalCents,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String reservationId,
            required String productId,
            required int quantity,
            Value<int> unitPriceCents = const Value.absent(),
            Value<int> unitCostCents = const Value.absent(),
            Value<int> taxRateBps = const Value.absent(),
            Value<int> discountCents = const Value.absent(),
            Value<int> lineTotalCents = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReservationItemsCompanion.insert(
            id: id,
            reservationId: reservationId,
            productId: productId,
            quantity: quantity,
            unitPriceCents: unitPriceCents,
            unitCostCents: unitCostCents,
            taxRateBps: taxRateBps,
            discountCents: discountCents,
            lineTotalCents: lineTotalCents,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReservationItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {reservationId = false,
              productId = false,
              batchAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (batchAllocationsRefs) db.batchAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (reservationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reservationId,
                    referencedTable: $$ReservationItemsTableReferences
                        ._reservationIdTable(db),
                    referencedColumn: $$ReservationItemsTableReferences
                        ._reservationIdTable(db)
                        .id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ReservationItemsTableReferences._productIdTable(db),
                    referencedColumn: $$ReservationItemsTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (batchAllocationsRefs)
                    await $_getPrefetchedData<ReservationItem,
                            $ReservationItemsTable, BatchAllocation>(
                        currentTable: table,
                        referencedTable: $$ReservationItemsTableReferences
                            ._batchAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReservationItemsTableReferences(db, table, p0)
                                .batchAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.reservationItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReservationItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReservationItemsTable,
    ReservationItem,
    $$ReservationItemsTableFilterComposer,
    $$ReservationItemsTableOrderingComposer,
    $$ReservationItemsTableAnnotationComposer,
    $$ReservationItemsTableCreateCompanionBuilder,
    $$ReservationItemsTableUpdateCompanionBuilder,
    (ReservationItem, $$ReservationItemsTableReferences),
    ReservationItem,
    PrefetchHooks Function(
        {bool reservationId, bool productId, bool batchAllocationsRefs})>;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  required String id,
  Value<String?> customerId,
  Value<String?> reservationId,
  Value<String> status,
  Value<int> subtotalCents,
  Value<int> taxCents,
  Value<int> discountCents,
  Value<int> totalCents,
  Value<int> estimatedProfitCents,
  Value<String?> notes,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> confirmedAt,
  Value<DateTime?> canceledAt,
  Value<int> rowid,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> id,
  Value<String?> customerId,
  Value<String?> reservationId,
  Value<String> status,
  Value<int> subtotalCents,
  Value<int> taxCents,
  Value<int> discountCents,
  Value<int> totalCents,
  Value<int> estimatedProfitCents,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> confirmedAt,
  Value<DateTime?> canceledAt,
  Value<int> rowid,
});

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('sales__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ReservationsTable _reservationIdTable(_$AppDatabase db) =>
      db.reservations.createAlias('sales__reservation_id__reservations__id');

  $$ReservationsTableProcessedTableManager? get reservationId {
    final $_column = $_itemColumn<String>('reservation_id');
    if ($_column == null) return null;
    final manager = $$ReservationsTableTableManager($_db, $_db.reservations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reservationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
      _saleItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.saleItems,
              aliasName: 'sales__id__sale_items__sale_id');

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReturnsTable, List<Return>> _returnsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.returns,
          aliasName: 'sales__id__returns__sale_id');

  $$ReturnsTableProcessedTableManager get returnsRefs {
    final manager = $$ReturnsTableTableManager($_db, $_db.returns)
        .filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get subtotalCents => $composableBuilder(
      column: $table.subtotalCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountCents => $composableBuilder(
      column: $table.discountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalCents => $composableBuilder(
      column: $table.totalCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedProfitCents => $composableBuilder(
      column: $table.estimatedProfitCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get canceledAt => $composableBuilder(
      column: $table.canceledAt, builder: (column) => ColumnFilters(column));

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReservationsTableFilterComposer get reservationId {
    final $$ReservationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationId,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableFilterComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> saleItemsRefs(
      Expression<bool> Function($$SaleItemsTableFilterComposer f) f) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> returnsRefs(
      Expression<bool> Function($$ReturnsTableFilterComposer f) f) {
    final $$ReturnsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returns,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnsTableFilterComposer(
              $db: $db,
              $table: $db.returns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get subtotalCents => $composableBuilder(
      column: $table.subtotalCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountCents => $composableBuilder(
      column: $table.discountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalCents => $composableBuilder(
      column: $table.totalCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedProfitCents => $composableBuilder(
      column: $table.estimatedProfitCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get canceledAt => $composableBuilder(
      column: $table.canceledAt, builder: (column) => ColumnOrderings(column));

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReservationsTableOrderingComposer get reservationId {
    final $$ReservationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationId,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableOrderingComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get subtotalCents => $composableBuilder(
      column: $table.subtotalCents, builder: (column) => column);

  GeneratedColumn<int> get taxCents =>
      $composableBuilder(column: $table.taxCents, builder: (column) => column);

  GeneratedColumn<int> get discountCents => $composableBuilder(
      column: $table.discountCents, builder: (column) => column);

  GeneratedColumn<int> get totalCents => $composableBuilder(
      column: $table.totalCents, builder: (column) => column);

  GeneratedColumn<int> get estimatedProfitCents => $composableBuilder(
      column: $table.estimatedProfitCents, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
      column: $table.confirmedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get canceledAt => $composableBuilder(
      column: $table.canceledAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReservationsTableAnnotationComposer get reservationId {
    final $$ReservationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationId,
        referencedTable: $db.reservations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationsTableAnnotationComposer(
              $db: $db,
              $table: $db.reservations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> saleItemsRefs<T extends Object>(
      Expression<T> Function($$SaleItemsTableAnnotationComposer a) f) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> returnsRefs<T extends Object>(
      Expression<T> Function($$ReturnsTableAnnotationComposer a) f) {
    final $$ReturnsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returns,
        getReferencedColumn: (t) => t.saleId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnsTableAnnotationComposer(
              $db: $db,
              $table: $db.returns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SalesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function(
        {bool customerId,
        bool reservationId,
        bool saleItemsRefs,
        bool returnsRefs})> {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<String?> reservationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> subtotalCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            Value<int> discountCents = const Value.absent(),
            Value<int> totalCents = const Value.absent(),
            Value<int> estimatedProfitCents = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> confirmedAt = const Value.absent(),
            Value<DateTime?> canceledAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion(
            id: id,
            customerId: customerId,
            reservationId: reservationId,
            status: status,
            subtotalCents: subtotalCents,
            taxCents: taxCents,
            discountCents: discountCents,
            totalCents: totalCents,
            estimatedProfitCents: estimatedProfitCents,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            confirmedAt: confirmedAt,
            canceledAt: canceledAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> customerId = const Value.absent(),
            Value<String?> reservationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> subtotalCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            Value<int> discountCents = const Value.absent(),
            Value<int> totalCents = const Value.absent(),
            Value<int> estimatedProfitCents = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> confirmedAt = const Value.absent(),
            Value<DateTime?> canceledAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesCompanion.insert(
            id: id,
            customerId: customerId,
            reservationId: reservationId,
            status: status,
            subtotalCents: subtotalCents,
            taxCents: taxCents,
            discountCents: discountCents,
            totalCents: totalCents,
            estimatedProfitCents: estimatedProfitCents,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt,
            confirmedAt: confirmedAt,
            canceledAt: canceledAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$SalesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {customerId = false,
              reservationId = false,
              saleItemsRefs = false,
              returnsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (saleItemsRefs) db.saleItems,
                if (returnsRefs) db.returns
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$SalesTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$SalesTableReferences._customerIdTable(db).id,
                  ) as T;
                }
                if (reservationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reservationId,
                    referencedTable:
                        $$SalesTableReferences._reservationIdTable(db),
                    referencedColumn:
                        $$SalesTableReferences._reservationIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, SaleItem>(
                        currentTable: table,
                        referencedTable:
                            $$SalesTableReferences._saleItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SalesTableReferences(db, table, p0).saleItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.saleId == item.id),
                        typedResults: items),
                  if (returnsRefs)
                    await $_getPrefetchedData<Sale, $SalesTable, Return>(
                        currentTable: table,
                        referencedTable:
                            $$SalesTableReferences._returnsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SalesTableReferences(db, table, p0).returnsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.saleId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SalesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTable,
    Sale,
    $$SalesTableFilterComposer,
    $$SalesTableOrderingComposer,
    $$SalesTableAnnotationComposer,
    $$SalesTableCreateCompanionBuilder,
    $$SalesTableUpdateCompanionBuilder,
    (Sale, $$SalesTableReferences),
    Sale,
    PrefetchHooks Function(
        {bool customerId,
        bool reservationId,
        bool saleItemsRefs,
        bool returnsRefs})>;
typedef $$SaleItemsTableCreateCompanionBuilder = SaleItemsCompanion Function({
  required String id,
  required String saleId,
  required String productId,
  required int quantity,
  required int unitPriceCents,
  required int unitCostCents,
  Value<int> taxRateBps,
  Value<int> discountCents,
  Value<int> taxCents,
  required int lineTotalCents,
  Value<int> lineProfitCents,
  Value<int> rowid,
});
typedef $$SaleItemsTableUpdateCompanionBuilder = SaleItemsCompanion Function({
  Value<String> id,
  Value<String> saleId,
  Value<String> productId,
  Value<int> quantity,
  Value<int> unitPriceCents,
  Value<int> unitCostCents,
  Value<int> taxRateBps,
  Value<int> discountCents,
  Value<int> taxCents,
  Value<int> lineTotalCents,
  Value<int> lineProfitCents,
  Value<int> rowid,
});

final class $$SaleItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem> {
  $$SaleItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) =>
      db.sales.createAlias('sale_items__sale_id__sales__id');

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('sale_items__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$BatchAllocationsTable, List<BatchAllocation>>
      _batchAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.batchAllocations,
              aliasName: 'sale_items__id__batch_allocations__sale_item_id');

  $$BatchAllocationsTableProcessedTableManager get batchAllocationsRefs {
    final manager = $$BatchAllocationsTableTableManager(
            $_db, $_db.batchAllocations)
        .filter((f) => f.saleItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_batchAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ReturnItemsTable, List<ReturnItem>>
      _returnItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.returnItems,
              aliasName: 'sale_items__id__return_items__sale_item_id');

  $$ReturnItemsTableProcessedTableManager get returnItemsRefs {
    final manager = $$ReturnItemsTableTableManager($_db, $_db.returnItems)
        .filter((f) => f.saleItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPriceCents => $composableBuilder(
      column: $table.unitPriceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountCents => $composableBuilder(
      column: $table.discountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineProfitCents => $composableBuilder(
      column: $table.lineProfitCents,
      builder: (column) => ColumnFilters(column));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> batchAllocationsRefs(
      Expression<bool> Function($$BatchAllocationsTableFilterComposer f) f) {
    final $$BatchAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.saleItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> returnItemsRefs(
      Expression<bool> Function($$ReturnItemsTableFilterComposer f) f) {
    final $$ReturnItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnItems,
        getReferencedColumn: (t) => t.saleItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnItemsTableFilterComposer(
              $db: $db,
              $table: $db.returnItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPriceCents => $composableBuilder(
      column: $table.unitPriceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountCents => $composableBuilder(
      column: $table.discountCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineProfitCents => $composableBuilder(
      column: $table.lineProfitCents,
      builder: (column) => ColumnOrderings(column));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableOrderingComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceCents => $composableBuilder(
      column: $table.unitPriceCents, builder: (column) => column);

  GeneratedColumn<int> get unitCostCents => $composableBuilder(
      column: $table.unitCostCents, builder: (column) => column);

  GeneratedColumn<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => column);

  GeneratedColumn<int> get discountCents => $composableBuilder(
      column: $table.discountCents, builder: (column) => column);

  GeneratedColumn<int> get taxCents =>
      $composableBuilder(column: $table.taxCents, builder: (column) => column);

  GeneratedColumn<int> get lineTotalCents => $composableBuilder(
      column: $table.lineTotalCents, builder: (column) => column);

  GeneratedColumn<int> get lineProfitCents => $composableBuilder(
      column: $table.lineProfitCents, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> batchAllocationsRefs<T extends Object>(
      Expression<T> Function($$BatchAllocationsTableAnnotationComposer a) f) {
    final $$BatchAllocationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.batchAllocations,
        getReferencedColumn: (t) => t.saleItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BatchAllocationsTableAnnotationComposer(
              $db: $db,
              $table: $db.batchAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> returnItemsRefs<T extends Object>(
      Expression<T> Function($$ReturnItemsTableAnnotationComposer a) f) {
    final $$ReturnItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnItems,
        getReferencedColumn: (t) => t.saleItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SaleItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, $$SaleItemsTableReferences),
    SaleItem,
    PrefetchHooks Function(
        {bool saleId,
        bool productId,
        bool batchAllocationsRefs,
        bool returnItemsRefs})> {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> unitPriceCents = const Value.absent(),
            Value<int> unitCostCents = const Value.absent(),
            Value<int> taxRateBps = const Value.absent(),
            Value<int> discountCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            Value<int> lineTotalCents = const Value.absent(),
            Value<int> lineProfitCents = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            unitPriceCents: unitPriceCents,
            unitCostCents: unitCostCents,
            taxRateBps: taxRateBps,
            discountCents: discountCents,
            taxCents: taxCents,
            lineTotalCents: lineTotalCents,
            lineProfitCents: lineProfitCents,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String saleId,
            required String productId,
            required int quantity,
            required int unitPriceCents,
            required int unitCostCents,
            Value<int> taxRateBps = const Value.absent(),
            Value<int> discountCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            required int lineTotalCents,
            Value<int> lineProfitCents = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            quantity: quantity,
            unitPriceCents: unitPriceCents,
            unitCostCents: unitCostCents,
            taxRateBps: taxRateBps,
            discountCents: discountCents,
            taxCents: taxCents,
            lineTotalCents: lineTotalCents,
            lineProfitCents: lineProfitCents,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SaleItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {saleId = false,
              productId = false,
              batchAllocationsRefs = false,
              returnItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (batchAllocationsRefs) db.batchAllocations,
                if (returnItemsRefs) db.returnItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (saleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleId,
                    referencedTable:
                        $$SaleItemsTableReferences._saleIdTable(db),
                    referencedColumn:
                        $$SaleItemsTableReferences._saleIdTable(db).id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$SaleItemsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$SaleItemsTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (batchAllocationsRefs)
                    await $_getPrefetchedData<SaleItem, $SaleItemsTable,
                            BatchAllocation>(
                        currentTable: table,
                        referencedTable: $$SaleItemsTableReferences
                            ._batchAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SaleItemsTableReferences(db, table, p0)
                                .batchAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.saleItemId == item.id),
                        typedResults: items),
                  if (returnItemsRefs)
                    await $_getPrefetchedData<SaleItem, $SaleItemsTable,
                            ReturnItem>(
                        currentTable: table,
                        referencedTable: $$SaleItemsTableReferences
                            ._returnItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SaleItemsTableReferences(db, table, p0)
                                .returnItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.saleItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SaleItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTable,
    SaleItem,
    $$SaleItemsTableFilterComposer,
    $$SaleItemsTableOrderingComposer,
    $$SaleItemsTableAnnotationComposer,
    $$SaleItemsTableCreateCompanionBuilder,
    $$SaleItemsTableUpdateCompanionBuilder,
    (SaleItem, $$SaleItemsTableReferences),
    SaleItem,
    PrefetchHooks Function(
        {bool saleId,
        bool productId,
        bool batchAllocationsRefs,
        bool returnItemsRefs})>;
typedef $$BatchAllocationsTableCreateCompanionBuilder
    = BatchAllocationsCompanion Function({
  required String id,
  required String productId,
  required String batchId,
  Value<String?> reservationItemId,
  Value<String?> saleItemId,
  required int quantity,
  Value<int> quantityReserved,
  Value<int> quantitySold,
  Value<String> state,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$BatchAllocationsTableUpdateCompanionBuilder
    = BatchAllocationsCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<String> batchId,
  Value<String?> reservationItemId,
  Value<String?> saleItemId,
  Value<int> quantity,
  Value<int> quantityReserved,
  Value<int> quantitySold,
  Value<String> state,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$BatchAllocationsTableReferences extends BaseReferences<
    _$AppDatabase, $BatchAllocationsTable, BatchAllocation> {
  $$BatchAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('batch_allocations__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.productBatches
          .createAlias('batch_allocations__batch_id__product_batches__id');

  $$ProductBatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<String>('batch_id')!;

    final manager = $$ProductBatchesTableTableManager($_db, $_db.productBatches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ReservationItemsTable _reservationItemIdTable(_$AppDatabase db) =>
      db.reservationItems.createAlias(
          'batch_allocations__reservation_item_id__reservation_items__id');

  $$ReservationItemsTableProcessedTableManager? get reservationItemId {
    final $_column = $_itemColumn<String>('reservation_item_id');
    if ($_column == null) return null;
    final manager =
        $$ReservationItemsTableTableManager($_db, $_db.reservationItems)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reservationItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SaleItemsTable _saleItemIdTable(_$AppDatabase db) => db.saleItems
      .createAlias('batch_allocations__sale_item_id__sale_items__id');

  $$SaleItemsTableProcessedTableManager? get saleItemId {
    final $_column = $_itemColumn<String>('sale_item_id');
    if ($_column == null) return null;
    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BatchAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $BatchAllocationsTable> {
  $$BatchAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityReserved => $composableBuilder(
      column: $table.quantityReserved,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantitySold => $composableBuilder(
      column: $table.quantitySold, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableFilterComposer get batchId {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableFilterComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReservationItemsTableFilterComposer get reservationItemId {
    final $$ReservationItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationItemId,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableFilterComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SaleItemsTableFilterComposer get saleItemId {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleItemId,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BatchAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $BatchAllocationsTable> {
  $$BatchAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityReserved => $composableBuilder(
      column: $table.quantityReserved,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantitySold => $composableBuilder(
      column: $table.quantitySold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state => $composableBuilder(
      column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableOrderingComposer get batchId {
    final $$ProductBatchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableOrderingComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReservationItemsTableOrderingComposer get reservationItemId {
    final $$ReservationItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationItemId,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableOrderingComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SaleItemsTableOrderingComposer get saleItemId {
    final $$SaleItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleItemId,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableOrderingComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BatchAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatchAllocationsTable> {
  $$BatchAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get quantityReserved => $composableBuilder(
      column: $table.quantityReserved, builder: (column) => column);

  GeneratedColumn<int> get quantitySold => $composableBuilder(
      column: $table.quantitySold, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableAnnotationComposer get batchId {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ReservationItemsTableAnnotationComposer get reservationItemId {
    final $$ReservationItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reservationItemId,
        referencedTable: $db.reservationItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReservationItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.reservationItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SaleItemsTableAnnotationComposer get saleItemId {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleItemId,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BatchAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BatchAllocationsTable,
    BatchAllocation,
    $$BatchAllocationsTableFilterComposer,
    $$BatchAllocationsTableOrderingComposer,
    $$BatchAllocationsTableAnnotationComposer,
    $$BatchAllocationsTableCreateCompanionBuilder,
    $$BatchAllocationsTableUpdateCompanionBuilder,
    (BatchAllocation, $$BatchAllocationsTableReferences),
    BatchAllocation,
    PrefetchHooks Function(
        {bool productId,
        bool batchId,
        bool reservationItemId,
        bool saleItemId})> {
  $$BatchAllocationsTableTableManager(
      _$AppDatabase db, $BatchAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchAllocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> batchId = const Value.absent(),
            Value<String?> reservationItemId = const Value.absent(),
            Value<String?> saleItemId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> quantityReserved = const Value.absent(),
            Value<int> quantitySold = const Value.absent(),
            Value<String> state = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BatchAllocationsCompanion(
            id: id,
            productId: productId,
            batchId: batchId,
            reservationItemId: reservationItemId,
            saleItemId: saleItemId,
            quantity: quantity,
            quantityReserved: quantityReserved,
            quantitySold: quantitySold,
            state: state,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required String batchId,
            Value<String?> reservationItemId = const Value.absent(),
            Value<String?> saleItemId = const Value.absent(),
            required int quantity,
            Value<int> quantityReserved = const Value.absent(),
            Value<int> quantitySold = const Value.absent(),
            Value<String> state = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BatchAllocationsCompanion.insert(
            id: id,
            productId: productId,
            batchId: batchId,
            reservationItemId: reservationItemId,
            saleItemId: saleItemId,
            quantity: quantity,
            quantityReserved: quantityReserved,
            quantitySold: quantitySold,
            state: state,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BatchAllocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {productId = false,
              batchId = false,
              reservationItemId = false,
              saleItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$BatchAllocationsTableReferences._productIdTable(db),
                    referencedColumn: $$BatchAllocationsTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }
                if (batchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.batchId,
                    referencedTable:
                        $$BatchAllocationsTableReferences._batchIdTable(db),
                    referencedColumn:
                        $$BatchAllocationsTableReferences._batchIdTable(db).id,
                  ) as T;
                }
                if (reservationItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reservationItemId,
                    referencedTable: $$BatchAllocationsTableReferences
                        ._reservationItemIdTable(db),
                    referencedColumn: $$BatchAllocationsTableReferences
                        ._reservationItemIdTable(db)
                        .id,
                  ) as T;
                }
                if (saleItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleItemId,
                    referencedTable:
                        $$BatchAllocationsTableReferences._saleItemIdTable(db),
                    referencedColumn: $$BatchAllocationsTableReferences
                        ._saleItemIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BatchAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BatchAllocationsTable,
    BatchAllocation,
    $$BatchAllocationsTableFilterComposer,
    $$BatchAllocationsTableOrderingComposer,
    $$BatchAllocationsTableAnnotationComposer,
    $$BatchAllocationsTableCreateCompanionBuilder,
    $$BatchAllocationsTableUpdateCompanionBuilder,
    (BatchAllocation, $$BatchAllocationsTableReferences),
    BatchAllocation,
    PrefetchHooks Function(
        {bool productId,
        bool batchId,
        bool reservationItemId,
        bool saleItemId})>;
typedef $$StockMovementsTableCreateCompanionBuilder = StockMovementsCompanion
    Function({
  required String id,
  required String productId,
  Value<String?> batchId,
  required String movementType,
  required int quantity,
  required int stockBefore,
  required int stockAfter,
  Value<String?> referenceType,
  Value<String?> referenceId,
  Value<String?> reason,
  Value<String?> observations,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$StockMovementsTableUpdateCompanionBuilder = StockMovementsCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<String?> batchId,
  Value<String> movementType,
  Value<int> quantity,
  Value<int> stockBefore,
  Value<int> stockAfter,
  Value<String?> referenceType,
  Value<String?> referenceId,
  Value<String?> reason,
  Value<String?> observations,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$StockMovementsTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovement> {
  $$StockMovementsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('stock_movements__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.productBatches
          .createAlias('stock_movements__batch_id__product_batches__id');

  $$ProductBatchesTableProcessedTableManager? get batchId {
    final $_column = $_itemColumn<String>('batch_id');
    if ($_column == null) return null;
    final manager = $$ProductBatchesTableTableManager($_db, $_db.productBatches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get movementType => $composableBuilder(
      column: $table.movementType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockBefore => $composableBuilder(
      column: $table.stockBefore, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stockAfter => $composableBuilder(
      column: $table.stockAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceType => $composableBuilder(
      column: $table.referenceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get observations => $composableBuilder(
      column: $table.observations, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableFilterComposer get batchId {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableFilterComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get movementType => $composableBuilder(
      column: $table.movementType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockBefore => $composableBuilder(
      column: $table.stockBefore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stockAfter => $composableBuilder(
      column: $table.stockAfter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceType => $composableBuilder(
      column: $table.referenceType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get observations => $composableBuilder(
      column: $table.observations,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableOrderingComposer get batchId {
    final $$ProductBatchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableOrderingComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get movementType => $composableBuilder(
      column: $table.movementType, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get stockBefore => $composableBuilder(
      column: $table.stockBefore, builder: (column) => column);

  GeneratedColumn<int> get stockAfter => $composableBuilder(
      column: $table.stockAfter, builder: (column) => column);

  GeneratedColumn<String> get referenceType => $composableBuilder(
      column: $table.referenceType, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get observations => $composableBuilder(
      column: $table.observations, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableAnnotationComposer get batchId {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$StockMovementsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockMovementsTable,
    StockMovement,
    $$StockMovementsTableFilterComposer,
    $$StockMovementsTableOrderingComposer,
    $$StockMovementsTableAnnotationComposer,
    $$StockMovementsTableCreateCompanionBuilder,
    $$StockMovementsTableUpdateCompanionBuilder,
    (StockMovement, $$StockMovementsTableReferences),
    StockMovement,
    PrefetchHooks Function({bool productId, bool batchId})> {
  $$StockMovementsTableTableManager(
      _$AppDatabase db, $StockMovementsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String?> batchId = const Value.absent(),
            Value<String> movementType = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> stockBefore = const Value.absent(),
            Value<int> stockAfter = const Value.absent(),
            Value<String?> referenceType = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> observations = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockMovementsCompanion(
            id: id,
            productId: productId,
            batchId: batchId,
            movementType: movementType,
            quantity: quantity,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            referenceType: referenceType,
            referenceId: referenceId,
            reason: reason,
            observations: observations,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            Value<String?> batchId = const Value.absent(),
            required String movementType,
            required int quantity,
            required int stockBefore,
            required int stockAfter,
            Value<String?> referenceType = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<String?> observations = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StockMovementsCompanion.insert(
            id: id,
            productId: productId,
            batchId: batchId,
            movementType: movementType,
            quantity: quantity,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            referenceType: referenceType,
            referenceId: referenceId,
            reason: reason,
            observations: observations,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$StockMovementsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false, batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$StockMovementsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$StockMovementsTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (batchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.batchId,
                    referencedTable:
                        $$StockMovementsTableReferences._batchIdTable(db),
                    referencedColumn:
                        $$StockMovementsTableReferences._batchIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$StockMovementsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockMovementsTable,
    StockMovement,
    $$StockMovementsTableFilterComposer,
    $$StockMovementsTableOrderingComposer,
    $$StockMovementsTableAnnotationComposer,
    $$StockMovementsTableCreateCompanionBuilder,
    $$StockMovementsTableUpdateCompanionBuilder,
    (StockMovement, $$StockMovementsTableReferences),
    StockMovement,
    PrefetchHooks Function({bool productId, bool batchId})>;
typedef $$ReturnsTableCreateCompanionBuilder = ReturnsCompanion Function({
  required String id,
  required String saleId,
  Value<String> status,
  Value<String?> reason,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ReturnsTableUpdateCompanionBuilder = ReturnsCompanion Function({
  Value<String> id,
  Value<String> saleId,
  Value<String> status,
  Value<String?> reason,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ReturnsTableReferences
    extends BaseReferences<_$AppDatabase, $ReturnsTable, Return> {
  $$ReturnsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) =>
      db.sales.createAlias('returns__sale_id__sales__id');

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$SalesTableTableManager($_db, $_db.sales)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ReturnItemsTable, List<ReturnItem>>
      _returnItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.returnItems,
              aliasName: 'returns__id__return_items__return_id');

  $$ReturnItemsTableProcessedTableManager get returnItemsRefs {
    final manager = $$ReturnItemsTableTableManager($_db, $_db.returnItems)
        .filter((f) => f.returnId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_returnItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ReturnsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnsTable> {
  $$ReturnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableFilterComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> returnItemsRefs(
      Expression<bool> Function($$ReturnItemsTableFilterComposer f) f) {
    final $$ReturnItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnItems,
        getReferencedColumn: (t) => t.returnId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnItemsTableFilterComposer(
              $db: $db,
              $table: $db.returnItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReturnsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnsTable> {
  $$ReturnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableOrderingComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnsTable> {
  $$ReturnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleId,
        referencedTable: $db.sales,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SalesTableAnnotationComposer(
              $db: $db,
              $table: $db.sales,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> returnItemsRefs<T extends Object>(
      Expression<T> Function($$ReturnItemsTableAnnotationComposer a) f) {
    final $$ReturnItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.returnItems,
        getReferencedColumn: (t) => t.returnId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.returnItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ReturnsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReturnsTable,
    Return,
    $$ReturnsTableFilterComposer,
    $$ReturnsTableOrderingComposer,
    $$ReturnsTableAnnotationComposer,
    $$ReturnsTableCreateCompanionBuilder,
    $$ReturnsTableUpdateCompanionBuilder,
    (Return, $$ReturnsTableReferences),
    Return,
    PrefetchHooks Function({bool saleId, bool returnItemsRefs})> {
  $$ReturnsTableTableManager(_$AppDatabase db, $ReturnsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReturnsCompanion(
            id: id,
            saleId: saleId,
            status: status,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String saleId,
            Value<String> status = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReturnsCompanion.insert(
            id: id,
            saleId: saleId,
            status: status,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ReturnsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({saleId = false, returnItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (returnItemsRefs) db.returnItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (saleId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleId,
                    referencedTable: $$ReturnsTableReferences._saleIdTable(db),
                    referencedColumn:
                        $$ReturnsTableReferences._saleIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (returnItemsRefs)
                    await $_getPrefetchedData<Return, $ReturnsTable,
                            ReturnItem>(
                        currentTable: table,
                        referencedTable:
                            $$ReturnsTableReferences._returnItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ReturnsTableReferences(db, table, p0)
                                .returnItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.returnId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ReturnsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReturnsTable,
    Return,
    $$ReturnsTableFilterComposer,
    $$ReturnsTableOrderingComposer,
    $$ReturnsTableAnnotationComposer,
    $$ReturnsTableCreateCompanionBuilder,
    $$ReturnsTableUpdateCompanionBuilder,
    (Return, $$ReturnsTableReferences),
    Return,
    PrefetchHooks Function({bool saleId, bool returnItemsRefs})>;
typedef $$ReturnItemsTableCreateCompanionBuilder = ReturnItemsCompanion
    Function({
  required String id,
  required String returnId,
  required String saleItemId,
  required String batchId,
  required int quantity,
  Value<int> rowid,
});
typedef $$ReturnItemsTableUpdateCompanionBuilder = ReturnItemsCompanion
    Function({
  Value<String> id,
  Value<String> returnId,
  Value<String> saleItemId,
  Value<String> batchId,
  Value<int> quantity,
  Value<int> rowid,
});

final class $$ReturnItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ReturnItemsTable, ReturnItem> {
  $$ReturnItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ReturnsTable _returnIdTable(_$AppDatabase db) =>
      db.returns.createAlias('return_items__return_id__returns__id');

  $$ReturnsTableProcessedTableManager get returnId {
    final $_column = $_itemColumn<String>('return_id')!;

    final manager = $$ReturnsTableTableManager($_db, $_db.returns)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_returnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SaleItemsTable _saleItemIdTable(_$AppDatabase db) =>
      db.saleItems.createAlias('return_items__sale_item_id__sale_items__id');

  $$SaleItemsTableProcessedTableManager get saleItemId {
    final $_column = $_itemColumn<String>('sale_item_id')!;

    final manager = $$SaleItemsTableTableManager($_db, $_db.saleItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductBatchesTable _batchIdTable(_$AppDatabase db) =>
      db.productBatches
          .createAlias('return_items__batch_id__product_batches__id');

  $$ProductBatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<String>('batch_id')!;

    final manager = $$ProductBatchesTableTableManager($_db, $_db.productBatches)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ReturnItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ReturnItemsTable> {
  $$ReturnItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  $$ReturnsTableFilterComposer get returnId {
    final $$ReturnsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.returnId,
        referencedTable: $db.returns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnsTableFilterComposer(
              $db: $db,
              $table: $db.returns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SaleItemsTableFilterComposer get saleItemId {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleItemId,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableFilterComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableFilterComposer get batchId {
    final $$ProductBatchesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableFilterComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReturnItemsTable> {
  $$ReturnItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  $$ReturnsTableOrderingComposer get returnId {
    final $$ReturnsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.returnId,
        referencedTable: $db.returns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnsTableOrderingComposer(
              $db: $db,
              $table: $db.returns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SaleItemsTableOrderingComposer get saleItemId {
    final $$SaleItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleItemId,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableOrderingComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableOrderingComposer get batchId {
    final $$ProductBatchesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableOrderingComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReturnItemsTable> {
  $$ReturnItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  $$ReturnsTableAnnotationComposer get returnId {
    final $$ReturnsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.returnId,
        referencedTable: $db.returns,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ReturnsTableAnnotationComposer(
              $db: $db,
              $table: $db.returns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SaleItemsTableAnnotationComposer get saleItemId {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.saleItemId,
        referencedTable: $db.saleItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SaleItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.saleItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductBatchesTableAnnotationComposer get batchId {
    final $$ProductBatchesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.batchId,
        referencedTable: $db.productBatches,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductBatchesTableAnnotationComposer(
              $db: $db,
              $table: $db.productBatches,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ReturnItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReturnItemsTable,
    ReturnItem,
    $$ReturnItemsTableFilterComposer,
    $$ReturnItemsTableOrderingComposer,
    $$ReturnItemsTableAnnotationComposer,
    $$ReturnItemsTableCreateCompanionBuilder,
    $$ReturnItemsTableUpdateCompanionBuilder,
    (ReturnItem, $$ReturnItemsTableReferences),
    ReturnItem,
    PrefetchHooks Function({bool returnId, bool saleItemId, bool batchId})> {
  $$ReturnItemsTableTableManager(_$AppDatabase db, $ReturnItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> returnId = const Value.absent(),
            Value<String> saleItemId = const Value.absent(),
            Value<String> batchId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReturnItemsCompanion(
            id: id,
            returnId: returnId,
            saleItemId: saleItemId,
            batchId: batchId,
            quantity: quantity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String returnId,
            required String saleItemId,
            required String batchId,
            required int quantity,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReturnItemsCompanion.insert(
            id: id,
            returnId: returnId,
            saleItemId: saleItemId,
            batchId: batchId,
            quantity: quantity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ReturnItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {returnId = false, saleItemId = false, batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (returnId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.returnId,
                    referencedTable:
                        $$ReturnItemsTableReferences._returnIdTable(db),
                    referencedColumn:
                        $$ReturnItemsTableReferences._returnIdTable(db).id,
                  ) as T;
                }
                if (saleItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.saleItemId,
                    referencedTable:
                        $$ReturnItemsTableReferences._saleItemIdTable(db),
                    referencedColumn:
                        $$ReturnItemsTableReferences._saleItemIdTable(db).id,
                  ) as T;
                }
                if (batchId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.batchId,
                    referencedTable:
                        $$ReturnItemsTableReferences._batchIdTable(db),
                    referencedColumn:
                        $$ReturnItemsTableReferences._batchIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ReturnItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReturnItemsTable,
    ReturnItem,
    $$ReturnItemsTableFilterComposer,
    $$ReturnItemsTableOrderingComposer,
    $$ReturnItemsTableAnnotationComposer,
    $$ReturnItemsTableCreateCompanionBuilder,
    $$ReturnItemsTableUpdateCompanionBuilder,
    (ReturnItem, $$ReturnItemsTableReferences),
    ReturnItem,
    PrefetchHooks Function({bool returnId, bool saleItemId, bool batchId})>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  required String id,
  required String name,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$ExpenseCategoriesTableReferences extends BaseReferences<
    _$AppDatabase, $ExpenseCategoriesTable, ExpenseCategory> {
  $$ExpenseCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenses,
          aliasName: 'expense_categories__id__expenses__category_id');

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  Expression<bool> expensesRefs(
      Expression<bool> Function($$ExpensesTableFilterComposer f) f) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableFilterComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
      Expression<T> Function($$ExpensesTableAnnotationComposer a) f) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenses,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpensesTableAnnotationComposer(
              $db: $db,
              $table: $db.expenses,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (ExpenseCategory, $$ExpenseCategoriesTableReferences),
    ExpenseCategory,
    PrefetchHooks Function({bool expensesRefs})> {
  $$ExpenseCategoriesTableTableManager(
      _$AppDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            name: name,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<ExpenseCategory, $ExpenseCategoriesTable,
                            Expense>(
                        currentTable: table,
                        referencedTable: $$ExpenseCategoriesTableReferences
                            ._expensesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseCategoriesTableReferences(db, table, p0)
                                .expensesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (ExpenseCategory, $$ExpenseCategoriesTableReferences),
    ExpenseCategory,
    PrefetchHooks Function({bool expensesRefs})>;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  required String id,
  required String name,
  Value<String?> categoryId,
  Value<String?> supplierId,
  Value<String?> description,
  required int amountCents,
  Value<int> taxCents,
  Value<String?> paymentMethod,
  Value<String?> notes,
  Value<bool> isActive,
  required DateTime occurredAt,
  required DateTime createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> categoryId,
  Value<String?> supplierId,
  Value<String?> description,
  Value<int> amountCents,
  Value<int> taxCents,
  Value<String?> paymentMethod,
  Value<String?> notes,
  Value<bool> isActive,
  Value<DateTime> occurredAt,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.expenseCategories
          .createAlias('expenses__category_id__expense_categories__id');

  $$ExpenseCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager =
        $$ExpenseCategoriesTableTableManager($_db, $_db.expenseCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $SuppliersTable _supplierIdTable(_$AppDatabase db) =>
      db.suppliers.createAlias('expenses__supplier_id__suppliers__id');

  $$SuppliersTableProcessedTableManager? get supplierId {
    final $_column = $_itemColumn<String>('supplier_id');
    if ($_column == null) return null;
    final manager = $$SuppliersTableTableManager($_db, $_db.suppliers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplierIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ExpenseCategoriesTableFilterComposer get categoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.expenseCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.expenseCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableFilterComposer get supplierId {
    final $$SuppliersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableFilterComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxCents => $composableBuilder(
      column: $table.taxCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ExpenseCategoriesTableOrderingComposer get categoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.expenseCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.expenseCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$SuppliersTableOrderingComposer get supplierId {
    final $$SuppliersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableOrderingComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
      column: $table.amountCents, builder: (column) => column);

  GeneratedColumn<int> get taxCents =>
      $composableBuilder(column: $table.taxCents, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ExpenseCategoriesTableAnnotationComposer get categoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.expenseCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$SuppliersTableAnnotationComposer get supplierId {
    final $$SuppliersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.supplierId,
        referencedTable: $db.suppliers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SuppliersTableAnnotationComposer(
              $db: $db,
              $table: $db.suppliers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpensesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool categoryId, bool supplierId})> {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> amountCents = const Value.absent(),
            Value<int> taxCents = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion(
            id: id,
            name: name,
            categoryId: categoryId,
            supplierId: supplierId,
            description: description,
            amountCents: amountCents,
            taxCents: taxCents,
            paymentMethod: paymentMethod,
            notes: notes,
            isActive: isActive,
            occurredAt: occurredAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> categoryId = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<String?> description = const Value.absent(),
            required int amountCents,
            Value<int> taxCents = const Value.absent(),
            Value<String?> paymentMethod = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required DateTime occurredAt,
            required DateTime createdAt,
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpensesCompanion.insert(
            id: id,
            name: name,
            categoryId: categoryId,
            supplierId: supplierId,
            description: description,
            amountCents: amountCents,
            taxCents: taxCents,
            paymentMethod: paymentMethod,
            notes: notes,
            isActive: isActive,
            occurredAt: occurredAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ExpensesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({categoryId = false, supplierId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ExpensesTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._categoryIdTable(db).id,
                  ) as T;
                }
                if (supplierId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.supplierId,
                    referencedTable:
                        $$ExpensesTableReferences._supplierIdTable(db),
                    referencedColumn:
                        $$ExpensesTableReferences._supplierIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpensesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExpensesTable,
    Expense,
    $$ExpensesTableFilterComposer,
    $$ExpensesTableOrderingComposer,
    $$ExpensesTableAnnotationComposer,
    $$ExpensesTableCreateCompanionBuilder,
    $$ExpensesTableUpdateCompanionBuilder,
    (Expense, $$ExpensesTableReferences),
    Expense,
    PrefetchHooks Function({bool categoryId, bool supplierId})>;
typedef $$PriceHistoryTableCreateCompanionBuilder = PriceHistoryCompanion
    Function({
  required String id,
  required String productId,
  required int costCents,
  required int salePriceCents,
  Value<int> taxRateBps,
  Value<String?> reason,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PriceHistoryTableUpdateCompanionBuilder = PriceHistoryCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<int> costCents,
  Value<int> salePriceCents,
  Value<int> taxRateBps,
  Value<String?> reason,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PriceHistoryTableReferences extends BaseReferences<_$AppDatabase,
    $PriceHistoryTable, PriceHistoryData> {
  $$PriceHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('price_history__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PriceHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get costCents => $composableBuilder(
      column: $table.costCents, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get salePriceCents => $composableBuilder(
      column: $table.salePriceCents,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get costCents => $composableBuilder(
      column: $table.costCents, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get salePriceCents => $composableBuilder(
      column: $table.salePriceCents,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceHistoryTable> {
  $$PriceHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get costCents =>
      $composableBuilder(column: $table.costCents, builder: (column) => column);

  GeneratedColumn<int> get salePriceCents => $composableBuilder(
      column: $table.salePriceCents, builder: (column) => column);

  GeneratedColumn<int> get taxRateBps => $composableBuilder(
      column: $table.taxRateBps, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PriceHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PriceHistoryTable,
    PriceHistoryData,
    $$PriceHistoryTableFilterComposer,
    $$PriceHistoryTableOrderingComposer,
    $$PriceHistoryTableAnnotationComposer,
    $$PriceHistoryTableCreateCompanionBuilder,
    $$PriceHistoryTableUpdateCompanionBuilder,
    (PriceHistoryData, $$PriceHistoryTableReferences),
    PriceHistoryData,
    PrefetchHooks Function({bool productId})> {
  $$PriceHistoryTableTableManager(_$AppDatabase db, $PriceHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> costCents = const Value.absent(),
            Value<int> salePriceCents = const Value.absent(),
            Value<int> taxRateBps = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PriceHistoryCompanion(
            id: id,
            productId: productId,
            costCents: costCents,
            salePriceCents: salePriceCents,
            taxRateBps: taxRateBps,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required int costCents,
            required int salePriceCents,
            Value<int> taxRateBps = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PriceHistoryCompanion.insert(
            id: id,
            productId: productId,
            costCents: costCents,
            salePriceCents: salePriceCents,
            taxRateBps: taxRateBps,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PriceHistoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$PriceHistoryTableReferences._productIdTable(db),
                    referencedColumn:
                        $$PriceHistoryTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PriceHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PriceHistoryTable,
    PriceHistoryData,
    $$PriceHistoryTableFilterComposer,
    $$PriceHistoryTableOrderingComposer,
    $$PriceHistoryTableAnnotationComposer,
    $$PriceHistoryTableCreateCompanionBuilder,
    $$PriceHistoryTableUpdateCompanionBuilder,
    (PriceHistoryData, $$PriceHistoryTableReferences),
    PriceHistoryData,
    PrefetchHooks Function({bool productId})>;
typedef $$ProductOffersTableCreateCompanionBuilder = ProductOffersCompanion
    Function({
  required String id,
  required String productId,
  required String offerType,
  required int value,
  required DateTime startAt,
  Value<DateTime?> endAt,
  Value<String?> conditionsJson,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ProductOffersTableUpdateCompanionBuilder = ProductOffersCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<String> offerType,
  Value<int> value,
  Value<DateTime> startAt,
  Value<DateTime?> endAt,
  Value<String?> conditionsJson,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$ProductOffersTableReferences
    extends BaseReferences<_$AppDatabase, $ProductOffersTable, ProductOffer> {
  $$ProductOffersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('product_offers__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductOffersTableFilterComposer
    extends Composer<_$AppDatabase, $ProductOffersTable> {
  $$ProductOffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get offerType => $composableBuilder(
      column: $table.offerType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endAt => $composableBuilder(
      column: $table.endAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditionsJson => $composableBuilder(
      column: $table.conditionsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOffersTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductOffersTable> {
  $$ProductOffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get offerType => $composableBuilder(
      column: $table.offerType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
      column: $table.endAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditionsJson => $composableBuilder(
      column: $table.conditionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductOffersTable> {
  $$ProductOffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get offerType =>
      $composableBuilder(column: $table.offerType, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<String> get conditionsJson => $composableBuilder(
      column: $table.conditionsJson, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductOffersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductOffersTable,
    ProductOffer,
    $$ProductOffersTableFilterComposer,
    $$ProductOffersTableOrderingComposer,
    $$ProductOffersTableAnnotationComposer,
    $$ProductOffersTableCreateCompanionBuilder,
    $$ProductOffersTableUpdateCompanionBuilder,
    (ProductOffer, $$ProductOffersTableReferences),
    ProductOffer,
    PrefetchHooks Function({bool productId})> {
  $$ProductOffersTableTableManager(_$AppDatabase db, $ProductOffersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductOffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductOffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductOffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> offerType = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<DateTime> startAt = const Value.absent(),
            Value<DateTime?> endAt = const Value.absent(),
            Value<String?> conditionsJson = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductOffersCompanion(
            id: id,
            productId: productId,
            offerType: offerType,
            value: value,
            startAt: startAt,
            endAt: endAt,
            conditionsJson: conditionsJson,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required String offerType,
            required int value,
            required DateTime startAt,
            Value<DateTime?> endAt = const Value.absent(),
            Value<String?> conditionsJson = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductOffersCompanion.insert(
            id: id,
            productId: productId,
            offerType: offerType,
            value: value,
            startAt: startAt,
            endAt: endAt,
            conditionsJson: conditionsJson,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductOffersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductOffersTableReferences._productIdTable(db),
                    referencedColumn:
                        $$ProductOffersTableReferences._productIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductOffersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductOffersTable,
    ProductOffer,
    $$ProductOffersTableFilterComposer,
    $$ProductOffersTableOrderingComposer,
    $$ProductOffersTableAnnotationComposer,
    $$ProductOffersTableCreateCompanionBuilder,
    $$ProductOffersTableUpdateCompanionBuilder,
    (ProductOffer, $$ProductOffersTableReferences),
    ProductOffer,
    PrefetchHooks Function({bool productId})>;
typedef $$ProductDiscountsTableCreateCompanionBuilder
    = ProductDiscountsCompanion Function({
  required String id,
  required String productId,
  required String discountType,
  required int value,
  required DateTime startAt,
  Value<DateTime?> endAt,
  Value<String?> conditionsJson,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ProductDiscountsTableUpdateCompanionBuilder
    = ProductDiscountsCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<String> discountType,
  Value<int> value,
  Value<DateTime> startAt,
  Value<DateTime?> endAt,
  Value<String?> conditionsJson,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$ProductDiscountsTableReferences extends BaseReferences<
    _$AppDatabase, $ProductDiscountsTable, ProductDiscount> {
  $$ProductDiscountsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('product_discounts__product_id__products__id');

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProductDiscountsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductDiscountsTable> {
  $$ProductDiscountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discountType => $composableBuilder(
      column: $table.discountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endAt => $composableBuilder(
      column: $table.endAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conditionsJson => $composableBuilder(
      column: $table.conditionsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductDiscountsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductDiscountsTable> {
  $$ProductDiscountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discountType => $composableBuilder(
      column: $table.discountType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
      column: $table.startAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
      column: $table.endAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conditionsJson => $composableBuilder(
      column: $table.conditionsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductDiscountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductDiscountsTable> {
  $$ProductDiscountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get discountType => $composableBuilder(
      column: $table.discountType, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<String> get conditionsJson => $composableBuilder(
      column: $table.conditionsJson, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductDiscountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductDiscountsTable,
    ProductDiscount,
    $$ProductDiscountsTableFilterComposer,
    $$ProductDiscountsTableOrderingComposer,
    $$ProductDiscountsTableAnnotationComposer,
    $$ProductDiscountsTableCreateCompanionBuilder,
    $$ProductDiscountsTableUpdateCompanionBuilder,
    (ProductDiscount, $$ProductDiscountsTableReferences),
    ProductDiscount,
    PrefetchHooks Function({bool productId})> {
  $$ProductDiscountsTableTableManager(
      _$AppDatabase db, $ProductDiscountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductDiscountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductDiscountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductDiscountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> discountType = const Value.absent(),
            Value<int> value = const Value.absent(),
            Value<DateTime> startAt = const Value.absent(),
            Value<DateTime?> endAt = const Value.absent(),
            Value<String?> conditionsJson = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductDiscountsCompanion(
            id: id,
            productId: productId,
            discountType: discountType,
            value: value,
            startAt: startAt,
            endAt: endAt,
            conditionsJson: conditionsJson,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required String discountType,
            required int value,
            required DateTime startAt,
            Value<DateTime?> endAt = const Value.absent(),
            Value<String?> conditionsJson = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductDiscountsCompanion.insert(
            id: id,
            productId: productId,
            discountType: discountType,
            value: value,
            startAt: startAt,
            endAt: endAt,
            conditionsJson: conditionsJson,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProductDiscountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$ProductDiscountsTableReferences._productIdTable(db),
                    referencedColumn: $$ProductDiscountsTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ProductDiscountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductDiscountsTable,
    ProductDiscount,
    $$ProductDiscountsTableFilterComposer,
    $$ProductDiscountsTableOrderingComposer,
    $$ProductDiscountsTableAnnotationComposer,
    $$ProductDiscountsTableCreateCompanionBuilder,
    $$ProductDiscountsTableUpdateCompanionBuilder,
    (ProductDiscount, $$ProductDiscountsTableReferences),
    ProductDiscount,
    PrefetchHooks Function({bool productId})>;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  required String title,
  required String content,
  Value<String?> tagsJson,
  Value<bool> isPinned,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String> content,
  Value<String?> tagsJson,
  Value<bool> isPinned,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tagsJson => $composableBuilder(
      column: $table.tagsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get tagsJson =>
      $composableBuilder(column: $table.tagsJson, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()> {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> tagsJson = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion(
            id: id,
            title: title,
            content: content,
            tagsJson: tagsJson,
            isPinned: isPinned,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String content,
            Value<String?> tagsJson = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              NotesCompanion.insert(
            id: id,
            title: title,
            content: content,
            tagsJson: tagsJson,
            isPinned: isPinned,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotesTable,
    Note,
    $$NotesTableFilterComposer,
    $$NotesTableOrderingComposer,
    $$NotesTableAnnotationComposer,
    $$NotesTableCreateCompanionBuilder,
    $$NotesTableUpdateCompanionBuilder,
    (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
    Note,
    PrefetchHooks Function()>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String title,
  Value<String?> description,
  required DateTime dueAt,
  Value<String> priority,
  Value<String> status,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<String?> description,
  Value<DateTime> dueAt,
  Value<String> priority,
  Value<String> status,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
      column: $table.dueAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<DateTime> dueAt = const Value.absent(),
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            title: title,
            description: description,
            dueAt: dueAt,
            priority: priority,
            status: status,
            completedAt: completedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<String?> description = const Value.absent(),
            required DateTime dueAt,
            Value<String> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            title: title,
            description: description,
            dueAt: dueAt,
            priority: priority,
            status: status,
            completedAt: completedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
    Reminder,
    PrefetchHooks Function()>;
typedef $$ChecklistsTableCreateCompanionBuilder = ChecklistsCompanion Function({
  required String id,
  required String title,
  Value<bool> isArchived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ChecklistsTableUpdateCompanionBuilder = ChecklistsCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<bool> isArchived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ChecklistsTableReferences
    extends BaseReferences<_$AppDatabase, $ChecklistsTable, Checklist> {
  $$ChecklistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChecklistItemsTable, List<ChecklistItem>>
      _checklistItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.checklistItems,
              aliasName: 'checklists__id__checklist_items__checklist_id');

  $$ChecklistItemsTableProcessedTableManager get checklistItemsRefs {
    final manager = $$ChecklistItemsTableTableManager($_db, $_db.checklistItems)
        .filter((f) => f.checklistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ChecklistsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> checklistItemsRefs(
      Expression<bool> Function($$ChecklistItemsTableFilterComposer f) f) {
    final $$ChecklistItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.checklistItems,
        getReferencedColumn: (t) => t.checklistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChecklistItemsTableFilterComposer(
              $db: $db,
              $table: $db.checklistItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChecklistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ChecklistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
      column: $table.isArchived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> checklistItemsRefs<T extends Object>(
      Expression<T> Function($$ChecklistItemsTableAnnotationComposer a) f) {
    final $$ChecklistItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.checklistItems,
        getReferencedColumn: (t) => t.checklistId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChecklistItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.checklistItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ChecklistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistsTable,
    Checklist,
    $$ChecklistsTableFilterComposer,
    $$ChecklistsTableOrderingComposer,
    $$ChecklistsTableAnnotationComposer,
    $$ChecklistsTableCreateCompanionBuilder,
    $$ChecklistsTableUpdateCompanionBuilder,
    (Checklist, $$ChecklistsTableReferences),
    Checklist,
    PrefetchHooks Function({bool checklistItemsRefs})> {
  $$ChecklistsTableTableManager(_$AppDatabase db, $ChecklistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistsCompanion(
            id: id,
            title: title,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            Value<bool> isArchived = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistsCompanion.insert(
            id: id,
            title: title,
            isArchived: isArchived,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChecklistsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({checklistItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (checklistItemsRefs) db.checklistItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (checklistItemsRefs)
                    await $_getPrefetchedData<Checklist, $ChecklistsTable,
                            ChecklistItem>(
                        currentTable: table,
                        referencedTable: $$ChecklistsTableReferences
                            ._checklistItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ChecklistsTableReferences(db, table, p0)
                                .checklistItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.checklistId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ChecklistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChecklistsTable,
    Checklist,
    $$ChecklistsTableFilterComposer,
    $$ChecklistsTableOrderingComposer,
    $$ChecklistsTableAnnotationComposer,
    $$ChecklistsTableCreateCompanionBuilder,
    $$ChecklistsTableUpdateCompanionBuilder,
    (Checklist, $$ChecklistsTableReferences),
    Checklist,
    PrefetchHooks Function({bool checklistItemsRefs})>;
typedef $$ChecklistItemsTableCreateCompanionBuilder = ChecklistItemsCompanion
    Function({
  required String id,
  required String checklistId,
  required String textValue,
  Value<int> position,
  Value<bool> isDone,
  Value<int> rowid,
});
typedef $$ChecklistItemsTableUpdateCompanionBuilder = ChecklistItemsCompanion
    Function({
  Value<String> id,
  Value<String> checklistId,
  Value<String> textValue,
  Value<int> position,
  Value<bool> isDone,
  Value<int> rowid,
});

final class $$ChecklistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ChecklistItemsTable, ChecklistItem> {
  $$ChecklistItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ChecklistsTable _checklistIdTable(_$AppDatabase db) => db.checklists
      .createAlias('checklist_items__checklist_id__checklists__id');

  $$ChecklistsTableProcessedTableManager get checklistId {
    final $_column = $_itemColumn<String>('checklist_id')!;

    final manager = $$ChecklistsTableTableManager($_db, $_db.checklists)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checklistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get textValue => $composableBuilder(
      column: $table.textValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnFilters(column));

  $$ChecklistsTableFilterComposer get checklistId {
    final $$ChecklistsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.checklistId,
        referencedTable: $db.checklists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChecklistsTableFilterComposer(
              $db: $db,
              $table: $db.checklists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get textValue => $composableBuilder(
      column: $table.textValue, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position => $composableBuilder(
      column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDone => $composableBuilder(
      column: $table.isDone, builder: (column) => ColumnOrderings(column));

  $$ChecklistsTableOrderingComposer get checklistId {
    final $$ChecklistsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.checklistId,
        referencedTable: $db.checklists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChecklistsTableOrderingComposer(
              $db: $db,
              $table: $db.checklists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistItemsTable> {
  $$ChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get textValue =>
      $composableBuilder(column: $table.textValue, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<bool> get isDone =>
      $composableBuilder(column: $table.isDone, builder: (column) => column);

  $$ChecklistsTableAnnotationComposer get checklistId {
    final $$ChecklistsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.checklistId,
        referencedTable: $db.checklists,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChecklistsTableAnnotationComposer(
              $db: $db,
              $table: $db.checklists,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChecklistItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChecklistItemsTable,
    ChecklistItem,
    $$ChecklistItemsTableFilterComposer,
    $$ChecklistItemsTableOrderingComposer,
    $$ChecklistItemsTableAnnotationComposer,
    $$ChecklistItemsTableCreateCompanionBuilder,
    $$ChecklistItemsTableUpdateCompanionBuilder,
    (ChecklistItem, $$ChecklistItemsTableReferences),
    ChecklistItem,
    PrefetchHooks Function({bool checklistId})> {
  $$ChecklistItemsTableTableManager(
      _$AppDatabase db, $ChecklistItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> checklistId = const Value.absent(),
            Value<String> textValue = const Value.absent(),
            Value<int> position = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistItemsCompanion(
            id: id,
            checklistId: checklistId,
            textValue: textValue,
            position: position,
            isDone: isDone,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String checklistId,
            required String textValue,
            Value<int> position = const Value.absent(),
            Value<bool> isDone = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChecklistItemsCompanion.insert(
            id: id,
            checklistId: checklistId,
            textValue: textValue,
            position: position,
            isDone: isDone,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChecklistItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({checklistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (checklistId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.checklistId,
                    referencedTable:
                        $$ChecklistItemsTableReferences._checklistIdTable(db),
                    referencedColumn: $$ChecklistItemsTableReferences
                        ._checklistIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChecklistItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChecklistItemsTable,
    ChecklistItem,
    $$ChecklistItemsTableFilterComposer,
    $$ChecklistItemsTableOrderingComposer,
    $$ChecklistItemsTableAnnotationComposer,
    $$ChecklistItemsTableCreateCompanionBuilder,
    $$ChecklistItemsTableUpdateCompanionBuilder,
    (ChecklistItem, $$ChecklistItemsTableReferences),
    ChecklistItem,
    PrefetchHooks Function({bool checklistId})>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String valueJson,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> valueJson,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get valueJson => $composableBuilder(
      column: $table.valueJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get valueJson => $composableBuilder(
      column: $table.valueJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> valueJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion(
            key: key,
            valueJson: valueJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String valueJson,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            key: key,
            valueJson: valueJson,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$AuditLogsTableCreateCompanionBuilder = AuditLogsCompanion Function({
  required String id,
  required String entityType,
  required String entityId,
  required String action,
  Value<String?> beforeJson,
  Value<String?> afterJson,
  required DateTime createdAt,
  Value<String?> userId,
  Value<int> rowid,
});
typedef $$AuditLogsTableUpdateCompanionBuilder = AuditLogsCompanion Function({
  Value<String> id,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> action,
  Value<String?> beforeJson,
  Value<String?> afterJson,
  Value<DateTime> createdAt,
  Value<String?> userId,
  Value<int> rowid,
});

class $$AuditLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get beforeJson => $composableBuilder(
      column: $table.beforeJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get afterJson => $composableBuilder(
      column: $table.afterJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));
}

class $$AuditLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get beforeJson => $composableBuilder(
      column: $table.beforeJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get afterJson => $composableBuilder(
      column: $table.afterJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogsTable> {
  $$AuditLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get beforeJson => $composableBuilder(
      column: $table.beforeJson, builder: (column) => column);

  GeneratedColumn<String> get afterJson =>
      $composableBuilder(column: $table.afterJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);
}

class $$AuditLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
    AuditLog,
    PrefetchHooks Function()> {
  $$AuditLogsTableTableManager(_$AppDatabase db, $AuditLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> beforeJson = const Value.absent(),
            Value<String?> afterJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            beforeJson: beforeJson,
            afterJson: afterJson,
            createdAt: createdAt,
            userId: userId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityType,
            required String entityId,
            required String action,
            Value<String?> beforeJson = const Value.absent(),
            Value<String?> afterJson = const Value.absent(),
            required DateTime createdAt,
            Value<String?> userId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogsCompanion.insert(
            id: id,
            entityType: entityType,
            entityId: entityId,
            action: action,
            beforeJson: beforeJson,
            afterJson: afterJson,
            createdAt: createdAt,
            userId: userId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogsTable,
    AuditLog,
    $$AuditLogsTableFilterComposer,
    $$AuditLogsTableOrderingComposer,
    $$AuditLogsTableAnnotationComposer,
    $$AuditLogsTableCreateCompanionBuilder,
    $$AuditLogsTableUpdateCompanionBuilder,
    (AuditLog, BaseReferences<_$AppDatabase, $AuditLogsTable, AuditLog>),
    AuditLog,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$TaxProfilesTableTableManager get taxProfiles =>
      $$TaxProfilesTableTableManager(_db, _db.taxProfiles);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductBatchesTableTableManager get productBatches =>
      $$ProductBatchesTableTableManager(_db, _db.productBatches);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db, _db.purchases);
  $$PurchaseItemsTableTableManager get purchaseItems =>
      $$PurchaseItemsTableTableManager(_db, _db.purchaseItems);
  $$ReservationsTableTableManager get reservations =>
      $$ReservationsTableTableManager(_db, _db.reservations);
  $$ReservationItemsTableTableManager get reservationItems =>
      $$ReservationItemsTableTableManager(_db, _db.reservationItems);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$BatchAllocationsTableTableManager get batchAllocations =>
      $$BatchAllocationsTableTableManager(_db, _db.batchAllocations);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$ReturnsTableTableManager get returns =>
      $$ReturnsTableTableManager(_db, _db.returns);
  $$ReturnItemsTableTableManager get returnItems =>
      $$ReturnItemsTableTableManager(_db, _db.returnItems);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$PriceHistoryTableTableManager get priceHistory =>
      $$PriceHistoryTableTableManager(_db, _db.priceHistory);
  $$ProductOffersTableTableManager get productOffers =>
      $$ProductOffersTableTableManager(_db, _db.productOffers);
  $$ProductDiscountsTableTableManager get productDiscounts =>
      $$ProductDiscountsTableTableManager(_db, _db.productDiscounts);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$ChecklistsTableTableManager get checklists =>
      $$ChecklistsTableTableManager(_db, _db.checklists);
  $$ChecklistItemsTableTableManager get checklistItems =>
      $$ChecklistItemsTableTableManager(_db, _db.checklistItems);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$AuditLogsTableTableManager get auditLogs =>
      $$AuditLogsTableTableManager(_db, _db.auditLogs);
}

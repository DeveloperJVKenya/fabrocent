// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_period.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetFinancialPeriodCollection on Isar {
  IsarCollection<FinancialPeriod> get financialPeriods => this.collection();
}

const FinancialPeriodSchema = CollectionSchema(
  name: r'FinancialPeriod',
  id: -2314801977623840,
  properties: {
    r'endDate': PropertySchema(
      id: 0,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'expectedIncome': PropertySchema(
      id: 1,
      name: r'expectedIncome',
      type: IsarType.double,
    ),
    r'isActive': PropertySchema(id: 2, name: r'isActive', type: IsarType.bool),
    r'isClosed': PropertySchema(id: 3, name: r'isClosed', type: IsarType.bool),
    r'periodId': PropertySchema(
      id: 4,
      name: r'periodId',
      type: IsarType.string,
    ),
    r'startDate': PropertySchema(
      id: 5,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'totalExpenses': PropertySchema(
      id: 6,
      name: r'totalExpenses',
      type: IsarType.double,
    ),
    r'totalIncome': PropertySchema(
      id: 7,
      name: r'totalIncome',
      type: IsarType.double,
    ),
    r'userId': PropertySchema(id: 8, name: r'userId', type: IsarType.string),
  },

  estimateSize: _financialPeriodEstimateSize,
  serialize: _financialPeriodSerialize,
  deserialize: _financialPeriodDeserialize,
  deserializeProp: _financialPeriodDeserializeProp,
  idName: r'id',
  indexes: {
    r'periodId': IndexSchema(
      id: -2359000095730401,
      name: r'periodId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'periodId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'userId': IndexSchema(
      id: -1724743222504095,
      name: r'userId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'userId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _financialPeriodGetId,
  getLinks: _financialPeriodGetLinks,
  attach: _financialPeriodAttach,
  version: '3.4.1',
);

int _financialPeriodEstimateSize(
  FinancialPeriod object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.periodId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _financialPeriodSerialize(
  FinancialPeriod object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.endDate);
  writer.writeDouble(offsets[1], object.expectedIncome);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeBool(offsets[3], object.isClosed);
  writer.writeString(offsets[4], object.periodId);
  writer.writeDateTime(offsets[5], object.startDate);
  writer.writeDouble(offsets[6], object.totalExpenses);
  writer.writeDouble(offsets[7], object.totalIncome);
  writer.writeString(offsets[8], object.userId);
}

FinancialPeriod _financialPeriodDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = FinancialPeriod();
  object.endDate = reader.readDateTime(offsets[0]);
  object.expectedIncome = reader.readDoubleOrNull(offsets[1]);
  object.id = id;
  object.isActive = reader.readBool(offsets[2]);
  object.isClosed = reader.readBool(offsets[3]);
  object.periodId = reader.readString(offsets[4]);
  object.startDate = reader.readDateTime(offsets[5]);
  object.totalExpenses = reader.readDouble(offsets[6]);
  object.totalIncome = reader.readDouble(offsets[7]);
  object.userId = reader.readString(offsets[8]);
  return object;
}

P _financialPeriodDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _financialPeriodGetId(FinancialPeriod object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _financialPeriodGetLinks(FinancialPeriod object) {
  return [];
}

void _financialPeriodAttach(
  IsarCollection<dynamic> col,
  Id id,
  FinancialPeriod object,
) {
  object.id = id;
}

extension FinancialPeriodByIndex on IsarCollection<FinancialPeriod> {
  Future<FinancialPeriod?> getByPeriodId(String periodId) {
    return getByIndex(r'periodId', [periodId]);
  }

  FinancialPeriod? getByPeriodIdSync(String periodId) {
    return getByIndexSync(r'periodId', [periodId]);
  }

  Future<bool> deleteByPeriodId(String periodId) {
    return deleteByIndex(r'periodId', [periodId]);
  }

  bool deleteByPeriodIdSync(String periodId) {
    return deleteByIndexSync(r'periodId', [periodId]);
  }

  Future<List<FinancialPeriod?>> getAllByPeriodId(List<String> periodIdValues) {
    final values = periodIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'periodId', values);
  }

  List<FinancialPeriod?> getAllByPeriodIdSync(List<String> periodIdValues) {
    final values = periodIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'periodId', values);
  }

  Future<int> deleteAllByPeriodId(List<String> periodIdValues) {
    final values = periodIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'periodId', values);
  }

  int deleteAllByPeriodIdSync(List<String> periodIdValues) {
    final values = periodIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'periodId', values);
  }

  Future<Id> putByPeriodId(FinancialPeriod object) {
    return putByIndex(r'periodId', object);
  }

  Id putByPeriodIdSync(FinancialPeriod object, {bool saveLinks = true}) {
    return putByIndexSync(r'periodId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPeriodId(List<FinancialPeriod> objects) {
    return putAllByIndex(r'periodId', objects);
  }

  List<Id> putAllByPeriodIdSync(
    List<FinancialPeriod> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'periodId', objects, saveLinks: saveLinks);
  }
}

extension FinancialPeriodQueryWhereSort
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QWhere> {
  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FinancialPeriodQueryWhere
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QWhereClause> {
  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause>
  periodIdEqualTo(String periodId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'periodId', value: [periodId]),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause>
  periodIdNotEqualTo(String periodId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'periodId',
                lower: [],
                upper: [periodId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'periodId',
                lower: [periodId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'periodId',
                lower: [periodId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'periodId',
                lower: [],
                upper: [periodId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause>
  userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterWhereClause>
  userIdNotEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [userId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'userId',
                lower: [],
                upper: [userId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension FinancialPeriodQueryFilter
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QFilterCondition> {
  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endDate', value: value),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  endDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  endDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  expectedIncomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'expectedIncome'),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  expectedIncomeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'expectedIncome'),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  expectedIncomeEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'expectedIncome',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  expectedIncomeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expectedIncome',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  expectedIncomeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expectedIncome',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  expectedIncomeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expectedIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  isClosedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isClosed', value: value),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'periodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'periodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'periodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'periodId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'periodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'periodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'periodId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'periodId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  periodIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  startDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: value),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  startDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  startDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalExpensesEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalExpenses',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalExpensesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalExpenses',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalExpensesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalExpenses',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalExpensesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalExpenses',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalIncomeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalIncome',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalIncomeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalIncome',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalIncomeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalIncome',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  totalIncomeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalIncome',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension FinancialPeriodQueryObject
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QFilterCondition> {}

extension FinancialPeriodQueryLinks
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QFilterCondition> {}

extension FinancialPeriodQuerySortBy
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QSortBy> {
  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByExpectedIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClosed', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByIsClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClosed', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByTotalExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByTotalExpensesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByTotalIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIncome', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByTotalIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIncome', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension FinancialPeriodQuerySortThenBy
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QSortThenBy> {
  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByExpectedIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClosed', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByIsClosedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isClosed', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByTotalExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByTotalExpensesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExpenses', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByTotalIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIncome', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByTotalIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalIncome', Sort.desc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension FinancialPeriodQueryWhereDistinct
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct> {
  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedIncome');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByIsClosed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isClosed');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct> distinctByPeriodId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByTotalExpenses() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalExpenses');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct>
  distinctByTotalIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalIncome');
    });
  }

  QueryBuilder<FinancialPeriod, FinancialPeriod, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension FinancialPeriodQueryProperty
    on QueryBuilder<FinancialPeriod, FinancialPeriod, QQueryProperty> {
  QueryBuilder<FinancialPeriod, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<FinancialPeriod, DateTime, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<FinancialPeriod, double?, QQueryOperations>
  expectedIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedIncome');
    });
  }

  QueryBuilder<FinancialPeriod, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<FinancialPeriod, bool, QQueryOperations> isClosedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isClosed');
    });
  }

  QueryBuilder<FinancialPeriod, String, QQueryOperations> periodIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodId');
    });
  }

  QueryBuilder<FinancialPeriod, DateTime, QQueryOperations>
  startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<FinancialPeriod, double, QQueryOperations>
  totalExpensesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalExpenses');
    });
  }

  QueryBuilder<FinancialPeriod, double, QQueryOperations>
  totalIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalIncome');
    });
  }

  QueryBuilder<FinancialPeriod, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

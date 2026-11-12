// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetBudgetAllocationCollection on Isar {
  IsarCollection<BudgetAllocation> get budgetAllocations => this.collection();
}

const BudgetAllocationSchema = CollectionSchema(
  name: r'BudgetAllocation',
  id: 461844550080399,
  properties: {
    r'alert100Sent': PropertySchema(
      id: 0,
      name: r'alert100Sent',
      type: IsarType.bool,
    ),
    r'alert80Sent': PropertySchema(
      id: 1,
      name: r'alert80Sent',
      type: IsarType.bool,
    ),
    r'alertAt100': PropertySchema(
      id: 2,
      name: r'alertAt100',
      type: IsarType.bool,
    ),
    r'alertAt80': PropertySchema(
      id: 3,
      name: r'alertAt80',
      type: IsarType.bool,
    ),
    r'allocatedAmount': PropertySchema(
      id: 4,
      name: r'allocatedAmount',
      type: IsarType.double,
    ),
    r'allocatedPercent': PropertySchema(
      id: 5,
      name: r'allocatedPercent',
      type: IsarType.double,
    ),
    r'categoryId': PropertySchema(
      id: 6,
      name: r'categoryId',
      type: IsarType.byte,
      enumMap: _BudgetAllocationcategoryIdEnumValueMap,
    ),
    r'periodId': PropertySchema(
      id: 7,
      name: r'periodId',
      type: IsarType.string,
    ),
    r'spentAmount': PropertySchema(
      id: 8,
      name: r'spentAmount',
      type: IsarType.double,
    ),
    r'userId': PropertySchema(id: 9, name: r'userId', type: IsarType.string),
  },

  estimateSize: _budgetAllocationEstimateSize,
  serialize: _budgetAllocationSerialize,
  deserialize: _budgetAllocationDeserialize,
  deserializeProp: _budgetAllocationDeserializeProp,
  idName: r'id',
  indexes: {
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
    r'periodId': IndexSchema(
      id: -2359000095730401,
      name: r'periodId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'periodId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _budgetAllocationGetId,
  getLinks: _budgetAllocationGetLinks,
  attach: _budgetAllocationAttach,
  version: '3.4.1',
);

int _budgetAllocationEstimateSize(
  BudgetAllocation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.periodId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _budgetAllocationSerialize(
  BudgetAllocation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.alert100Sent);
  writer.writeBool(offsets[1], object.alert80Sent);
  writer.writeBool(offsets[2], object.alertAt100);
  writer.writeBool(offsets[3], object.alertAt80);
  writer.writeDouble(offsets[4], object.allocatedAmount);
  writer.writeDouble(offsets[5], object.allocatedPercent);
  writer.writeByte(offsets[6], object.categoryId.index);
  writer.writeString(offsets[7], object.periodId);
  writer.writeDouble(offsets[8], object.spentAmount);
  writer.writeString(offsets[9], object.userId);
}

BudgetAllocation _budgetAllocationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetAllocation();
  object.alert100Sent = reader.readBool(offsets[0]);
  object.alert80Sent = reader.readBool(offsets[1]);
  object.alertAt100 = reader.readBool(offsets[2]);
  object.alertAt80 = reader.readBool(offsets[3]);
  object.allocatedAmount = reader.readDouble(offsets[4]);
  object.allocatedPercent = reader.readDouble(offsets[5]);
  object.categoryId =
      _BudgetAllocationcategoryIdValueEnumMap[reader.readByteOrNull(
        offsets[6],
      )] ??
      TransactionCategoryId.foodGroceries;
  object.id = id;
  object.periodId = reader.readString(offsets[7]);
  object.spentAmount = reader.readDouble(offsets[8]);
  object.userId = reader.readString(offsets[9]);
  return object;
}

P _budgetAllocationDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (_BudgetAllocationcategoryIdValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TransactionCategoryId.foodGroceries)
          as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BudgetAllocationcategoryIdEnumValueMap = {
  'foodGroceries': 0,
  'transport': 1,
  'housing': 2,
  'utilities': 3,
  'education': 4,
  'health': 5,
  'business': 6,
  'entertainment': 7,
  'clothing': 8,
  'savings': 9,
  'debtRepayment': 10,
  'chama': 11,
  'charity': 12,
  'familySupport': 13,
  'airtime': 14,
  'payroll': 15,
  'income': 16,
  'businessIncome': 17,
  'uncategorized': 18,
};
const _BudgetAllocationcategoryIdValueEnumMap = {
  0: TransactionCategoryId.foodGroceries,
  1: TransactionCategoryId.transport,
  2: TransactionCategoryId.housing,
  3: TransactionCategoryId.utilities,
  4: TransactionCategoryId.education,
  5: TransactionCategoryId.health,
  6: TransactionCategoryId.business,
  7: TransactionCategoryId.entertainment,
  8: TransactionCategoryId.clothing,
  9: TransactionCategoryId.savings,
  10: TransactionCategoryId.debtRepayment,
  11: TransactionCategoryId.chama,
  12: TransactionCategoryId.charity,
  13: TransactionCategoryId.familySupport,
  14: TransactionCategoryId.airtime,
  15: TransactionCategoryId.payroll,
  16: TransactionCategoryId.income,
  17: TransactionCategoryId.businessIncome,
  18: TransactionCategoryId.uncategorized,
};

Id _budgetAllocationGetId(BudgetAllocation object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetAllocationGetLinks(BudgetAllocation object) {
  return [];
}

void _budgetAllocationAttach(
  IsarCollection<dynamic> col,
  Id id,
  BudgetAllocation object,
) {
  object.id = id;
}

extension BudgetAllocationQueryWhereSort
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QWhere> {
  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetAllocationQueryWhere
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QWhereClause> {
  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause> idBetween(
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
  userIdEqualTo(String userId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
  periodIdEqualTo(String periodId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'periodId', value: [periodId]),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterWhereClause>
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
}

extension BudgetAllocationQueryFilter
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QFilterCondition> {
  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  alert100SentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alert100Sent', value: value),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  alert80SentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alert80Sent', value: value),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  alertAt100EqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alertAt100', value: value),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  alertAt80EqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'alertAt80', value: value),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'allocatedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'allocatedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'allocatedAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'allocatedAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedPercentEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'allocatedPercent',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedPercentGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'allocatedPercent',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedPercentLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'allocatedPercent',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  allocatedPercentBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'allocatedPercent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  categoryIdEqualTo(TransactionCategoryId value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: value),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  categoryIdGreaterThan(TransactionCategoryId value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  categoryIdLessThan(TransactionCategoryId value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  categoryIdBetween(
    TransactionCategoryId lower,
    TransactionCategoryId upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  periodIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  periodIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  spentAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'spentAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  spentAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'spentAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  spentAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'spentAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  spentAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'spentAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
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

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension BudgetAllocationQueryObject
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QFilterCondition> {}

extension BudgetAllocationQueryLinks
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QFilterCondition> {}

extension BudgetAllocationQuerySortBy
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QSortBy> {
  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlert100Sent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert100Sent', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlert100SentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert100Sent', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlert80Sent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert80Sent', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlert80SentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert80Sent', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlertAt100() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt100', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlertAt100Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt100', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlertAt80() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt80', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAlertAt80Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt80', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAllocatedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAllocatedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAllocatedPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedPercent', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByAllocatedPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedPercent', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortBySpentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spentAmount', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortBySpentAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spentAmount', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BudgetAllocationQuerySortThenBy
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QSortThenBy> {
  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlert100Sent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert100Sent', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlert100SentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert100Sent', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlert80Sent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert80Sent', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlert80SentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alert80Sent', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlertAt100() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt100', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlertAt100Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt100', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlertAt80() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt80', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAlertAt80Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alertAt80', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAllocatedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAllocatedAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedAmount', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAllocatedPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedPercent', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByAllocatedPercentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allocatedPercent', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenBySpentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spentAmount', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenBySpentAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spentAmount', Sort.desc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QAfterSortBy>
  thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BudgetAllocationQueryWhereDistinct
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct> {
  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByAlert100Sent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alert100Sent');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByAlert80Sent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alert80Sent');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByAlertAt100() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alertAt100');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByAlertAt80() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alertAt80');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByAllocatedAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allocatedAmount');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByAllocatedPercent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allocatedPercent');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctByPeriodId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct>
  distinctBySpentAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spentAmount');
    });
  }

  QueryBuilder<BudgetAllocation, BudgetAllocation, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BudgetAllocationQueryProperty
    on QueryBuilder<BudgetAllocation, BudgetAllocation, QQueryProperty> {
  QueryBuilder<BudgetAllocation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetAllocation, bool, QQueryOperations>
  alert100SentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alert100Sent');
    });
  }

  QueryBuilder<BudgetAllocation, bool, QQueryOperations> alert80SentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alert80Sent');
    });
  }

  QueryBuilder<BudgetAllocation, bool, QQueryOperations> alertAt100Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alertAt100');
    });
  }

  QueryBuilder<BudgetAllocation, bool, QQueryOperations> alertAt80Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alertAt80');
    });
  }

  QueryBuilder<BudgetAllocation, double, QQueryOperations>
  allocatedAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allocatedAmount');
    });
  }

  QueryBuilder<BudgetAllocation, double, QQueryOperations>
  allocatedPercentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allocatedPercent');
    });
  }

  QueryBuilder<BudgetAllocation, TransactionCategoryId, QQueryOperations>
  categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<BudgetAllocation, String, QQueryOperations> periodIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodId');
    });
  }

  QueryBuilder<BudgetAllocation, double, QQueryOperations>
  spentAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spentAmount');
    });
  }

  QueryBuilder<BudgetAllocation, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetBudgetPlanCollection on Isar {
  IsarCollection<BudgetPlan> get budgetPlans => this.collection();
}

const BudgetPlanSchema = CollectionSchema(
  name: r'BudgetPlan',
  id: 1218925277847243,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'expectedIncome': PropertySchema(
      id: 1,
      name: r'expectedIncome',
      type: IsarType.double,
    ),
    r'isFromAiSuggestion': PropertySchema(
      id: 2,
      name: r'isFromAiSuggestion',
      type: IsarType.bool,
    ),
    r'isUserConfirmed': PropertySchema(
      id: 3,
      name: r'isUserConfirmed',
      type: IsarType.bool,
    ),
    r'periodId': PropertySchema(
      id: 4,
      name: r'periodId',
      type: IsarType.string,
    ),
    r'planId': PropertySchema(id: 5, name: r'planId', type: IsarType.string),
    r'userId': PropertySchema(id: 6, name: r'userId', type: IsarType.string),
  },

  estimateSize: _budgetPlanEstimateSize,
  serialize: _budgetPlanSerialize,
  deserialize: _budgetPlanDeserialize,
  deserializeProp: _budgetPlanDeserializeProp,
  idName: r'id',
  indexes: {
    r'planId': IndexSchema(
      id: 324115578639785,
      name: r'planId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'planId',
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

  getId: _budgetPlanGetId,
  getLinks: _budgetPlanGetLinks,
  attach: _budgetPlanAttach,
  version: '3.4.1',
);

int _budgetPlanEstimateSize(
  BudgetPlan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.periodId.length * 3;
  bytesCount += 3 + object.planId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _budgetPlanSerialize(
  BudgetPlan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDouble(offsets[1], object.expectedIncome);
  writer.writeBool(offsets[2], object.isFromAiSuggestion);
  writer.writeBool(offsets[3], object.isUserConfirmed);
  writer.writeString(offsets[4], object.periodId);
  writer.writeString(offsets[5], object.planId);
  writer.writeString(offsets[6], object.userId);
}

BudgetPlan _budgetPlanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetPlan();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.expectedIncome = reader.readDouble(offsets[1]);
  object.id = id;
  object.isFromAiSuggestion = reader.readBool(offsets[2]);
  object.isUserConfirmed = reader.readBool(offsets[3]);
  object.periodId = reader.readString(offsets[4]);
  object.planId = reader.readString(offsets[5]);
  object.userId = reader.readString(offsets[6]);
  return object;
}

P _budgetPlanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetPlanGetId(BudgetPlan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetPlanGetLinks(BudgetPlan object) {
  return [];
}

void _budgetPlanAttach(IsarCollection<dynamic> col, Id id, BudgetPlan object) {
  object.id = id;
}

extension BudgetPlanByIndex on IsarCollection<BudgetPlan> {
  Future<BudgetPlan?> getByPlanId(String planId) {
    return getByIndex(r'planId', [planId]);
  }

  BudgetPlan? getByPlanIdSync(String planId) {
    return getByIndexSync(r'planId', [planId]);
  }

  Future<bool> deleteByPlanId(String planId) {
    return deleteByIndex(r'planId', [planId]);
  }

  bool deleteByPlanIdSync(String planId) {
    return deleteByIndexSync(r'planId', [planId]);
  }

  Future<List<BudgetPlan?>> getAllByPlanId(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'planId', values);
  }

  List<BudgetPlan?> getAllByPlanIdSync(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'planId', values);
  }

  Future<int> deleteAllByPlanId(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'planId', values);
  }

  int deleteAllByPlanIdSync(List<String> planIdValues) {
    final values = planIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'planId', values);
  }

  Future<Id> putByPlanId(BudgetPlan object) {
    return putByIndex(r'planId', object);
  }

  Id putByPlanIdSync(BudgetPlan object, {bool saveLinks = true}) {
    return putByIndexSync(r'planId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPlanId(List<BudgetPlan> objects) {
    return putAllByIndex(r'planId', objects);
  }

  List<Id> putAllByPlanIdSync(
    List<BudgetPlan> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'planId', objects, saveLinks: saveLinks);
  }
}

extension BudgetPlanQueryWhereSort
    on QueryBuilder<BudgetPlan, BudgetPlan, QWhere> {
  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BudgetPlanQueryWhere
    on QueryBuilder<BudgetPlan, BudgetPlan, QWhereClause> {
  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> idBetween(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> planIdEqualTo(
    String planId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'planId', value: [planId]),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> planIdNotEqualTo(
    String planId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [],
                upper: [planId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [planId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [planId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'planId',
                lower: [],
                upper: [planId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> userIdEqualTo(
    String userId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterWhereClause> userIdNotEqualTo(
    String userId,
  ) {
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

extension BudgetPlanQueryFilter
    on QueryBuilder<BudgetPlan, BudgetPlan, QFilterCondition> {
  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  expectedIncomeEqualTo(double value, {double epsilon = Query.epsilon}) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  expectedIncomeGreaterThan(
    double value, {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  expectedIncomeLessThan(
    double value, {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  expectedIncomeBetween(
    double lower,
    double upper, {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  isFromAiSuggestionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFromAiSuggestion', value: value),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  isUserConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isUserConfirmed', value: value),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> periodIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> periodIdLessThan(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> periodIdBetween(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> periodIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> periodIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> periodIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  periodIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  periodIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'planId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'planId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'planId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> planIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'planId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  planIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'planId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdGreaterThan(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdBetween(
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition> userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension BudgetPlanQueryObject
    on QueryBuilder<BudgetPlan, BudgetPlan, QFilterCondition> {}

extension BudgetPlanQueryLinks
    on QueryBuilder<BudgetPlan, BudgetPlan, QFilterCondition> {}

extension BudgetPlanQuerySortBy
    on QueryBuilder<BudgetPlan, BudgetPlan, QSortBy> {
  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  sortByExpectedIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  sortByIsFromAiSuggestion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFromAiSuggestion', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  sortByIsFromAiSuggestionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFromAiSuggestion', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByIsUserConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUserConfirmed', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  sortByIsUserConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUserConfirmed', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BudgetPlanQuerySortThenBy
    on QueryBuilder<BudgetPlan, BudgetPlan, QSortThenBy> {
  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  thenByExpectedIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedIncome', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  thenByIsFromAiSuggestion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFromAiSuggestion', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  thenByIsFromAiSuggestionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFromAiSuggestion', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByIsUserConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUserConfirmed', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy>
  thenByIsUserConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUserConfirmed', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'planId', Sort.desc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension BudgetPlanQueryWhereDistinct
    on QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> {
  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> distinctByExpectedIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedIncome');
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct>
  distinctByIsFromAiSuggestion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFromAiSuggestion');
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> distinctByIsUserConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUserConfirmed');
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> distinctByPeriodId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> distinctByPlanId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'planId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BudgetPlan, BudgetPlan, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension BudgetPlanQueryProperty
    on QueryBuilder<BudgetPlan, BudgetPlan, QQueryProperty> {
  QueryBuilder<BudgetPlan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetPlan, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BudgetPlan, double, QQueryOperations> expectedIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedIncome');
    });
  }

  QueryBuilder<BudgetPlan, bool, QQueryOperations>
  isFromAiSuggestionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFromAiSuggestion');
    });
  }

  QueryBuilder<BudgetPlan, bool, QQueryOperations> isUserConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUserConfirmed');
    });
  }

  QueryBuilder<BudgetPlan, String, QQueryOperations> periodIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodId');
    });
  }

  QueryBuilder<BudgetPlan, String, QQueryOperations> planIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'planId');
    });
  }

  QueryBuilder<BudgetPlan, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

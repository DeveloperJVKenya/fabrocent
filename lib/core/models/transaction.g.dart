// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types, experimental_member_use

extension GetTransactionCollection on Isar {
  IsarCollection<Transaction> get transactions => this.collection();
}

const TransactionSchema = CollectionSchema(
  name: r'Transaction',
  id: 1474339493399079,
  properties: {
    r'accountNumber': PropertySchema(
      id: 0,
      name: r'accountNumber',
      type: IsarType.string,
    ),
    r'amount': PropertySchema(id: 1, name: r'amount', type: IsarType.double),
    r'balanceAfter': PropertySchema(
      id: 2,
      name: r'balanceAfter',
      type: IsarType.double,
    ),
    r'categorizedAt': PropertySchema(
      id: 3,
      name: r'categorizedAt',
      type: IsarType.dateTime,
    ),
    r'categoryId': PropertySchema(
      id: 4,
      name: r'categoryId',
      type: IsarType.byte,
      enumMap: _TransactioncategoryIdEnumValueMap,
    ),
    r'counterpartyName': PropertySchema(
      id: 5,
      name: r'counterpartyName',
      type: IsarType.string,
    ),
    r'counterpartyPhoneHashed': PropertySchema(
      id: 6,
      name: r'counterpartyPhoneHashed',
      type: IsarType.string,
    ),
    r'counterpartyPhoneLastFour': PropertySchema(
      id: 7,
      name: r'counterpartyPhoneLastFour',
      type: IsarType.string,
    ),
    r'dateTime': PropertySchema(
      id: 8,
      name: r'dateTime',
      type: IsarType.dateTime,
    ),
    r'fee': PropertySchema(id: 9, name: r'fee', type: IsarType.double),
    r'isCategoryAutoSuggested': PropertySchema(
      id: 10,
      name: r'isCategoryAutoSuggested',
      type: IsarType.bool,
    ),
    r'isCategoryConfirmed': PropertySchema(
      id: 11,
      name: r'isCategoryConfirmed',
      type: IsarType.bool,
    ),
    r'isCredit': PropertySchema(id: 12, name: r'isCredit', type: IsarType.bool),
    r'isPochi': PropertySchema(id: 13, name: r'isPochi', type: IsarType.bool),
    r'merchantName': PropertySchema(
      id: 14,
      name: r'merchantName',
      type: IsarType.string,
    ),
    r'needsSync': PropertySchema(
      id: 15,
      name: r'needsSync',
      type: IsarType.bool,
    ),
    r'paybillNumber': PropertySchema(
      id: 16,
      name: r'paybillNumber',
      type: IsarType.string,
    ),
    r'periodId': PropertySchema(
      id: 17,
      name: r'periodId',
      type: IsarType.string,
    ),
    r'rawSmsBody': PropertySchema(
      id: 18,
      name: r'rawSmsBody',
      type: IsarType.string,
    ),
    r'syncedAt': PropertySchema(
      id: 19,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'tillNumber': PropertySchema(
      id: 20,
      name: r'tillNumber',
      type: IsarType.string,
    ),
    r'txnId': PropertySchema(id: 21, name: r'txnId', type: IsarType.string),
    r'type': PropertySchema(
      id: 22,
      name: r'type',
      type: IsarType.byte,
      enumMap: _TransactiontypeEnumValueMap,
    ),
    r'userId': PropertySchema(id: 23, name: r'userId', type: IsarType.string),
  },

  estimateSize: _transactionEstimateSize,
  serialize: _transactionSerialize,
  deserialize: _transactionDeserialize,
  deserializeProp: _transactionDeserializeProp,
  idName: r'id',
  indexes: {
    r'txnId': IndexSchema(
      id: -2208970740984205,
      name: r'txnId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'txnId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'dateTime': IndexSchema(
      id: -3743990876366370,
      name: r'dateTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateTime',
          type: IndexType.value,
          caseSensitive: false,
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

  getId: _transactionGetId,
  getLinks: _transactionGetLinks,
  attach: _transactionAttach,
  version: '3.4.1',
);

int _transactionEstimateSize(
  Transaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.accountNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.counterpartyName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.counterpartyPhoneHashed;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.counterpartyPhoneLastFour;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.merchantName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.paybillNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.periodId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.rawSmsBody.length * 3;
  {
    final value = object.tillNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.txnId.length * 3;
  bytesCount += 3 + object.userId.length * 3;
  return bytesCount;
}

void _transactionSerialize(
  Transaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountNumber);
  writer.writeDouble(offsets[1], object.amount);
  writer.writeDouble(offsets[2], object.balanceAfter);
  writer.writeDateTime(offsets[3], object.categorizedAt);
  writer.writeByte(offsets[4], object.categoryId.index);
  writer.writeString(offsets[5], object.counterpartyName);
  writer.writeString(offsets[6], object.counterpartyPhoneHashed);
  writer.writeString(offsets[7], object.counterpartyPhoneLastFour);
  writer.writeDateTime(offsets[8], object.dateTime);
  writer.writeDouble(offsets[9], object.fee);
  writer.writeBool(offsets[10], object.isCategoryAutoSuggested);
  writer.writeBool(offsets[11], object.isCategoryConfirmed);
  writer.writeBool(offsets[12], object.isCredit);
  writer.writeBool(offsets[13], object.isPochi);
  writer.writeString(offsets[14], object.merchantName);
  writer.writeBool(offsets[15], object.needsSync);
  writer.writeString(offsets[16], object.paybillNumber);
  writer.writeString(offsets[17], object.periodId);
  writer.writeString(offsets[18], object.rawSmsBody);
  writer.writeDateTime(offsets[19], object.syncedAt);
  writer.writeString(offsets[20], object.tillNumber);
  writer.writeString(offsets[21], object.txnId);
  writer.writeByte(offsets[22], object.type.index);
  writer.writeString(offsets[23], object.userId);
}

Transaction _transactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Transaction();
  object.accountNumber = reader.readStringOrNull(offsets[0]);
  object.amount = reader.readDouble(offsets[1]);
  object.balanceAfter = reader.readDoubleOrNull(offsets[2]);
  object.categorizedAt = reader.readDateTimeOrNull(offsets[3]);
  object.categoryId =
      _TransactioncategoryIdValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      TransactionCategoryId.foodGroceries;
  object.counterpartyName = reader.readStringOrNull(offsets[5]);
  object.counterpartyPhoneHashed = reader.readStringOrNull(offsets[6]);
  object.counterpartyPhoneLastFour = reader.readStringOrNull(offsets[7]);
  object.dateTime = reader.readDateTime(offsets[8]);
  object.fee = reader.readDoubleOrNull(offsets[9]);
  object.id = id;
  object.isCategoryAutoSuggested = reader.readBool(offsets[10]);
  object.isCategoryConfirmed = reader.readBool(offsets[11]);
  object.isCredit = reader.readBool(offsets[12]);
  object.isPochi = reader.readBool(offsets[13]);
  object.merchantName = reader.readStringOrNull(offsets[14]);
  object.needsSync = reader.readBool(offsets[15]);
  object.paybillNumber = reader.readStringOrNull(offsets[16]);
  object.periodId = reader.readStringOrNull(offsets[17]);
  object.rawSmsBody = reader.readString(offsets[18]);
  object.syncedAt = reader.readDateTime(offsets[19]);
  object.tillNumber = reader.readStringOrNull(offsets[20]);
  object.txnId = reader.readString(offsets[21]);
  object.type =
      _TransactiontypeValueEnumMap[reader.readByteOrNull(offsets[22])] ??
      TransactionType.sendMoney;
  object.userId = reader.readString(offsets[23]);
  return object;
}

P _transactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (_TransactioncategoryIdValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              TransactionCategoryId.foodGroceries)
          as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (_TransactiontypeValueEnumMap[reader.readByteOrNull(offset)] ??
              TransactionType.sendMoney)
          as P;
    case 23:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TransactioncategoryIdEnumValueMap = {
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
const _TransactioncategoryIdValueEnumMap = {
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
const _TransactiontypeEnumValueMap = {
  'sendMoney': 0,
  'receiveMoney': 1,
  'paybill': 2,
  'buyGoods': 3,
  'withdraw': 4,
  'deposit': 5,
  'airtime': 6,
  'pochiReceive': 7,
  'pochiSend': 8,
  'salary': 9,
  'fulizaUsed': 10,
  'fulizaRepayment': 11,
  'mshwariDeposit': 12,
  'mshwariWithdraw': 13,
  'kcbMpesa': 14,
  'reversal': 15,
  'lipaMdogoMdogo': 16,
  'tillReceive': 17,
  'paybillReceive': 18,
  'unknown': 19,
};
const _TransactiontypeValueEnumMap = {
  0: TransactionType.sendMoney,
  1: TransactionType.receiveMoney,
  2: TransactionType.paybill,
  3: TransactionType.buyGoods,
  4: TransactionType.withdraw,
  5: TransactionType.deposit,
  6: TransactionType.airtime,
  7: TransactionType.pochiReceive,
  8: TransactionType.pochiSend,
  9: TransactionType.salary,
  10: TransactionType.fulizaUsed,
  11: TransactionType.fulizaRepayment,
  12: TransactionType.mshwariDeposit,
  13: TransactionType.mshwariWithdraw,
  14: TransactionType.kcbMpesa,
  15: TransactionType.reversal,
  16: TransactionType.lipaMdogoMdogo,
  17: TransactionType.tillReceive,
  18: TransactionType.paybillReceive,
  19: TransactionType.unknown,
};

Id _transactionGetId(Transaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _transactionGetLinks(Transaction object) {
  return [];
}

void _transactionAttach(
  IsarCollection<dynamic> col,
  Id id,
  Transaction object,
) {
  object.id = id;
}

extension TransactionByIndex on IsarCollection<Transaction> {
  Future<Transaction?> getByTxnId(String txnId) {
    return getByIndex(r'txnId', [txnId]);
  }

  Transaction? getByTxnIdSync(String txnId) {
    return getByIndexSync(r'txnId', [txnId]);
  }

  Future<bool> deleteByTxnId(String txnId) {
    return deleteByIndex(r'txnId', [txnId]);
  }

  bool deleteByTxnIdSync(String txnId) {
    return deleteByIndexSync(r'txnId', [txnId]);
  }

  Future<List<Transaction?>> getAllByTxnId(List<String> txnIdValues) {
    final values = txnIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'txnId', values);
  }

  List<Transaction?> getAllByTxnIdSync(List<String> txnIdValues) {
    final values = txnIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'txnId', values);
  }

  Future<int> deleteAllByTxnId(List<String> txnIdValues) {
    final values = txnIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'txnId', values);
  }

  int deleteAllByTxnIdSync(List<String> txnIdValues) {
    final values = txnIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'txnId', values);
  }

  Future<Id> putByTxnId(Transaction object) {
    return putByIndex(r'txnId', object);
  }

  Id putByTxnIdSync(Transaction object, {bool saveLinks = true}) {
    return putByIndexSync(r'txnId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTxnId(List<Transaction> objects) {
    return putAllByIndex(r'txnId', objects);
  }

  List<Id> putAllByTxnIdSync(
    List<Transaction> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'txnId', objects, saveLinks: saveLinks);
  }
}

extension TransactionQueryWhereSort
    on QueryBuilder<Transaction, Transaction, QWhere> {
  QueryBuilder<Transaction, Transaction, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhere> anyDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'dateTime'),
      );
    });
  }
}

extension TransactionQueryWhere
    on QueryBuilder<Transaction, Transaction, QWhereClause> {
  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> idBetween(
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

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> txnIdEqualTo(
    String txnId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'txnId', value: [txnId]),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> txnIdNotEqualTo(
    String txnId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'txnId',
                lower: [],
                upper: [txnId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'txnId',
                lower: [txnId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'txnId',
                lower: [txnId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'txnId',
                lower: [],
                upper: [txnId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateTimeEqualTo(
    DateTime dateTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateTime', value: [dateTime]),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateTimeNotEqualTo(
    DateTime dateTime,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateTime',
                lower: [],
                upper: [dateTime],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateTime',
                lower: [dateTime],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateTime',
                lower: [dateTime],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateTime',
                lower: [],
                upper: [dateTime],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateTimeGreaterThan(
    DateTime dateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateTime',
          lower: [dateTime],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateTimeLessThan(
    DateTime dateTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateTime',
          lower: [],
          upper: [dateTime],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> dateTimeBetween(
    DateTime lowerDateTime,
    DateTime upperDateTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateTime',
          lower: [lowerDateTime],
          includeLower: includeLower,
          upper: [upperDateTime],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> userIdEqualTo(
    String userId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'userId', value: [userId]),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterWhereClause> userIdNotEqualTo(
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

extension TransactionQueryFilter
    on QueryBuilder<Transaction, Transaction, QFilterCondition> {
  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'accountNumber'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'accountNumber'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountNumber', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  accountNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountNumber', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  balanceAfterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'balanceAfter'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  balanceAfterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'balanceAfter'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  balanceAfterEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'balanceAfter',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  balanceAfterGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'balanceAfter',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  balanceAfterLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'balanceAfter',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  balanceAfterBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'balanceAfter',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categorizedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'categorizedAt'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categorizedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'categorizedAt'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categorizedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categorizedAt', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categorizedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categorizedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categorizedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categorizedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categorizedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categorizedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  categoryIdEqualTo(TransactionCategoryId value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryId', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'counterpartyName'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'counterpartyName'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'counterpartyName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'counterpartyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'counterpartyName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'counterpartyName', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'counterpartyName', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'counterpartyPhoneHashed'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'counterpartyPhoneHashed'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'counterpartyPhoneHashed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'counterpartyPhoneHashed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'counterpartyPhoneHashed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'counterpartyPhoneHashed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'counterpartyPhoneHashed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'counterpartyPhoneHashed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'counterpartyPhoneHashed',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'counterpartyPhoneHashed',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'counterpartyPhoneHashed',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneHashedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'counterpartyPhoneHashed',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'counterpartyPhoneLastFour'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'counterpartyPhoneLastFour'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'counterpartyPhoneLastFour',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'counterpartyPhoneLastFour',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'counterpartyPhoneLastFour',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'counterpartyPhoneLastFour',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'counterpartyPhoneLastFour',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'counterpartyPhoneLastFour',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'counterpartyPhoneLastFour',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'counterpartyPhoneLastFour',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'counterpartyPhoneLastFour',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  counterpartyPhoneLastFourIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'counterpartyPhoneLastFour',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dateTimeEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateTime', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  dateTimeGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  dateTimeLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> dateTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> feeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'fee'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> feeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'fee'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> feeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fee',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> feeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fee',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> feeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fee',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> feeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fee',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  isCategoryAutoSuggestedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'isCategoryAutoSuggested',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  isCategoryConfirmedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCategoryConfirmed', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> isCreditEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCredit', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> isPochiEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPochi', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'merchantName'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'merchantName'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'merchantName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'merchantName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'merchantName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'merchantName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'merchantName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'merchantName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'merchantName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'merchantName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'merchantName', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  merchantNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'merchantName', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  needsSyncEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'needsSync', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paybillNumber'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paybillNumber'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paybillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paybillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paybillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paybillNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'paybillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'paybillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'paybillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'paybillNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'paybillNumber', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  paybillNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'paybillNumber', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  periodIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'periodId'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  periodIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'periodId'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> periodIdEqualTo(
    String? value, {
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  periodIdGreaterThan(
    String? value, {
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  periodIdLessThan(
    String? value, {
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> periodIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> periodIdMatches(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  periodIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  periodIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'periodId', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'rawSmsBody',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rawSmsBody',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rawSmsBody',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rawSmsBody',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'rawSmsBody',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'rawSmsBody',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'rawSmsBody',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'rawSmsBody',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rawSmsBody', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  rawSmsBodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'rawSmsBody', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> syncedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'syncedAt', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  syncedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  syncedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'syncedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> syncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'syncedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'tillNumber'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'tillNumber'),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tillNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tillNumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tillNumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tillNumber', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  tillNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tillNumber', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'txnId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  txnIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'txnId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'txnId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'txnId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'txnId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'txnId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'txnId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'txnId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> txnIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'txnId', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  txnIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'txnId', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeEqualTo(
    TransactionType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'type', value: value),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeGreaterThan(
    TransactionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeLessThan(
    TransactionType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'type',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> typeBetween(
    TransactionType lower,
    TransactionType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'type',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> userIdEqualTo(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> userIdLessThan(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> userIdBetween(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> userIdEndsWith(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> userIdContains(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition> userIdMatches(
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

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userId', value: ''),
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterFilterCondition>
  userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userId', value: ''),
      );
    });
  }
}

extension TransactionQueryObject
    on QueryBuilder<Transaction, Transaction, QFilterCondition> {}

extension TransactionQueryLinks
    on QueryBuilder<Transaction, Transaction, QFilterCondition> {}

extension TransactionQuerySortBy
    on QueryBuilder<Transaction, Transaction, QSortBy> {
  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByBalanceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByBalanceAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCategorizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorizedAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCategorizedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorizedAt', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCounterpartyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCounterpartyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCounterpartyPhoneHashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneHashed', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCounterpartyPhoneHashedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneHashed', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCounterpartyPhoneLastFour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneLastFour', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByCounterpartyPhoneLastFourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneLastFour', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByIsCategoryAutoSuggested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryAutoSuggested', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByIsCategoryAutoSuggestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryAutoSuggested', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByIsCategoryConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryConfirmed', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByIsCategoryConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryConfirmed', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsCreditDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsPochi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPochi', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByIsPochiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPochi', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByMerchantName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantName', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByMerchantNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantName', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByNeedsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsSync', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByNeedsSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsSync', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByPaybillNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paybillNumber', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  sortByPaybillNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paybillNumber', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByRawSmsBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSmsBody', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByRawSmsBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSmsBody', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTillNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tillNumber', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTillNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tillNumber', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTxnId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txnId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTxnIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txnId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension TransactionQuerySortThenBy
    on QueryBuilder<Transaction, Transaction, QSortThenBy> {
  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAccountNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByAccountNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountNumber', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByBalanceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByBalanceAfterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceAfter', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCategorizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorizedAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCategorizedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categorizedAt', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByCategoryIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCounterpartyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCounterpartyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyName', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCounterpartyPhoneHashed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneHashed', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCounterpartyPhoneHashedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneHashed', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCounterpartyPhoneLastFour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneLastFour', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByCounterpartyPhoneLastFourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'counterpartyPhoneLastFour', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateTime', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByFeeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fee', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByIsCategoryAutoSuggested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryAutoSuggested', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByIsCategoryAutoSuggestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryAutoSuggested', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByIsCategoryConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryConfirmed', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByIsCategoryConfirmedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCategoryConfirmed', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsCreditDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCredit', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsPochi() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPochi', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByIsPochiDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPochi', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByMerchantName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantName', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByMerchantNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'merchantName', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByNeedsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsSync', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByNeedsSyncDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'needsSync', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByPaybillNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paybillNumber', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy>
  thenByPaybillNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paybillNumber', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByPeriodId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByPeriodIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByRawSmsBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSmsBody', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByRawSmsBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawSmsBody', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTillNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tillNumber', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTillNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tillNumber', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTxnId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txnId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTxnIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'txnId', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<Transaction, Transaction, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }
}

extension TransactionQueryWhereDistinct
    on QueryBuilder<Transaction, Transaction, QDistinct> {
  QueryBuilder<Transaction, Transaction, QDistinct> distinctByAccountNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'accountNumber',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByBalanceAfter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balanceAfter');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByCategorizedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categorizedAt');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByCategoryId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryId');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByCounterpartyName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'counterpartyName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
  distinctByCounterpartyPhoneHashed({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'counterpartyPhoneHashed',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
  distinctByCounterpartyPhoneLastFour({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'counterpartyPhoneLastFour',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateTime');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByFee() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fee');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
  distinctByIsCategoryAutoSuggested() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCategoryAutoSuggested');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct>
  distinctByIsCategoryConfirmed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCategoryConfirmed');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByIsCredit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCredit');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByIsPochi() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPochi');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByMerchantName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'merchantName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByNeedsSync() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'needsSync');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByPaybillNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'paybillNumber',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByPeriodId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByRawSmsBody({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawSmsBody', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByTillNumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tillNumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByTxnId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'txnId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<Transaction, Transaction, QDistinct> distinctByUserId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }
}

extension TransactionQueryProperty
    on QueryBuilder<Transaction, Transaction, QQueryProperty> {
  QueryBuilder<Transaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> accountNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountNumber');
    });
  }

  QueryBuilder<Transaction, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<Transaction, double?, QQueryOperations> balanceAfterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balanceAfter');
    });
  }

  QueryBuilder<Transaction, DateTime?, QQueryOperations>
  categorizedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categorizedAt');
    });
  }

  QueryBuilder<Transaction, TransactionCategoryId, QQueryOperations>
  categoryIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryId');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations>
  counterpartyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterpartyName');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations>
  counterpartyPhoneHashedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterpartyPhoneHashed');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations>
  counterpartyPhoneLastFourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counterpartyPhoneLastFour');
    });
  }

  QueryBuilder<Transaction, DateTime, QQueryOperations> dateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateTime');
    });
  }

  QueryBuilder<Transaction, double?, QQueryOperations> feeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fee');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations>
  isCategoryAutoSuggestedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCategoryAutoSuggested');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations>
  isCategoryConfirmedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCategoryConfirmed');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> isCreditProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCredit');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> isPochiProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPochi');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> merchantNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'merchantName');
    });
  }

  QueryBuilder<Transaction, bool, QQueryOperations> needsSyncProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'needsSync');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> paybillNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paybillNumber');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> periodIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodId');
    });
  }

  QueryBuilder<Transaction, String, QQueryOperations> rawSmsBodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawSmsBody');
    });
  }

  QueryBuilder<Transaction, DateTime, QQueryOperations> syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<Transaction, String?, QQueryOperations> tillNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tillNumber');
    });
  }

  QueryBuilder<Transaction, String, QQueryOperations> txnIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'txnId');
    });
  }

  QueryBuilder<Transaction, TransactionType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Transaction, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }
}

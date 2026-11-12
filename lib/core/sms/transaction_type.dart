enum TransactionType {
  sendMoney,
  receiveMoney,
  paybill,
  buyGoods,
  withdraw,
  deposit,
  airtime,
  pochiReceive,
  pochiSend,
  salary,
  fulizaUsed,
  fulizaRepayment,
  mshwariDeposit,
  mshwariWithdraw,
  kcbMpesa,
  reversal,
  lipaMdogoMdogo,
  tillReceive,
  paybillReceive,
  unknown,
}

extension TransactionTypeX on TransactionType {
  bool get isCredit => const {
        TransactionType.receiveMoney,
        TransactionType.deposit,
        TransactionType.salary,
        TransactionType.pochiReceive,
        TransactionType.mshwariWithdraw,
        TransactionType.kcbMpesa,
        TransactionType.reversal,
        TransactionType.tillReceive,
        TransactionType.paybillReceive,
      }.contains(this);

  bool get isPochi => this == TransactionType.pochiReceive || this == TransactionType.pochiSend;

  bool get isBusinessIncome => this == TransactionType.tillReceive || this == TransactionType.paybillReceive;

  String get displayName {
    switch (this) {
      case TransactionType.sendMoney:        return 'Send Money';
      case TransactionType.receiveMoney:     return 'Receive Money';
      case TransactionType.paybill:          return 'Paybill Payment';
      case TransactionType.buyGoods:         return 'Buy Goods';
      case TransactionType.withdraw:         return 'Withdrawal';
      case TransactionType.deposit:          return 'Deposit';
      case TransactionType.airtime:          return 'Airtime';
      case TransactionType.pochiReceive:     return 'Pochi la Biashara (In)';
      case TransactionType.pochiSend:        return 'Pochi la Biashara (Out)';
      case TransactionType.salary:           return 'Salary / Income';
      case TransactionType.fulizaUsed:       return 'Fuliza Used';
      case TransactionType.fulizaRepayment:  return 'Fuliza Repayment';
      case TransactionType.mshwariDeposit:   return 'M-Shwari Deposit';
      case TransactionType.mshwariWithdraw:  return 'M-Shwari Withdrawal';
      case TransactionType.kcbMpesa:         return 'KCB M-PESA';
      case TransactionType.reversal:         return 'Reversal';
      case TransactionType.lipaMdogoMdogo:   return 'Lipa Mdogo Mdogo';
      case TransactionType.tillReceive:      return 'Till Payment Received';
      case TransactionType.paybillReceive:   return 'Paybill Payment Received';
      case TransactionType.unknown:          return 'Other';
    }
  }

  String get swahiliName {
    switch (this) {
      case TransactionType.sendMoney:        return 'Tuma Pesa';
      case TransactionType.receiveMoney:     return 'Pokea Pesa';
      case TransactionType.paybill:          return 'Lipa Bili';
      case TransactionType.buyGoods:         return 'Nunua Bidhaa';
      case TransactionType.withdraw:         return 'Toa Pesa';
      case TransactionType.deposit:          return 'Weka Pesa';
      case TransactionType.airtime:          return 'Nunua Airtime';
      case TransactionType.pochiReceive:     return 'Pochi (Pokea)';
      case TransactionType.pochiSend:        return 'Pochi (Tuma)';
      case TransactionType.salary:           return 'Mshahara';
      case TransactionType.fulizaUsed:       return 'Fuliza';
      case TransactionType.fulizaRepayment:  return 'Lipa Fuliza';
      case TransactionType.mshwariDeposit:   return 'Hifadhi M-Shwari';
      case TransactionType.mshwariWithdraw:  return 'Toa M-Shwari';
      case TransactionType.kcbMpesa:         return 'KCB M-PESA';
      case TransactionType.reversal:         return 'Rejesho';
      case TransactionType.lipaMdogoMdogo:   return 'Lipa Mdogo Mdogo';
      case TransactionType.tillReceive:      return 'Pokea (Till)';
      case TransactionType.paybillReceive:   return 'Pokea (Paybill)';
      case TransactionType.unknown:          return 'Nyingine';
    }
  }
}

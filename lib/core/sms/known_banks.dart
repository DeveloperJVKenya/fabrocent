/// Registry of Kenyan bank SMS senders.
/// Each bank may send from one or more sender addresses — we match any of them.
class KenyanBank {
  final String name;
  final String emoji;
  final List<String> senders; // exact sender strings as they appear in the inbox
  final String prefKey;

  const KenyanBank({
    required this.name,
    required this.emoji,
    required this.senders,
    required this.prefKey,
  });
}

const knownKenyanBanks = <KenyanBank>[
  KenyanBank(
    name: 'Equity Bank',
    emoji: '🏦',
    senders: ['EQUITY', 'EquityBnk', 'EquityBank', 'EQUITYBNK'],
    prefKey: 'bank_equity',
  ),
  KenyanBank(
    name: 'KCB Bank',
    emoji: '🏦',
    senders: ['KCB', 'KCBBank', 'KCBBANK'],
    prefKey: 'bank_kcb',
  ),
  KenyanBank(
    name: 'Co-operative Bank',
    emoji: '🏦',
    senders: ['Co-opBank', 'CO-OPBANK', 'COOPBANK', 'CoopBank'],
    prefKey: 'bank_coop',
  ),
  KenyanBank(
    name: 'NCBA Bank',
    emoji: '🏦',
    senders: ['NCBA', 'NCBABank', 'NCBABANK'],
    prefKey: 'bank_ncba',
  ),
  KenyanBank(
    name: 'Absa Kenya',
    emoji: '🏦',
    senders: ['ABSA', 'ABSAKENYA', 'AbsaKenya'],
    prefKey: 'bank_absa',
  ),
  KenyanBank(
    name: 'Family Bank',
    emoji: '🏦',
    senders: ['FamilyBank', 'FAMILYBANK', 'FAMILYBNK'],
    prefKey: 'bank_family',
  ),
  KenyanBank(
    name: 'I&M Bank',
    emoji: '🏦',
    senders: ['IMBank', 'I&MBank', 'I&M', 'IMBANK'],
    prefKey: 'bank_im',
  ),
  KenyanBank(
    name: 'DTB Bank',
    emoji: '🏦',
    senders: ['DTB', 'DTBBank', 'DTBBANK'],
    prefKey: 'bank_dtb',
  ),
  KenyanBank(
    name: 'Standard Chartered',
    emoji: '🏦',
    senders: ['SCBKENYA', 'StanChart', 'STANCHART'],
    prefKey: 'bank_sc',
  ),
  KenyanBank(
    name: 'Stanbic Bank',
    emoji: '🏦',
    senders: ['STANBIC', 'StanbicBank'],
    prefKey: 'bank_stanbic',
  ),
  KenyanBank(
    name: 'National Bank',
    emoji: '🏦',
    senders: ['NATIONALBANK', 'NBK', 'NationalBank'],
    prefKey: 'bank_nbk',
  ),
  KenyanBank(
    name: 'HF Group',
    emoji: '🏦',
    senders: ['HFGROUP', 'HFGroup', 'HFGRP'],
    prefKey: 'bank_hf',
  ),
];

/// Returns the KenyanBank for a given sender address, or null.
KenyanBank? bankForSender(String sender) {
  final upper = sender.trim().toUpperCase();
  for (final bank in knownKenyanBanks) {
    if (bank.senders.any((s) => s.toUpperCase() == upper)) return bank;
  }
  return null;
}

/// All distinct sender addresses across all known banks.
List<String> allBankSenders() =>
    knownKenyanBanks.expand((b) => b.senders).toList();

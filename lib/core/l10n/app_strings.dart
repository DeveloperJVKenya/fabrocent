import '../models/user_profile.dart';

/// All user-visible strings in English and Swahili.
/// Access via InheritedStrings.of(context).
class AppStrings {
  final AppLanguage language;
  const AppStrings(this.language);

  bool get _sw => language == AppLanguage.swahili;

  // ── App ───────────────────────────────────────────────────────────────────
  String get appName => 'FabroCent';

  // ── Common ────────────────────────────────────────────────────────────────
  String get next           => _sw ? 'Endelea'    : 'Next';
  String get back           => _sw ? 'Rudi'       : 'Back';
  String get cancel         => _sw ? 'Ghairi'     : 'Cancel';
  String get confirm        => _sw ? 'Thibitisha' : 'Confirm';
  String get save           => _sw ? 'Hifadhi'    : 'Save';
  String get clear          => _sw ? 'Futa'       : 'Clear';
  String get allow          => _sw ? 'Ruhusu'     : 'Allow';
  String get granted        => _sw ? 'Imeidhinishwa' : 'Granted';
  String get required       => _sw ? 'Lazima'     : 'Required';
  String get signOut        => _sw ? 'Toka'       : 'Sign Out';
  String get english        => _sw ? 'Kiingereza' : 'English';
  String get swahili        => 'Kiswahili';
  String get ksh            => 'Ksh';
  String get thisMonth      => _sw ? 'Mwezi Huu'  : 'This Month';
  String get noAllocations  => _sw ? 'Hakuna mgawanyo uliowekwa.' : 'No allocations set.';
  String get today          => _sw ? 'LEO'        : 'TODAY';
  String get yesterday      => _sw ? 'JANA'       : 'YESTERDAY';

  // ── Welcome ───────────────────────────────────────────────────────────────
  String get welcomeHeadline =>
      _sw ? 'Jua kila shilingi\nyako inaenda\nwapi.' : 'Know where\nevery shilling\ngoes.';
  String get welcomeSubtitle =>
      _sw ? 'FabroCent inasoma SMS yako ya M-Pesa kiotomatiki — bila kuandika mikono.'
          : 'FabroCent reads your M-Pesa SMS automatically — no manual entry, no guesswork.';
  String get welcomeCta       => _sw ? 'Anza' : 'Anza / Get Started';
  String get welcomePrivacy   => _sw ? 'Data yako inabaki kwenye simu yako kwanza.' : 'Your data stays on your device first.';
  String get featureSmsLabel      => _sw ? 'Usomaji wa SMS otomatiki'  : 'Auto SMS parsing';
  String get featureSmsSubtitle   => _sw ? 'Kila muamala wa M-Pesa unachukuliwa mara moja' : 'Every M-Pesa transaction captured instantly';
  String get featureCatLabel      => _sw ? 'Makundi ya akili'          : 'Smart categories';
  String get featureCatSubtitle   => _sw ? 'Chakula, Usafiri, Nyumba & zaidi'            : 'Chakula, Usafiri, Nyumba & 12 more';
  String get featureBudgetLabel   => _sw ? 'Arifa za bajeti'           : 'Budget alerts';
  String get featureBudgetSubtitle => _sw ? 'Jua kabla ya kutumia kupita kiasi' : 'Know before you overspend';

  // ── Auth — method tabs ────────────────────────────────────────────────────
  String get authTabEmail     => _sw ? 'Barua Pepe'   : 'Email';
  String get authTabPhone     => _sw ? 'Simu'         : 'Phone';

  // ── Auth — email ──────────────────────────────────────────────────────────
  String get authSignInTitle      => _sw ? 'Ingia'                      : 'Sign in';
  String get authSignInSubtitle   => _sw ? 'Karibu tena FabroCent'      : 'Welcome back to FabroCent';
  String get authSignUpTitle      => _sw ? 'Fungua Akaunti'             : 'Create account';
  String get authSignUpSubtitle   => _sw ? 'Anza safari yako ya FabroCent' : 'Get started with FabroCent';
  String get authEmailHint        => _sw ? 'barua@mfano.com'            : 'you@example.com';
  String get authPasswordHint     => _sw ? 'Nenosiri'                   : 'Password';
  String get authSignInBtn        => _sw ? 'Ingia'                      : 'Sign In';
  String get authSignUpBtn        => _sw ? 'Fungua Akaunti'             : 'Create Account';
  String get authForgotPassword   => _sw ? 'Umesahau nenosiri?'         : 'Forgot password?';
  String get authResetSent        => _sw ? 'Kiungo cha kuweka upya kimetumwa.' : 'Password reset link sent.';
  String get authNoAccount        => _sw ? 'Huna akaunti? Jisajili'     : "Don't have an account? Sign up";
  String get authHaveAccount      => _sw ? 'Una akaunti? Ingia'         : 'Already have an account? Sign in';

  // ── Auth — phone ──────────────────────────────────────────────────────────
  String get authPhoneTitle   => _sw ? 'Nambari Yako ya Simu'     : 'Your Phone Number';
  String get authPhoneSubtitle => _sw ? 'Tutatuma nambari ya kutumia mara moja kuhakikisha nambari yako.' : 'We\'ll send a one-time code to verify your number.';
  String get authOtpTitle     => _sw ? 'Weka Nambari ya OTP'      : 'Enter OTP';
  String authOtpSubtitle(String phone) =>
      _sw ? 'Weka nambari ya tarakimu 6 iliyotumwa kwa $phone'
          : 'Enter the 6-digit code sent to $phone';
  String get authSendCode     => _sw ? 'Tuma Nambari'   : 'Send Code';
  String get authVerifyCode   => _sw ? 'Thibitisha Nambari' : 'Verify Code';
  String get authChangeNumber => _sw ? 'Badilisha nambari'  : 'Change number';

  // ── Permissions ───────────────────────────────────────────────────────────
  String get permAllowAccess    => _sw ? 'Ruhusu Ufikiaji' : 'Allow Access';
  String get permSubtitle       => _sw ? 'FabroCent inahitaji ruhusa hizi kusoma miamala yako ya M-Pesa.' : 'FabroCent needs these permissions to read your M-Pesa transactions.';
  String get permSmsTitle       => _sw ? 'Soma SMS'    : 'Read SMS';
  String get permSmsSubtitle    => _sw ? 'Soma ujumbe wa uthibitisho wa M-Pesa tu. SMS zingine hazifikiwa kamwe.' : 'Read M-Pesa confirmation messages only. Your other SMS are never accessed.';
  String get permNotifTitle     => _sw ? 'Arifa'       : 'Notifications';
  String get permNotifSubtitle  => _sw ? 'Pata arifa unapokaribia kikomo chako cha bajeti.' : 'Get alerts when you approach your budget limit.';
  String get permPrivacy        => _sw ? 'FabroCent inasoma SMS za uthibitisho wa M-PESA tu kutoka kwa mtumaji "M-PESA". PIN yako haipo kamwe kwenye SMS na haifikiwa.' : 'FabroCent reads only M-Pesa confirmation SMS from sender "M-PESA". Your PIN is never in an SMS and is never accessed.';
  String get permContinue       => _sw ? 'Endelea' : 'Continue';
  String get permGrantAndContinue => _sw ? 'Ruhusu SMS na Endelea' : 'Grant SMS & Continue';
  String get permSmsRequired    => _sw ? 'Ruhusa ya SMS inahitajika kusoma miamala ya M-Pesa.' : 'SMS permission is required to read M-Pesa transactions.';

  // ── Profile setup ─────────────────────────────────────────────────────────
  String get profileNameTitle     => _sw ? 'Jina lako nani?'               : 'What\'s your name?';
  String get profileNameSubtitle  => _sw ? 'Si lazima — linatumiwa kuboresha dashibodi yako.' : 'Optional — used to personalise your dashboard.';
  String get profileNameHint      => _sw ? 'mfano Wanjiku, Brian...'        : 'e.g. Wanjiku, Brian...';
  String get profileLangLabel     => _sw ? 'Lugha / Language'               : 'Language / Lugha';
  String get profileSegTitle      => _sw ? 'Unatumia M-Pesa vipi?'          : 'How do you use M-Pesa?';
  String get profileSegSubtitle   => _sw ? 'Hii inatusaidia kuweka makundi sahihi.' : 'This helps us set up the right categories for you.';
  String get profileBizTitle      => _sw ? 'Akaunti za Biashara'            : 'Business Accounts';
  String get profileBizSubtitle   => _sw ? 'Je, unatumia huduma hizi za biashara za M-Pesa?' : 'Do you use any of these M-Pesa business services?';
  String get profileBizInfo       => _sw ? 'Unaweza kubadilisha hili baadaye katika Mipangilio wakati wowote.' : 'You can change this later in Settings at any time.';
  String get profileStartTracking => _sw ? 'Anza Kufuatilia' : 'Start Tracking';

  // ── Dashboard ─────────────────────────────────────────────────────────────
  String get netBalance       => _sw ? 'Salio Halisi'           : 'Net Balance';
  String get surplus          => _sw ? 'Ziada'                  : 'Surplus';
  String get deficit          => _sw ? 'Kasoro'                 : 'Deficit';
  String get income           => _sw ? 'Mapato'                 : 'Income';
  String get expenses         => _sw ? 'Matumizi'               : 'Expenses';
  String get weeklySpending   => _sw ? 'Matumizi ya Kila Wiki'  : 'Weekly Spending';
  String get spendingBreakdown => _sw ? 'Mgawanyo wa Matumizi'  : 'Spending Breakdown';
  String get incomeSources    => _sw ? 'Vyanzo vya Mapato'      : 'Income Sources';
  String get allCategories    => _sw ? 'Makundi Yote'           : 'All Categories';
  String get noExpensesYet    => _sw ? 'Hakuna matumizi bado'   : 'No expenses recorded yet';
  String get noIncomeYet      => _sw ? 'Hakuna mapato bado'     : 'No income recorded yet';
  String untaggedNudgeTitle(int n) =>
      _sw ? '$n muamala${n == 1 ? '' : ''} bila kundi'
          : '$n transaction${n == 1 ? '' : 's'} untagged';
  String untaggedNudgeSub(String amt) =>
      _sw ? 'Ksh $amt haijawekwa kundi' : 'Ksh $amt not yet categorised';
  String ofSpending(String pct) =>
      _sw ? '$pct% ya matumizi' : '$pct% of spending';

  // ── Transactions ──────────────────────────────────────────────────────────
  String get transactionsTitle  => _sw ? 'Miamala'               : 'Transactions';
  String get searchHint         => _sw ? 'Tafuta miamala...'     : 'Search transactions…';
  String get filterAll          => _sw ? 'Yote'                  : 'All';
  String get filterUntagged     => _sw ? 'Bila Kundi'            : 'Untagged';
  String get importSms          => _sw ? 'Ingiza SMS ya M-Pesa'  : 'Import M-Pesa SMS';
  String get importing          => _sw ? 'Inaingiza...'          : 'Importing...';
  String get noTransactions     => _sw ? 'Hakuna miamala bado'   : 'No transactions yet';
  String get noMatchTransactions => _sw ? 'Hakuna miamala inayolingana' : 'No matching transactions';
  String get removeFilterTip    => _sw ? 'Jaribu kuondoa kichujio kuona miamala yote.' : 'Try removing the filter to see all transactions.';
  String get tapImportTip       => _sw ? 'Bonyeza kitufe cha kupakua kuingiza historia ya SMS ya M-Pesa.' : 'Tap the download button to import your M-Pesa SMS history.';
  String get tapToCategorise    => _sw ? 'Bonyeza kuweka kundi'  : 'Tap to categorise';
  String untaggedNeedCat(int n) =>
      _sw ? '$n muamala${n == 1 ? '' : ''} unahitaji kundi'
          : '$n transaction${n == 1 ? '' : 's'} need a category';

  // ── Category tag sheet ────────────────────────────────────────────────────
  String get selectCategory     => _sw ? 'Chagua Kundi'       : 'Select Category';
  String get confirmCategory    => _sw ? 'Thibitisha Kundi'   : 'Confirm Category';
  String get selectCategoryFirst => _sw ? 'Chagua kundi'      : 'Select a category';
  String get aiSuggests         => _sw ? 'AI inashauriwa'     : 'AI suggests';
  String get aiSuggestionLabel  => _sw ? 'Pendekezo la AI'    : 'AI suggestion';

  // ── Budget ────────────────────────────────────────────────────────────────
  String get budgetTitle          => _sw ? 'Bajeti'               : 'Budget';
  String get editBudget           => _sw ? 'Hariri bajeti'        : 'Edit budget';
  String get setBudgetTitle       => _sw ? 'Weka Bajeti Yako'     : 'Set Your Budget';
  String get setBudgetSubtitle    =>
      _sw ? 'Weka mapato yako yanayotarajiwa kwa mwezi na ugawe kwenye makundi.'
          : 'Enter your expected monthly income and allocate it\nacross spending categories.';
  String get setUpBudget          => _sw ? 'Weka Bajeti'          : 'Set Up Budget';
  String get spendingLimits       => _sw ? 'Mipaka ya Matumizi'   : 'Spending Limits';
  String get expectedMonthlyIncome => _sw ? 'Mapato Yanayotarajiwa kwa Mwezi' : 'Expected Monthly Income';
  String get over                 => _sw ? 'Imepita'              : 'Over';
  String budgetSpent(String amt)  => _sw ? 'Ksh $amt imetumika'   : 'Ksh $amt spent';
  String budgetLeft(String amt)   => _sw ? 'Ksh $amt imebaki'     : 'Ksh $amt left';
  String budgetOverBy(String amt) => _sw ? 'Ksh $amt kupita mipaka' : 'Ksh $amt over limit';
  String budgetLine(String amt, String pct) =>
      _sw ? 'Bajeti: Ksh $amt ($pct% ya mapato)' : 'Budget: Ksh $amt ($pct% of income)';

  // ── Settings ──────────────────────────────────────────────────────────────
  String get settingsTitle          => _sw ? 'Mipangilio'               : 'Settings';
  String get accountSection         => _sw ? 'AKAUNTI'                  : 'ACCOUNT';
  String get preferencesSection     => _sw ? 'MAPENDELEO'               : 'PREFERENCES';
  String get pochiSection           => _sw ? 'POCHI LA BIASHARA'        : 'POCHI LA BIASHARA';
  String get dataSection            => _sw ? 'DATA'                     : 'DATA';
  String get aboutSection           => _sw ? 'KUHUSU'                   : 'ABOUT';
  String get nameLabel              => _sw ? 'Jina'                     : 'Name';
  String get phoneLabel             => _sw ? 'Simu'                     : 'Phone';
  String get profileTypeLabel       => _sw ? 'Aina ya Profaili'         : 'Profile Type';
  String get languageLabel          => _sw ? 'Lugha'                    : 'Language';
  String get budgetAlertsLabel      => _sw ? 'Arifa za Bajeti'          : 'Budget Alerts';
  String get budgetAlertsSubtitle   => _sw ? 'Arifa kwa 80% na 100% ya kikomo' : 'Notify at 80% and 100% of limit';
  String get syncToCloud            => _sw ? 'Hifadhi Mtandaoni'        : 'Sync to Cloud';
  String get syncSubtitle           => _sw ? 'Pakia miamala ya ndani kwenye Firebase' : 'Upload local transactions to Firebase';
  String get syncAndroidOnly        => _sw ? 'Inapatikana kwenye Android tu' : 'Available on Android only';
  String get clearLocalData         => _sw ? 'Futa Data ya Ndani'       : 'Clear Local Data';
  String get clearSubtitle          => _sw ? 'Ondoa miamala yote kwenye simu hii' : 'Remove all transactions from this device';
  String get clearNoWeb             => _sw ? 'Hakuna data ya ndani kwenye wavuti' : 'No local data on web';
  String get clearConfirmTitle      => _sw ? 'Futa data ya ndani?'      : 'Clear local data?';
  String get clearConfirmBody       =>
      _sw ? 'Miamala yote na bajeti zilizohifadhiwa kwenye simu hii zitafutwa. Data iliyohifadhiwa mtandaoni haitathiriwa.'
          : 'All transactions and budgets stored on this device will be deleted. Cloud-synced data is not affected.';
  String get privacyLabel           => _sw ? 'Faragha'                  : 'Privacy';
  String get privacyValue           =>
      _sw ? 'Inasoma SMS za uthibitisho wa M-PESA tu. Haifikii PIN.'
          : 'Reads only M-PESA confirmation SMS. Never accesses PINs.';
  String get addPhoto               => _sw ? 'Ongeza picha'             : 'Add photo';
  String get changePhoto            => _sw ? 'Badilisha picha'          : 'Change photo';
  String get yourAccount            => _sw ? 'Akaunti Yako'             : 'Your Account';
  String get signOutConfirmTitle    => _sw ? 'Toka?'                    : 'Sign out?';
  String get signOutConfirmBody     => _sw ? 'Data yako ya ndani itabaki kwenye simu hii.' : 'Your local data will remain on this device.';
  String get alreadyUpToDate        => _sw ? 'Imesasishwa tayari.'      : 'Already up to date.';
  String syncedCount(int n) =>
      _sw ? 'Ilihifadhi $n muamala${n == 1 ? '' : ''}.'
          : 'Synced $n transaction${n == 1 ? '' : 's'}.';
  String get localDataCleared  => _sw ? 'Data ya ndani imefutwa.'       : 'Local data cleared.';
  String get photoUpdated      => _sw ? 'Picha ya profaili imesasishwa.' : 'Profile photo updated.';
  String get webPhotoNotSupported => _sw ? 'Upakiaji wa picha hauungwi mkono kwenye wavuti bado.' : 'Photo upload is not supported on web yet.';
  String get webSyncNotAvailable  => _sw ? 'Hifadhi inapatikana kwenye Android tu.'              : 'Sync is only available on Android.';
  String get webNoLocalData       => _sw ? 'Hakuna data ya ndani kwenye wavuti — data yote ipo mtandaoni.' : 'No local data on web — all data lives in the cloud.';

  // ── Bottom nav ────────────────────────────────────────────────────────────
  String get navDashboard     => _sw ? 'Muhtasari'  : 'Dashboard';
  String get navTransactions  => _sw ? 'Miamala'    : 'Transactions';
  String get navBudget        => _sw ? 'Bajeti'     : 'Budget';
  String get navSettings      => _sw ? 'Mipangilio' : 'Settings';
}

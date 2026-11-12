import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/inherited_strings.dart';
import '../../../core/models/transaction.dart';
import '../../../core/models/transaction_category.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/transactions_provider.dart';
import '../widgets/category_tag_sheet.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionCategoryId? _filterCategory;
  bool _showUntaggedOnly = false;
  bool _searchActive = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (kIsWeb) return;
      ref.read(smsImportProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final txnAsync = ref.watch(periodTransactionsProvider);
    final importState = ref.watch(smsImportProvider);

    return Scaffold(
      appBar: AppBar(
        title: _searchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: InheritedStrings.of(context).searchHint,
                  border: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                style: theme.textTheme.bodyMedium,
                onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              )
            : Text(InheritedStrings.of(context).transactionsTitle),
        actions: [
          // Search toggle
          IconButton(
            icon: Icon(_searchActive ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searchActive = !_searchActive;
                if (!_searchActive) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
          // Untagged filter
          if (!_searchActive)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FilterChip(
                label: Text(_showUntaggedOnly
                    ? InheritedStrings.of(context).filterUntagged
                    : InheritedStrings.of(context).filterAll),
                selected: _showUntaggedOnly,
                onSelected: (v) => setState(() => _showUntaggedOnly = v),
                avatar: Icon(
                  Icons.filter_list_rounded,
                  size: 16,
                  color: _showUntaggedOnly ? AppTheme.primary : null,
                ),
              ),
            ),
          // Import (Android only — web has no SMS access)
          if (!_searchActive && !kIsWeb)
            IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: InheritedStrings.of(context).importSms,
              onPressed: importState.isLoading
                  ? null
                  : () =>
                      ref.read(smsImportProvider.notifier).importHistoricalSms(),
            ),
        ],
      ),
      body: txnAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (transactions) {
          final filtered = _applyFilter(transactions);

          if (filtered.isEmpty) {
            return _EmptyState(
              isFiltered: _showUntaggedOnly || _filterCategory != null || _searchQuery.isNotEmpty,
              isImporting: importState.isLoading,
              onImport: () => ref.read(smsImportProvider.notifier).importHistoricalSms(),
            );
          }

          return CustomScrollView(
            slivers: [
              // Import progress bar
              if (importState.isLoading)
                SliverToBoxAdapter(
                  child: LinearProgressIndicator(
                    value: importState.total > 0
                        ? importState.imported / importState.total
                        : null,
                    backgroundColor: AppTheme.primaryContainer,
                    color: AppTheme.primary,
                  ),
                ),

              // Untagged banner
              ...(!_showUntaggedOnly ? [_buildUntaggedBanner(transactions, theme)] : []),

              // Date-grouped transaction list
              ..._buildGroupedList(filtered, theme),
            ],
          );
        },
      ),
    );
  }

  List<Transaction> _applyFilter(List<Transaction> all) {
    var list = all;
    if (_showUntaggedOnly) {
      list = list.where((t) => t.isUntagged).toList();
    }
    if (_filterCategory != null) {
      list = list.where((t) => t.categoryId == _filterCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      list = list.where((t) {
        final q = _searchQuery;
        return (t.counterpartyName?.toLowerCase().contains(q) ?? false) ||
            (t.merchantName?.toLowerCase().contains(q) ?? false) ||
            (t.paybillNumber?.toLowerCase().contains(q) ?? false) ||
            t.formattedAmount.toLowerCase().contains(q);
      }).toList();
    }
    return list;
  }

  Widget _buildUntaggedBanner(List<Transaction> transactions, ThemeData theme) {
    final untaggedCount = transactions.where((t) => t.isUntagged).length;
    if (untaggedCount == 0) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () => setState(() => _showUntaggedOnly = true),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.accentLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
          ),
          child: Row(
            children: [
              const Text('💡', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  InheritedStrings.of(context).untaggedNeedCat(untaggedCount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.warning,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.warning),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildGroupedList(List<Transaction> transactions, ThemeData theme) {
    if (transactions.isEmpty) return [];

    // Group by date
    final groups = <String, List<Transaction>>{};
    for (final txn in transactions) {
      final key = _dateGroupKey(txn.dateTime);
      groups.putIfAbsent(key, () => []).add(txn);
    }

    final widgets = <Widget>[];
    for (final entry in groups.entries) {
      widgets.add(SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(
            entry.key,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ));

      widgets.add(SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final txn = entry.value[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TransactionTile(
                  transaction: txn,
                  onTap: () => CategoryTagSheet.show(context, txn),
                ),
              );
            },
            childCount: entry.value.length,
          ),
        ),
      ));
    }

    // Bottom padding
    widgets.add(const SliverToBoxAdapter(child: SizedBox(height: 24)));
    return widgets;
  }

  String _dateGroupKey(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(date).inDays;
    final s = InheritedStrings.of(context);
    if (diff == 0) return s.today;
    if (diff == 1) return s.yesterday;
    if (diff < 7) {
      const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
      return days[dt.weekday - 1];
    }
    const months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

class _EmptyState extends StatelessWidget {
  final bool isFiltered;
  final bool isImporting;
  final VoidCallback onImport;

  const _EmptyState({
    required this.isFiltered,
    required this.isImporting,
    required this.onImport,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = InheritedStrings.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.receipt_long_outlined, color: AppTheme.primary, size: 36),
            ),
            const SizedBox(height: 20),
            Text(
              isFiltered ? s.noMatchTransactions : s.noTransactions,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered ? s.removeFilterTip : s.tapImportTip,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (!isFiltered && !kIsWeb) ...[
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: isImporting ? null : onImport,
                icon: isImporting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.download_rounded),
                label: Text(isImporting ? s.importing : s.importSms),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

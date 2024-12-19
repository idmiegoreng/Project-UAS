import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/weekly_balance.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  WeeklyBalance? currentWeek;
  final List<WeeklyBalance> weeklyBalances = [];

  @override
  void initState() {
    super.initState();
    _startNewWeek(500000);
  }

  void _startNewWeek(double initialBalance) {
    final newWeek = WeeklyBalance(
      weekNumber: (weeklyBalances.length + 1),
      initialBalance: initialBalance,
      startDate: DateTime.now(),
    );

    setState(() {
      weeklyBalances.add(newWeek);
      currentWeek = newWeek;
    });
  }

  void _addTransaction(Transaction transaction) {
    setState(() {
      currentWeek?.transactions.add(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _currentIndex == 0
                  ? 'DompetKost'
                  : _currentIndex == 1
                      ? 'Daftar Transaksi'
                      : 'Statistik',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: _currentIndex == 0
            ? [
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: const Icon(Icons.add_card, color: Colors.white),
                    onPressed: () => _showAddBalanceDialog(),
                    tooltip: 'Mulai Minggu Baru',
                  ),
                ),
              ]
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHomeScreen(),
              _buildTransactionsScreen(),
              _buildStatisticsScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Transaksi',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Statistik',
            ),
          ],
        ),
      ),
    );
  }

  // Home Screen Widget with enhanced UI
  Widget _buildHomeScreen() {
    return currentWeek == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tambahkan saldo mingguan untuk memulai',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Minggu ${currentWeek!.weekNumber}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Periode: ${currentWeek!.weekLabel}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Column(
                          children: [
                            const Text(
                              'Saldo Saat Ini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${currentWeek!.currentBalance.toStringAsFixed(0)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Pengeluaran',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Rp ${currentWeek!.totalExpenses.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // Transactions Screen Widget
  Widget _buildTransactionsScreen() {
    return currentWeek == null
        ? const Center(child: Text('Belum ada transaksi'))
        : Column(
            children: [
              Expanded(
                child: currentWeek!.transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada transaksi minggu ini',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: currentWeek!.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = currentWeek!.transactions[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.2),
                                child: Icon(
                                  Icons.remove,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              title: Text(
                                transaction.category,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: Text(
                                'Rp ${transaction.amount.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _showAddExpenseDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Pengeluaran'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  // Statistics Screen Widget
  Widget _buildStatisticsScreen() {
    if (currentWeek == null || currentWeek!.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum ada data untuk ditampilkan',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final categoryTotals = _getCategoryTotals();
    final totalExpenses = currentWeek!.totalExpenses;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Statistik Pengeluaran',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: PieChart(
              PieChartData(
                sections: _createPieChartSections(categoryTotals, totalExpenses),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: _buildCategoryList(categoryTotals, totalExpenses),
          ),
        ],
      ),
    );
  }

  // Helper methods for statistics
  Map<String, double> _getCategoryTotals() {
    final Map<String, double> totals = {};
    for (var transaction in currentWeek!.transactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }
    return totals;
  }

  List<PieChartSectionData> _createPieChartSections(
      Map<String, double> categoryTotals, double totalExpenses) {
    return categoryTotals.entries.map((entry) {
      final percentage = (entry.value / totalExpenses * 100);
      return PieChartSectionData(
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        color: _getCategoryColor(entry.key),
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();
  }

  Widget _buildCategoryList(
      Map<String, double> categoryTotals, double totalExpenses) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categoryTotals.length,
      itemBuilder: (context, index) {
        final entry = categoryTotals.entries.elementAt(index);
        final percentage = (entry.value / totalExpenses * 100);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: _getCategoryColor(entry.key),
            radius: 15,
          ),
          title: Text(entry.key),
          trailing: Text(
            'Rp ${entry.value.toStringAsFixed(0)} (${percentage.toStringAsFixed(1)}%)',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    final colors = {
      'Makanan': Colors.blue,
      'Transport': Colors.green,
      'Hiburan': Colors.orange,
      'Belanja': Colors.purple,
      'Tagihan': Colors.red,
      'Lainnya': Colors.grey,
    };
    return colors[category] ?? Colors.grey;
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final amountController = TextEditingController();
        String selectedCategory = TransactionCategories.expenseCategories.first;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Pengeluaran'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Jumlah',
                      prefixText: 'Rp ',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                    ),
                    items: TransactionCategories.expenseCategories
                        .map((category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isNotEmpty) {
                      final transaction = Transaction(
                        id: DateTime.now().toString(),
                        amount: double.parse(amountController.text),
                        category: selectedCategory,
                        date: DateTime.now(),
                        type: TransactionType.expense,
                        weekNumber: currentWeek?.weekNumber ?? 1,
                      );
                      _addTransaction(transaction);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddBalanceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Tambah Saldo Minggu Baru'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Saldo Awal',
              prefixText: 'Rp ',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _startNewWeek(double.parse(controller.text));
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
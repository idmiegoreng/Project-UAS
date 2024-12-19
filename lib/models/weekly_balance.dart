import 'transaction.dart';

class WeeklyBalance {
  final int weekNumber;
  final double initialBalance;
  final DateTime startDate;
  final List<Transaction> transactions;

  WeeklyBalance({
    required this.weekNumber,
    required this.initialBalance,
    required this.startDate,
    List<Transaction>? transactions,
  }) : transactions = transactions ?? [];

  // Calculate current balance by subtracting expenses
  double get currentBalance {
    double balance = initialBalance;
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  // Calculate total expenses for the week
  double get totalExpenses {
    return transactions.fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Get formatted date range for the week
  String get weekLabel {
    final endDate = startDate.add(const Duration(days: 6));
    final startFormatted = '${startDate.day}/${startDate.month}';
    final endFormatted = '${endDate.day}/${endDate.month}';
    return '$startFormatted - $endFormatted';
  }

  // Create a copy of WeeklyBalance with modified fields
  WeeklyBalance copyWith({
    int? weekNumber,
    double? initialBalance,
    DateTime? startDate,
    List<Transaction>? transactions,
  }) {
    return WeeklyBalance(
      weekNumber: weekNumber ?? this.weekNumber,
      initialBalance: initialBalance ?? this.initialBalance,
      startDate: startDate ?? this.startDate,
      transactions: transactions ?? this.transactions,
    );
  }

  @override
  String toString() {
    return 'WeeklyBalance(weekNumber: $weekNumber, initialBalance: $initialBalance, startDate: $startDate, transactionCount: ${transactions.length})';
  }
}
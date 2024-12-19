enum TransactionType {
  income,
  expense,
}

class Transaction {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String note;
  final TransactionType type;
  final int weekNumber;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
    required this.type,
    required this.weekNumber,
  });

  // Convert Transaction to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'type': type.toString(),
      'weekNumber': weekNumber,
    };
  }

  // Create Transaction from Map (for storage retrieval)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      note: map['note'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => TransactionType.expense,
      ),
      weekNumber: map['weekNumber'],
    );
  }

  // Create a copy of Transaction with modified fields
  Transaction copyWith({
    String? id,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
    TransactionType? type,
    int? weekNumber,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      type: type ?? this.type,
      weekNumber: weekNumber ?? this.weekNumber,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, amount: $amount, category: $category, date: $date, type: $type, weekNumber: $weekNumber)';
  }
}

// List of predefined categories
class TransactionCategories {
  static const List<String> expenseCategories = [
    'Makanan',
    'Transport',
    'Hiburan',
    'Belanja',
    'Pendidikan',
    'Kesehatan',
    'Lainnya',
  ];
}
class Transaction {
  final String id;
  final double amount;
  final String category;
  final DateTime date;
  final String description;
  final TransactionType type;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
    );
  }
}

enum TransactionType { income, expense }
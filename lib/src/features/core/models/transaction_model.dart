class Transaction {
  final int id;
  final int userId;
  final double amount;
  final String description;
  final String category;
  final String transactionType; // 'expense' or 'income'
  final String? notes;
  final DateTime expenseDate;
  final int? receiptId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.transactionType,
    this.notes,
    required this.expenseDate,
    this.receiptId,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create Transaction from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      transactionType: json['transaction_type'] ?? 'expense',
      notes: json['notes'],
      expenseDate: DateTime.parse(json['expense_date']),
      receiptId: json['receipt_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Method to convert Transaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'description': description,
      'category': category,
      'transaction_type': transactionType,
      'notes': notes,
      'expense_date': expenseDate.toIso8601String(),
      'receipt_id': receiptId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // Method to create a copy of Transaction with updated fields
  Transaction copyWith({
    int? id,
    int? userId,
    double? amount,
    String? description,
    String? category,
    String? transactionType,
    String? notes,
    DateTime? expenseDate,
    int? receiptId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      category: category ?? this.category,
      transactionType: transactionType ?? this.transactionType,
      notes: notes ?? this.notes,
      expenseDate: expenseDate ?? this.expenseDate,
      receiptId: receiptId ?? this.receiptId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isExpense => transactionType.toLowerCase() == 'expense';
  bool get isIncome => transactionType.toLowerCase() == 'income';

  // Format amount with currency
  String formatAmount(String currencyCode) {
    return '$currencyCode ${amount.toStringAsFixed(2)}';
  }

  // Get formatted date
  String get formattedDate {
    return '${expenseDate.day}/${expenseDate.month}/${expenseDate.year}';
  }

  // Get formatted time
  String get formattedTime {
    return '${expenseDate.hour.toString().padLeft(2, '0')}:${expenseDate.minute.toString().padLeft(2, '0')}';
  }

  // Get formatted datetime
  String get formattedDateTime {
    return '$formattedDate at $formattedTime';
  }

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, description: $description, category: $category, transactionType: $transactionType, expenseDate: $expenseDate}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Transaction &&
        other.id == id &&
        other.userId == userId &&
        other.amount == amount &&
        other.description == description &&
        other.category == category &&
        other.transactionType == transactionType &&
        other.notes == notes &&
        other.expenseDate == expenseDate &&
        other.receiptId == receiptId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userId,
      amount,
      description,
      category,
      transactionType,
      notes,
      expenseDate,
      receiptId,
    );
  }
}

// Model for creating new transactions
class TransactionCreate {
  final double amount;
  final String description;
  final String category;
  final String transactionType;
  final String? notes;
  final DateTime expenseDate;

  TransactionCreate({
    required this.amount,
    required this.description,
    required this.category,
    this.transactionType = 'expense',
    this.notes,
    required this.expenseDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'description': description,
      'category': category,
      'transaction_type': transactionType,
      'notes': notes,
      'expense_date': expenseDate.toIso8601String(),
    };
  }
}

// Model for updating transactions
class TransactionUpdate {
  final double? amount;
  final String? description;
  final String? category;
  final String? transactionType;
  final String? notes;
  final DateTime? expenseDate;

  TransactionUpdate({
    this.amount,
    this.description,
    this.category,
    this.transactionType,
    this.notes,
    this.expenseDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (amount != null) data['amount'] = amount;
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category;
    if (transactionType != null) data['transaction_type'] = transactionType;
    if (notes != null) data['notes'] = notes;
    if (expenseDate != null) data['expense_date'] = expenseDate!.toIso8601String();
    return data;
  }
}

// Category model
class CategoryInfo {
  final String name;
  final String displayName;
  final String icon;
  final String color;
  final String transactionType;

  CategoryInfo({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
    required this.transactionType,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      transactionType: json['transaction_type'] ?? 'expense',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'display_name': displayName,
      'icon': icon,
      'color': color,
      'transaction_type': transactionType,
    };
  }
}

// Categories response model
class CategoriesResponse {
  final List<CategoryInfo> expenseCategories;
  final List<CategoryInfo> incomeCategories;

  CategoriesResponse({
    required this.expenseCategories,
    required this.incomeCategories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) {
    return CategoriesResponse(
      expenseCategories: (json['expense_categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryInfo.fromJson(e))
          .toList(),
      incomeCategories: (json['income_categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryInfo.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'expense_categories': expenseCategories.map((e) => e.toJson()).toList(),
      'income_categories': incomeCategories.map((e) => e.toJson()).toList(),
    };
  }

  // Get all categories
  List<CategoryInfo> get allCategories => [...expenseCategories, ...incomeCategories];

  // Get categories by type
  List<CategoryInfo> getCategoriesByType(String type) {
    return type.toLowerCase() == 'expense' ? expenseCategories : incomeCategories;
  }
}

// Balance model
class Balance {
  final double totalIncome;
  final double totalExpenses;
  final double netBalance;
  final DateTime? startDate;
  final DateTime? endDate;

  Balance({
    required this.totalIncome,
    required this.totalExpenses,
    required this.netBalance,
    this.startDate,
    this.endDate,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      totalIncome: (json['total_income'] ?? 0.0).toDouble(),
      totalExpenses: (json['total_expenses'] ?? 0.0).toDouble(),
      netBalance: (json['net_balance'] ?? 0.0).toDouble(),
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_income': totalIncome,
      'total_expenses': totalExpenses,
      'net_balance': netBalance,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }

  // Helper methods
  bool get isPositive => netBalance >= 0;
  bool get isNegative => netBalance < 0;

  double get savingsRate {
    if (totalIncome == 0) return 0.0;
    return (netBalance / totalIncome) * 100;
  }

  double get expenseRatio {
    if (totalIncome == 0) return 0.0;
    return (totalExpenses / totalIncome) * 100;
  }
}
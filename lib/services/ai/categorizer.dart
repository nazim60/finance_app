import '../../models/transaction.dart';

class AICategorizer {
  static const List<String> categories = [
    'Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Health', 'Other'
  ];
  
  /// Predict category based on description (keyword matching for MVP)
  Future<String> predictCategory(String description) async {
    final lower = description.toLowerCase();
    if (lower.contains('uber') || lower.contains('taxi') || lower.contains('bus')) return 'Transport';
    if (lower.contains('restaurant') || lower.contains('food') || lower.contains('grocery')) return 'Food';
    if (lower.contains('amazon') || lower.contains('store') || lower.contains('mall')) return 'Shopping';
    if (lower.contains('netflix') || lower.contains('cinema') || lower.contains('movie')) return 'Entertainment';
    if (lower.contains('electric') || lower.contains('water') || lower.contains('bill')) return 'Bills';
    if (lower.contains('clinic') || lower.contains('pharmacy') || lower.contains('doctor')) return 'Health';
    return 'Other';
  }
  
  /// Basic spending insight (on-device)
  String getSpendingInsight(List<Transaction> transactions) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final thisMonthTxs = transactions.where((t) => 
      t.type == 'expense' && t.date.isAfter(startOfMonth)
    ).toList();
    
    double totalSpent = thisMonthTxs.fold(0, (sum, t) => sum + t.amount);
    int daysPassed = now.day;
    double avgPerDay = daysPassed > 0 ? totalSpent / daysPassed : 0;
    
    if (avgPerDay > 100) {
      return '⚠️ You’re spending ₹$avgPerDay per day. Consider reducing.';
    } else if (avgPerDay < 30) {
      return '✅ Great job! You’re keeping expenses low.';
    }
    return '📊 Your spending is balanced. Keep tracking!';
  }
}

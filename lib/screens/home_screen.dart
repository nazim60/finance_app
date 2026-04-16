import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../services/database/local_db.dart';
import '../services/ai/categorizer.dart';
import '../widgets/quick_add_button.dart';
import '../widgets/insight_card.dart';
import 'add_transaction_screen.dart';

final categorizerProvider = Provider((ref) => AICategorizer());
final localDbProvider = Provider((ref) => LocalDatabase());

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(localDbProvider);
    final transactions = db.getTransactions();
    final totalIncome = transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    final balance = totalIncome - totalExpense;
    
    final insight = ref.read(categorizerProvider).getSpendingInsight(transactions);
    
    return Scaffold(
      floatingActionButton: QuickAddButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddTransactionScreen(),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Balance', style: TextStyle(color: Colors.grey)),
              Text(
                '\$${balance.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _statCard('Income', totalIncome, Colors.green)),
                  SizedBox(width: 12),
                  Expanded(child: _statCard('Expense', totalExpense, Colors.red)),
                ],
              ),
              SizedBox(height: 24),
              InsightCard(insight: insight),
              SizedBox(height: 16),
              Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Expanded(
                child: transactions.isEmpty
                    ? Center(child: Text('No transactions yet. Tap + to add.'))
                    : ListView.builder(
                        itemCount: transactions.length > 5 ? 5 : transactions.length,
                        itemBuilder: (ctx, i) {
                          final t = transactions.reversed.toList()[i];
                          return ListTile(
                            leading: Icon(Icons.receipt, color: t.type == 'income' ? Colors.green : Colors.red),
                            title: Text(t.category),
                            subtitle: Text(DateFormat.yMMMd().format(t.date)),
                            trailing: Text('\$${t.amount}', style: TextStyle(fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _statCard(String label, double amount, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text('\$${amount.toStringAsFixed(2)}', style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction.dart';

class LocalDatabase {
  static const String transactionBox = 'transactions';
  
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TransactionAdapter());
    await Hive.openBox<Transaction>(transactionBox);
  }
  
  Box<Transaction> get txBox => Hive.box<Transaction>(transactionBox);
  
  Future<void> addTransaction(Transaction tx) async {
    await txBox.put(tx.id, tx);
  }
  
  List<Transaction> getTransactions({String? walletId}) {
    return txBox.values.where((tx) => 
      walletId == null ? tx.walletId == null : tx.walletId == walletId
    ).toList();
  }
  
  Future<void> deleteTransaction(String id) async {
    await txBox.delete(id);
  }
}

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final double amount;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final DateTime date;
  
  @HiveField(4)
  final String note;
  
  @HiveField(5)
  final String paymentMethod;
  
  @HiveField(6)
  final String type; // 'income' or 'expense'
  
  @HiveField(7)
  final String? walletId; // null for personal wallet
  
  @HiveField(8)
  final bool synced; // offline sync flag
  
  Transaction({
    String? id,
    required this.amount,
    required this.category,
    required this.date,
    this.note = '',
    this.paymentMethod = 'cash',
    this.type = 'expense',
    this.walletId,
    this.synced = false,
  }) : id = id ?? const Uuid().v4();
}

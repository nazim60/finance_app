import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/voice/voice_input.dart';
import '../services/ocr/receipt_scanner.dart';
import '../services/ai/categorizer.dart';
import '../services/database/local_db.dart';
import '../models/transaction.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = 'Food';
  String _type = 'expense';
  final VoiceInputService _voice = VoiceInputService();
  final ReceiptScanner _ocr = ReceiptScanner();
  
  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _ocr.dispose();
    super.dispose();
  }
  
  Future<void> _useVoice() async {
    final text = await _voice.listen();
    if (text != null && text.isNotEmpty) {
      _noteController.text = text;
      final categorizer = ref.read(categorizerProvider);
      final predicted = await categorizer.predictCategory(text);
      setState(() {
        _selectedCategory = predicted;
      });
    }
  }
  
  Future<void> _scanReceipt() async {
    final result = await _ocr.scanReceipt();
    if (result != null && result['amount'] != null) {
      _amountController.text = result['amount'].toString();
      _noteController.text = result['merchant'] ?? '';
    }
  }
  
  void _save() {
    if (_formKey.currentState!.validate()) {
      final tx = Transaction(
        amount: double.parse(_amountController.text),
        category: _selectedCategory,
        date: DateTime.now(),
        note: _noteController.text,
        type: _type,
      );
      ref.read(localDbProvider).addTransaction(tx);
      Navigator.pop(context);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Amount'),
                    validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid amount' : null,
                  ),
                ),
                IconButton(onPressed: _scanReceipt, icon: Icon(Icons.camera_alt)),
                IconButton(onPressed: _useVoice, icon: Icon(Icons.mic)),
              ],
            ),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: ['Food', 'Transport', 'Shopping', 'Entertainment', 'Bills', 'Health', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategory = v!),
            ),
            SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'expense', label: Text('Expense')),
                ButtonSegment(value: 'income', label: Text('Income')),
              ],
              selected: {_type},
              onSelectionChanged: (s) => setState(() => _type = s.first),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}

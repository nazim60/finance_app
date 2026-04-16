import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class ReceiptScanner {
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  Future<Map<String, dynamic>?> scanReceipt() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    
    final inputImage = InputImage.fromFile(File(image.path));
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    
    String fullText = recognizedText.text;
    double? amount = _extractAmount(fullText);
    String? merchant = _extractMerchant(fullText);
    DateTime? date = _extractDate(fullText);
    
    return {
      'amount': amount,
      'merchant': merchant,
      'date': date,
      'rawText': fullText,
    };
  }
  
  double? _extractAmount(String text) {
    final regex = RegExp(r'(\d+\.\d{2})');
    final match = regex.firstMatch(text);
    if (match != null) return double.tryParse(match.group(1)!);
    return null;
  }
  
  String? _extractMerchant(String text) {
    final lines = text.split('\n');
    if (lines.isNotEmpty) return lines[0].trim();
    return null;
  }
  
  DateTime? _extractDate(String text) {
    final regex = RegExp(r'(\d{2}/\d{2}/\d{4})');
    final match = regex.firstMatch(text);
    if (match != null) {
      try {
        return DateTime.parse(match.group(1)!.split('/').reversed.join('-'));
      } catch (_) {}
    }
    return null;
  }
  
  void dispose() {
    _textRecognizer.close();
  }
}

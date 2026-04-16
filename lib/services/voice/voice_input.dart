import 'package:speech_to_text/speech_to_text.dart';

class VoiceInputService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  
  Future<bool> initialize() async {
    return await _speech.initialize();
  }
  
  Future<String?> listen() async {
    if (!_isListening) {
      bool available = await initialize();
      if (!available) return null;
      
      _isListening = true;
      String? result;
      
      await _speech.listen(
        onResult: (val) {
          result = val.recognizedWords;
          _speech.stop();
          _isListening = false;
        },
      );
      
      // Wait for result (user stops speaking automatically)
      await Future.delayed(Duration(seconds: 5));
      return result;
    }
    return null;
  }
  
  void stop() {
    _speech.stop();
    _isListening = false;
  }
}

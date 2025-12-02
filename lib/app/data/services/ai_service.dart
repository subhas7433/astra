import 'dart:math';
import '../interfaces/ai_service_interface.dart';

class AIService implements IAIService {
  final Random _random = Random();

  Future<String> generateResponse(String message, String astrologerName) async {
    // Simulate network/thinking delay (1.5 to 3 seconds)
    final delay = 1500 + _random.nextInt(1500);
    await Future.delayed(Duration(milliseconds: delay));

    final lowerMsg = message.toLowerCase();

    if (lowerMsg.contains('love') || lowerMsg.contains('relationship') || lowerMsg.contains('marriage')) {
      return _getRandomTemplate(_loveTemplates, astrologerName);
    } else if (lowerMsg.contains('career') || lowerMsg.contains('job') || lowerMsg.contains('business') || lowerMsg.contains('money')) {
      return _getRandomTemplate(_careerTemplates, astrologerName);
    } else if (lowerMsg.contains('health') || lowerMsg.contains('wellness')) {
      return _getRandomTemplate(_healthTemplates, astrologerName);
    } else if (lowerMsg.contains('hello') || lowerMsg.contains('hi') || lowerMsg.contains('namaste')) {
      return _getRandomTemplate(_greetingTemplates, astrologerName);
    } else {
      return _getRandomTemplate(_genericTemplates, astrologerName);
    }
  }

  String _getRandomTemplate(List<String> templates, String name) {
    return templates[_random.nextInt(templates.length)].replaceAll('{name}', name);
  }

  static const List<String> _loveTemplates = [
    "Venus is shining brightly in your chart. A new romantic connection is on the horizon.",
    "Relationships require patience right now. Focus on self-love and the right person will come.",
    "I see a strong emotional bond forming. Trust your intuition in matters of the heart.",
    "The stars suggest a time of harmony in your relationships. Communication is key.",
  ];

  static const List<String> _careerTemplates = [
    "Your hard work is about to pay off. A promotion or new opportunity is near.",
    "Saturn's influence suggests discipline is needed. Stay focused on your long-term goals.",
    "Financial stability is improving. It's a good time to plan for future investments.",
    "A change in your career path might bring the fulfillment you seek.",
  ];

  static const List<String> _healthTemplates = [
    "Prioritize rest and hydration. Your energy levels need replenishing.",
    "A balanced diet and meditation will do wonders for your well-being right now.",
    "Mars indicates high energy, but be careful not to burn out.",
    "Listen to your body. It knows what it needs to heal.",
  ];

  static const List<String> _greetingTemplates = [
    "Namaste! I am {name}. How can I guide you today?",
    "Hello! The stars have aligned for us to meet. What is on your mind?",
    "Greetings. I sense you have questions about your destiny.",
    "Welcome. I am here to help you navigate life's challenges.",
  ];

  static const List<String> _genericTemplates = [
    "That is an interesting question. Let me look deeper into your chart.",
    "The planetary alignments are complex. Can you provide more details?",
    "I sense a shift in your energy. Trust the process.",
    "Everything happens for a reason. The universe has a plan for you.",
    "Focus on the present moment. The future is built on today's actions.",
  ];
}

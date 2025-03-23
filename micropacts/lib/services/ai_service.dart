import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pact_model.dart';
import 'ai_service_interface.dart';

/// Implementation of the AIServiceInterface using OpenAI API
class AIService implements AIServiceInterface {
  final String _apiKey;
  final http.Client _client;
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _model = 'gpt-3.5-turbo';
  
  /// Constructor
  AIService(this._apiKey, [http.Client? client]) : _client = client ?? http.Client();
  
  @override
  Future<List<String>> generatePactSuggestions(List<Pact> pastPacts) async {
    try {
      final response = await _client.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that creates self-reflection-based experiments for intentional living. You follow the PACT framework (Purposeful, Actionable, Continuous, Trackable).'
            },
            {
              'role': 'user',
              'content': 'Here are my past experiments: ${_formatPactsForPrompt(pastPacts)}. Suggest 3 new experiments I could try next. Format each suggestion as a single paragraph.'
            },
          ],
          'temperature': 0.7,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'].trim();
        
        // Parse the content into separate suggestions
        return _parseSuggestions(content);
      } else {
        throw Exception('Failed to fetch AI suggestion: ${response.body}');
      }
    } catch (e) {
      // Return fallback suggestions if API call fails
      return [
        "Try meditating for 5 minutes each morning to start your day with clarity and focus.",
        "Write down three things you're grateful for before bed to cultivate a positive mindset.",
        "Take a 10-minute walk during your lunch break to boost your energy and creativity."
      ];
    }
  }
  
  @override
  Future<List<String>> generateReflectionPrompts(Pact pact) async {
    try {
      final response = await _client.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that creates thoughtful reflection prompts for personal experiments.'
            },
            {
              'role': 'user',
              'content': 'I just completed an experiment with the following details: Title: ${pact.title}, Purpose: ${pact.purpose}, Action: ${pact.action}. Generate 4 reflection prompts to help me learn from this experience.'
            },
          ],
          'temperature': 0.7,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'].trim();
        
        // Parse the content into separate prompts
        return _parseReflectionPrompts(content);
      } else {
        throw Exception('Failed to fetch reflection prompts: ${response.body}');
      }
    } catch (e) {
      // Return fallback prompts if API call fails
      return [
        "What did you learn about yourself while practicing ${pact.action}?",
        "How did this experiment affect your daily routine?",
        "What challenges did you face, and how did you overcome them?",
        "Would you continue this practice beyond the experiment period? Why or why not?"
      ];
    }
  }
  
  @override
  Future<Map<String, dynamic>> analyzePactPatterns(List<Pact> completedPacts) async {
    try {
      final response = await _client.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content': 'You are a helpful assistant that analyzes patterns in personal experiments and provides insights.'
            },
            {
              'role': 'user',
              'content': 'Here are my completed experiments: ${_formatPactsForPrompt(completedPacts)}. Analyze the patterns and provide insights in JSON format with the following structure: {"completionRate": number, "mostSuccessfulCategory": string, "recommendedDuration": number, "insights": [string, string, string]}'
            },
          ],
          'temperature': 0.7,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'].trim();
        
        // Extract JSON from the response
        final jsonMatch = RegExp(r'{.*}', dotAll: true).firstMatch(content);
        if (jsonMatch != null) {
          return jsonDecode(jsonMatch.group(0)!);
        } else {
          throw Exception('Failed to parse JSON from response');
        }
      } else {
        throw Exception('Failed to analyze patterns: ${response.body}');
      }
    } catch (e) {
      // Return fallback analysis if API call fails
      return {
        'completionRate': 75.5,
        'mostSuccessfulCategory': 'Morning routines',
        'recommendedDuration': 14,
        'insights': [
          'You tend to be more consistent with morning activities',
          'Shorter experiments (7-14 days) have higher completion rates',
          'Physical activities show better adherence than mental exercises'
        ]
      };
    }
  }
  
  /// Format pacts for the prompt
  String _formatPactsForPrompt(List<Pact> pacts) {
    if (pacts.isEmpty) {
      return "No past experiments available.";
    }
    
    return pacts.map((pact) => 
      "Title: ${pact.title}, Action: ${pact.action}, Purpose: ${pact.purpose}" +
      (pact.reflection != null ? ", Reflection: ${pact.reflection}" : "")
    ).join("; ");
  }
  
  /// Parse suggestions from the AI response
  List<String> _parseSuggestions(String content) {
    // Try to split by numbered list format (1. 2. 3.)
    final numberedRegex = RegExp(r'\d+\.\s+(.*?)(?=\d+\.|$)', dotAll: true);
    final numberedMatches = numberedRegex.allMatches(content);
    
    if (numberedMatches.isNotEmpty) {
      return numberedMatches
          .map((match) => match.group(1)!.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    
    // Fall back to paragraph splitting
    return content
        .split('\n\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }
  
  /// Parse reflection prompts from the AI response
  List<String> _parseReflectionPrompts(String content) {
    // Similar to _parseSuggestions
    return _parseSuggestions(content);
  }
  
  /// Close the http client
  void dispose() {
    _client.close();
  }
}

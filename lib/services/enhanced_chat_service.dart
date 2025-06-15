import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../services/cache_service.dart';

class EnhancedChatService {
  static const String apiKeyCacheKey = 'gemini_api_key';
  static const String conversationCacheKey = 'chat_conversation';

  static Future<String> sendMessage(String message) async {
    try {
      // Get API key (with caching)
      final apiKey = await _getApiKey();

      // Use the direct HTTP request with proper error handling
      return await _sendMessageWithRetry(message, apiKey);
    } catch (e) {
      print('Exception in EnhancedChatService: $e');
      return 'Error occurred while processing your request. Please try again later.';
    }
  }

  static Future<String> _getApiKey() async {
    // Try to get key from cache first
    String? cachedKey = await CacheService.getData<String>(apiKeyCacheKey);

    if (cachedKey != null && cachedKey.isNotEmpty) {
      return cachedKey;
    }

    try {
      // Load API key from assets
      final apiKey = (await rootBundle.loadString('assets/apikey.txt')).trim();

      // Save to cache for future use
      await CacheService.saveData(apiKeyCacheKey, apiKey, expiration: CacheService.longCache);

      return apiKey;
    } catch (e) {
      throw Exception('Failed to load API key: $e');
    }
  }

  static Future<String> _sendMessageWithRetry(String message, String apiKey, {int retryCount = 0}) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';

    // Create instructions for the Moroccan restaurant assistant
    final instructions = """
You are an AI assistant for a Moroccan restaurant called 'Cuisine Marocaine'. 
Your role is to ONLY answer questions about:
1. Moroccan cuisine, dishes, ingredients, and cooking methods
2. Our restaurant's menu, services, and ambiance
3. Information about Moroccan culture as it relates to food

Important restrictions:
- If a user asks about anything unrelated to Moroccan cuisine or our restaurant, politely redirect them to ask about our food or services instead.
- Keep answers concise and friendly.
- Always respond in the same language the customer used (French or English, primarily).
- Never provide information about non-Moroccan dishes.
- Never discuss politics, religion, or controversial topics.
- Never provide recipes with precise measurements, only general descriptions.

Our popular dishes include: tajine, couscous, harira, mechoui, pastilla, rfissa, briouates, zaalouk, and traditional Moroccan desserts.
    """;

    // Combine instructions with user message
    final combinedMessage = instructions + "\n\nCustomer message: " + message;

    final payload = {
      "contents": [
        {
          "parts": [
            {
              "text": combinedMessage
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.2,
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 1024
      }
    };

    try {
      // Enhanced for mobile by setting proper timeout and headers
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'User-Agent': 'CuisineMarocaineApp/1.0',
        },
        body: jsonEncode(payload),
      ).timeout(const Duration(seconds: 15)); // Add explicit timeout

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String botMessage = '';
        try {
          // Extract the response text from Gemini API structure
          botMessage = jsonResponse['candidates'][0]['content']['parts'][0]['text'];
        } catch (e) {
          // Fallback extraction method
          if (jsonResponse.containsKey('text')) {
            botMessage = jsonResponse['text'];
          } else {
            throw Exception('Unexpected API response structure');
          }
        }
        return botMessage;
      } else {
        // Handle rate limiting with retries
        if (response.statusCode == 429 && retryCount < 2) {
          await Future.delayed(Duration(seconds: 2 * (retryCount + 1)));
          return _sendMessageWithRetry(message, apiKey, retryCount: retryCount + 1);
        }

        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        return "Je ne peux pas vous répondre actuellement car il semble y avoir un problème de connexion. Veuillez vérifier votre connexion internet et réessayer.";
      }
      throw e;
    }
  }
}

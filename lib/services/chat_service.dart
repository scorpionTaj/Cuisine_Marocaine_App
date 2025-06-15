import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class ChatService {
  static Future<String> sendMessage(String message) async {
    try {
      // Load API key from assets
      final apiKey = (await rootBundle.loadString('apikey.txt')).trim();

      // Use the direct HTTP request for all platforms
      return await _sendMessageNative(message, apiKey);
    } catch (e) {
      print('Exception in ChatService: $e');
      return 'Error occurred while processing your request. Please try again later.';
    }
  }

  static Future<String> _sendMessageNative(String message, String apiKey) async {
    // Updated to use the correct Gemini API endpoint as shown in the curl example
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

    print('Sending request to API: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Access the response according to the new API structure
        final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
        return reply ?? 'No response';
      } else {
        print('ChatService error: ${response.statusCode}, body: ${response.body}');
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
      return 'Error communicating with the Gemini API: $e';
    }
  }
}

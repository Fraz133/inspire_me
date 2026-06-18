import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiProvider {
  static const String _baseUrl = 'https://zenquotes.io/api';

  Future<QuoteModel?> fetchRandomQuote() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/random'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final quoteData = data[0];
          return QuoteModel(
            id: 'api_${DateTime.now().millisecondsSinceEpoch}',
            text: quoteData['q'] ?? '',
            author: quoteData['a'] ?? 'Unknown',
          );
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<QuoteModel>> fetchMultipleQuotes() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/quotes'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          return QuoteModel(
            id: 'api_${item['q'].hashCode}',
            text: item['q'] ?? '',
            author: item['a'] ?? 'Unknown',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

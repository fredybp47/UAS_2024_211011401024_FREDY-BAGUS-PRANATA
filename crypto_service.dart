import 'dart:convert';

import 'package:http/http.dart' as http;

class CryptoService {
  final String baseUrl = 'https://api.coinlore.net/api/tickers/';

  Future<List<dynamic>> getCryptoData() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load crypto data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

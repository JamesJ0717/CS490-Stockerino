import 'package:http/http.dart' as http;
import 'dart:convert';

class StockAPI {
  Future<String> connectToAPI() {
    return http.get(Uri.encodeFull('http://localhost:3000'), headers: {
      "Accept": "application/json"
    }).then((response) => json.decode(response.body));
  }
}

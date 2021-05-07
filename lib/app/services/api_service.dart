import 'dart:convert';

import 'api.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService(this.api);
  final API api;

  Future<String> getAccessToken() async {
    final response = await http.post(
      Uri.parse(
        api.tokenUri().toString(),
      ),
      headers: {'Authorization': 'Basic ${api.apiKey}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['accessToken'];
      if (accessToken != null) {
        return accessToken;
      }
    }
    throw response;
  }
}

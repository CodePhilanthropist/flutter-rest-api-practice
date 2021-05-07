import 'dart:convert';

import 'package:flutter/foundation.dart';

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
    print(
        'Request: ${api.tokenUri()} failed\n Reponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<int> getEndpointData({
    @required String accessToken,
    @required EndPoint endpoint,
  }) async {
    final uri = api.endpointUri(endpoint);
    final response = await http.get(
      Uri.parse(
        uri.toString(),
      ),
      headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonKey = _reponseJsonKeys[endpoint];
        final int result = endpointData[responseJsonKey];
        if (result != null) {
          return result;
        }
      }
    }
    print(
        'Request: $uri failed\n Reponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Map<EndPoint, String> _reponseJsonKeys = {
    EndPoint.cases: 'cases',
    EndPoint.casesSuspected: 'casesSuspected',
    EndPoint.casesConfirmed: 'casesConfirmed',
    EndPoint.deaths: 'deaths',
    EndPoint.recovered: 'recovered',
  };
}

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
  }
}

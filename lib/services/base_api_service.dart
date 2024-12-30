import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:picturesourcesomerset/config/api_endpoints.dart';

class BaseApiService {
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String? _cachedToken;

  BaseApiService() : baseUrl = ApiEndpoints.baseUrl;

  /*Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = false}) async {
    final headers = await getHeaders(requiresAuth);
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
    return _processResponse(response);
  }*/
  
	Future<Map<String, dynamic>> get(String endpoint, {String? id, bool requiresAuth = false}) async {
		final headers = await getHeaders(requiresAuth);
		final url = id != null ? '$baseUrl/$endpoint/$id' : '$baseUrl/$endpoint';
		final response = await http.get(Uri.parse(url), headers: headers);
		return _processResponse(response);
	}



  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data, {bool requiresAuth = false}) async {
    final headers = await getHeaders(requiresAuth);
    final response = await http.post(Uri.parse('$baseUrl/$endpoint'), headers: headers, body: jsonEncode(data));
    return _processResponse(response);
  }
  Future<Map<String, String>> getHeaders(bool requiresAuth) async {
    final headers = {'Content-Type': 'application/json'};
    if (requiresAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Future<String?> getToken() async {
    // Retrieve token from secure storage
    //return await _secureStorage.read(key: 'token');
	
	if (_cachedToken == null) {
      _cachedToken = await _secureStorage.read(key: 'token');
    }
    return _cachedToken;
  }
  
  String? getTokenSync() {
    return _cachedToken;
    //return null;;
  }

  void saveToken(String token) async {	
    // Save token to secure storage
    await _secureStorage.write(key: 'token', value: token);
	_cachedToken = token;
  }
  
  void clearToken() async {
    _cachedToken = null;
    await _secureStorage.delete(key: 'token');
	
	print("Logout token=======:");
	//Get.toNamed(Routes.LOGIN_SCREEN);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

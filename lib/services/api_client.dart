import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/config.dart';
import 'package:myportofolio_mobile/models/project.dart';

/// Dilempar ketika API membalas dengan status di luar 2xx.
class ApiException implements Exception {
  const ApiException(this.statusCode, this.message);

  final int statusCode;
  final String message;
  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Klien HTTP untuk REST API Django MyPortfolio.
class ApiClient {
  ApiClient({http.Client? client, this.baseUrl = apiBaseUrl}) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  /// Header bersama. Kuncinya string biasa, bukan `HttpHeaders` dari
  /// `dart:io`, supaya aplikasi tetap bisa di-build untuk Flutter Web.
  Map<String, String> _headers({String? token, bool hasBody = false}) => {
    'Accept': 'application/json',
    if (hasBody) 'Content-Type': 'application/json; charset=UTF-8',
    if (token != null) 'Authorization': 'Token $token',
  };

  /// GET /api/v1/projects/ (publik, tanpa token).
  Future<List<Project>> getProjects() async {
    final response = await _client.get(_uri('/api/v1/projects/'), headers: _headers());
    _ensureSuccess(response);
    final decoded = _decode(response) as List<dynamic>;
    return decoded.map((item) => Project.fromJson(item as Map<String, dynamic>)).toList();
  }

  /// POST /api/v1/projects/. Backend hanya mengizinkan owner.
  Future<Project> createProject(Project project, {required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/projects/'),
      headers: _headers(token: token, hasBody: true),
      body: jsonEncode(project.toJson()),
    );
    _ensureSuccess(response);
    return Project.fromJson(_decode(response) as Map<String, dynamic>);
  }

  /// POST /api/v1/auth/token/. Mengembalikan token untuk header Authorization.
  Future<String> obtainToken(String username, String password) async {
    final response = await _client.post(
      _uri('/api/v1/auth/token/'),
      headers: _headers(hasBody: true),
      body: jsonEncode({'username': username, 'password': password}),
    );
    _ensureSuccess(response);
    final decoded = _decode(response) as Map<String, dynamic>;
    return decoded['token'] as String;
  }

  /// POST /api/v1/auth/logout/. Server menghapus token, jadi token itu
  /// langsung ditolak (401) kalau dipakai lagi.
  Future<void> logout({required String token}) async {
    final response = await _client.post(
      _uri('/api/v1/auth/logout/'),
      headers: _headers(token: token),
    );
    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }
    throw ApiException(response.statusCode, _bodyText(response));
  }

  /// DRF tidak menulis charset di header Content-Type, sehingga
  /// `response.body` bisa salah membaca huruf non-ASCII. Karena itu byte-nya
  /// didekode sebagai UTF-8 secara eksplisit.
  String _bodyText(http.Response response) => utf8.decode(response.bodyBytes, allowMalformed: true);

  Object? _decode(http.Response response) => jsonDecode(_bodyText(response));
}

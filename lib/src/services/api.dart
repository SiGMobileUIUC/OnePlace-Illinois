import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exception.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class ApiService extends IOClient {
  static final _loginUri =
      Uri.https(Config.baseEndpoint!, '/api/v1/user/login');

  FirebaseAuthService _firebaseAuth;
  String? _refreshToken;
  String? _accessToken;

  ApiService({required firebaseAuth}) : this._firebaseAuth = firebaseAuth;

  @override
  Future<IOStreamedResponse> send(BaseRequest request) async {
    if (_refreshToken == null || _accessToken == null) {
      throw ApiException(
          'Login must be called before making API requests, and it must have returned a valid reponse');
    }

    request.headers.addAll({
      'Authorization': _accessToken!,
      'Authorization-Refresh': _refreshToken!,
    });

    return super.send(request);
  }

  Future<void> login() async {
    var user = await _firebaseAuth.userStream.first;

    Response response = await get(_loginUri, headers: {
      'Authorization': await user!.getIdToken(),
    });

    var cookies = response.headers['set-cookie']!;
    _refreshToken = cookies.split('=')[1];
    _accessToken = jsonDecode(response.body)['payload']['accessToken'];
  }
}

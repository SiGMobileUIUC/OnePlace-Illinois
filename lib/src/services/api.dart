import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:oneplace_illinois/src/misc/config.dart';
import 'package:oneplace_illinois/src/misc/exceptions.dart';
import 'package:oneplace_illinois/src/services/firebaseAuth.dart';

class ApiService extends IOClient {
  static final _loginUri = Uri.http(Config.baseEndpoint!, '/api/v1/user/login');
  static const _refreshCookieName = 'refresh_jwt';

  FirebaseAuthService _firebaseAuth;
  String? _refreshToken;
  String? _accessToken;

  ApiService({required firebaseAuth}) : this._firebaseAuth = firebaseAuth;

  @override
  Future<IOStreamedResponse> send(BaseRequest request) async {
    if (_refreshToken == null || _accessToken == null) {
      await _login();
    }

    request.headers.addAll({
      'Authorization': 'Bearer ${_accessToken!}',
      'Cookie': '$_refreshCookieName=${_refreshToken!}',
    });

    return super.send(request);
  }

  Future<void> _login() async {
    var user = await _firebaseAuth.userStream.first;
    Response response = await post(_loginUri, body: {
      'email': user!.email,
      'token': await user.getIdToken(),
    });

    var cookies = response.headers['set-cookie']!;
    _refreshToken = cookies.split(';')[0].split('=')[1];
    _accessToken = jsonDecode(response.body)['payload']['accessToken'];
  }
}

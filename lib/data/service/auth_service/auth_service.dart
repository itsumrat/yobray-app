import 'package:dio/dio.dart';
import 'package:yo_bray/ulits/urls.dart';

class AuthService {
  Dio httpClient = Dio();

  Future<Response> signIn(String email, String password) async {
    final _body = {'email': email, 'password': password};
    return httpClient.post(Urls.signIn, data: _body);
  }

  Future<Response> socialAuth(Map body) async {
    return httpClient.post(Urls.socialAUth, data: body);
  }

  Future<Response> signUp(String name, String email, String password) async {
    final _body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
    };
    return httpClient.post(Urls.signUp, data: _body);
  }

  Future<Response> changePassword(
      String pass, String currentPassword, Map<String, String> header) async {
    final _body = {
      'password': pass,
      'password_confirmation': pass,
      'current_password': currentPassword,
    };
    return httpClient.post(
      Urls.passwordChange,
      data: _body,
      options: Options(
        headers: header,
        method: 'post',
        responseType: ResponseType.json,
      ),
    );
  }

  Future<Response> getProfile(Map<String, String> header, int id) async {
    return httpClient.get(
      Urls.baseUrl + '/user/$id/show',
      options: Options(
        headers: header,
        method: 'post',
        responseType: ResponseType.json,
      ),
    );
  }

  Future<Response> contactUs(
      Map<String, String> header, Map<String, dynamic> body) async {
    return httpClient.post(
      Urls.contactUs,
      data: body,
      options: Options(
        headers: header,
        method: 'post',
        responseType: ResponseType.json,
      ),
    );
  }

  Future<Response> doPaidUser(
      Map<String, String> header, Map<String, dynamic> body) async {
    return httpClient.post(
      Urls.doPaindUser,
      data: body,
      options: Options(
        headers: header,
        method: 'post',
        responseType: ResponseType.json,
      ),
    );
  }
}

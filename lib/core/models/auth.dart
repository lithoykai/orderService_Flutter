import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:orders_project/core/models/employee.dart';
import 'package:orders_project/core/services/employee_services.dart';
import 'package:orders_project/utils/constants.dart';

import '../../data/store.dart';
import '../../exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> signupEmployee(
    Map<String, dynamic> data,
  ) async {
    final String _employeeID;
    const _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Constants.TOKEN}';
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': data['email'],
        'password': data['password'],
        'returnSecureToken': true,
      }),
    );
    print('Usuário criado no Authentication');
    final body = jsonDecode(response.body);
    // print(data);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _employeeID = body['localId'];
      print('userID criado: $_employeeID');
      Employee newEmployee =
          Employee.fromJson(data, UniqueKey().toString(), _employeeID);
      print('Usuário de nome: ${newEmployee.name}');
      await EmployeeServices(_token ?? '').addDataInFirebase(newEmployee);
    }
  }

  Future<void> _authenticate(
      String email, String password, String fragmentUrl) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$fragmentUrl?key=${Constants.TOKEN}';
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    final body = jsonDecode(response.body);
    // print(data);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryToken': _expiryDate!.toIso8601String()
      });

      autoLogout();
      notifyListeners();
    }
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiryToken']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;
    clearLogoutTimer();
    Store.remove('userData').then((_) => notifyListeners());
  }

  void clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  Future<void> autoLogout() async {
    clearLogoutTimer();
    final _timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(
        seconds: _timeToLogout ?? 0,
      ),
      logout,
    );
  }
}

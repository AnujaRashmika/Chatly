import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {

  final AuthService _authService = AuthService();

  AuthService get authService => _authService;

}
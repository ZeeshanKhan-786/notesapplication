import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:notesapp/services/auth_services.dart';

class AuthProvider extends ChangeNotifier{
  final AuthService _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  String? errorMessage;

  void toggleMode(){
    isLogin = !isLogin;
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> submit(String email, String password) async{
    if(email.trim().isEmpty || password.isEmpty){
      errorMessage = 'Email & Password are Mandatory';
      notifyListeners();
      return false;
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      if(isLogin){
        await _authService.signIn(email.trim(), password);
      }else{
        await _authService.signUp(email.trim(), password);
      }
      return true;
    } catch(e){
      errorMessage = _getErrorMessage(e);
      return false;
    } finally{
      isLoading = false;
      notifyListeners();
    }
  }

  String _getErrorMessage(Object error){
    final message = error.toString();

    if(message.contains('invalid-credential')||
        message.contains('wrong-password')||
        message.contains('user-not-found')){
      return 'Incorrect Email or Password';
    }

    if(message.contains('email-already-in-use')){
      return 'Email already registered';
    }

    if(message.contains('weak-password')){
      return 'Password at least 6 character';
    }

    return 'Authentication failed, try again!';
  }

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
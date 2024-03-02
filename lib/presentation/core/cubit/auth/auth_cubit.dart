import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turni/core/config/service_locator.dart';
import 'package:turni/domain/entities/user.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';
import 'package:turni/domain/usercases/auth_user_cases.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with ChangeNotifier {

  final AuthUserCases authUserCases;

  AuthCubit(this.authUserCases) : super(const AuthInitial());

  void checkAuthStatus() {

    emit(const AuthNotLogged());
    notifyListeners();

  }

  Future signInGoogle() async {
    notifyListeners();
  }

  void signOutGoogle() async {

    emit(const AuthNotLogged());
    notifyListeners();
  }

  /// Funcion donde recibimos los datos de google de un usuario luego de logearse.
  void googleCallback(GoogleSignInUserData userData) async {

    final user = User.fromGoogleSignInUserData(userData);

    authUserCases.login(user);

    emit(AuthLogged(userCredential: user));

    notifyListeners();

  }

  bool getLoadingStatus() {
    return state.loadingAuthentication;
  }

  bool isAdmin(){
    return state.userCredential?.isAdmin() ?? true;
  }
}

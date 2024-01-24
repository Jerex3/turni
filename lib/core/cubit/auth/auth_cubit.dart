import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:turni/data/repositories/auth_repository.dart';
import 'package:turni/domain/models/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with ChangeNotifier {

  final authRepository = AuthRepository();

  AuthCubit() : super(const AuthInitial());


  void checkAuthStatus() {
/*     final user = FirebaseAuth.instance.currentUser;

    if(user == null){
      emit(const AuthNotLogged());
    }

    emit(AuthLogged(userCredential: user ));
 */    
    emit(AuthLogged(userCredential: User("givenName", "familyName", "email", "picture", "accessToken")));
    notifyListeners();
  }

  Future signInGoogle() async {
/*     UserCredential? userCred = await authRepository.signInGoogle();
  
    if(userCred == null) return;

    emit(AuthLogged(userCredential: userCred.user));
 */
    notifyListeners();
  }

  void signOutGoogle() async {
    
/*       await GoogleSignIn(
        clientId: kIsWeb ? "336678963982-6jcv4q55kckarab2ke8otrsos1kih8j0.apps.googleusercontent.com" : null
      ).signOut();
      await FirebaseAuth.instance.signOut();
      sl.resetLazySingleton(
        instance: sl<FeedCubit>()
      );
      emit(const AuthNotLogged());
 */      notifyListeners();
  }

  bool getLoadingStatus(){
    
    return state.loadingAuthentication;
  }
}

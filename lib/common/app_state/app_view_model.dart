import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mental_care_chat_demo/common/app_state/app_state.dart';
import 'package:mental_care_chat_demo/domain/domain_model/user_model.dart';

class AppViewModel extends Notifier<AppState> {
  @override
  AppState build() => AppState();

  void setLoginUser({required UserModel? user}){
    state = state.copyWith(user: user);
  }
}

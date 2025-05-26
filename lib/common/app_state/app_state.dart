import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mental_care_chat_demo/domain/domain_model/user_model.dart';
part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  final UserModel? user;

  const AppState({this.user});
}

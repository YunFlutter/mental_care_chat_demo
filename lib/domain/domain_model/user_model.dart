import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._(); // 커스텀 getter 용

  const factory UserModel({
    required String uid,
    required String email,
    required String birthDate,
    required int age,
    required int lastCesdScore,

    @JsonKey(
      includeIfNull: true,
      fromJson: TimestampNullableConverter.fromJson,
      toJson: TimestampNullableConverter.toJson,
    )
    DateTime? lastCesdDate,

    @JsonKey(
      includeIfNull: true,
      fromJson: TimestampNullableConverter.fromJson,
      toJson: TimestampNullableConverter.toJson,
    )
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// 첫 검사 여부
  bool get isFirstTest => lastCesdDate == null;
}

// 기존 TimestampConverter는 유지
class TimestampConverter {
  static DateTime fromJson(Timestamp? timestamp) =>
      timestamp?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0);

  static Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

// 👇 null 허용 변환기 추가
class TimestampNullableConverter {
  static DateTime? fromJson(Timestamp? timestamp) =>
      timestamp?.toDate();

  static Timestamp? toJson(DateTime? date) =>
      date == null ? null : Timestamp.fromDate(date);
}
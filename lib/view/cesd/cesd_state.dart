import 'package:freezed_annotation/freezed_annotation.dart';

part 'cesd_state.freezed.dart';



@freezed
abstract class CesdState with _$CesdState {
  const factory CesdState({
    required List<int?> answers,
    required List<String> questions,
    required List<String> options,
  }) = _CesdState;

  factory CesdState.initial() => CesdState(
    answers: List.filled(20, null),
    questions: [
      '평소에는 아무렇지도 않던 일들이 괴롭고 귀찮게 느껴졌다.',
      '먹고 싶지 않았다. 식욕이 없었다.',
      '어느 누가 도와주더라도 나의 울적한 기분을 떨쳐버릴 수 없을 것 같았다.',
      '무슨 일을 하든 정신을 집중하기가 힘들었다.',
      '비교적 잘 지냈다.',
      '상당히 우울했다.',
      '모든 일들이 힘들게 느껴졌다.',
      '앞일이 암담하게 느껴졌다.',
      '지금까지의 내 인생은 실패작이라는 생각이 들었다.',
      '적어도 보통 사람들 만큼의 능력은 있었다고 생각한다.',
      '잠을 설쳤다 (잠을 잘 이루지 못 했다).',
      '두려움을 느꼈다.',
      '평소에 비해 말수가 적었다.',
      '세상에 홀로 있는 듯한 외로움을 느꼈다.',
      '큰 불만 없이 생활했다.',
      '사람들이 나에게 차갑게 대하는 것 같았다.',
      '갑자기 울음이 나왔다.',
      '마음이 슬펐다.',
      '사람들이 나를 싫어하는 것 같았다.',
      '도무지 뭘 해 나갈 엄두가 나지 않았다.',
    ],
    options: [
      '극히 드물다 (1일 이하)',
      '가끔 (1~2일)',
      '자주 (3~4일)',
      '거의 대부분 (5~7일)',
    ],
  );
}
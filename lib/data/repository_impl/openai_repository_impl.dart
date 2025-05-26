import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mental_care_chat_demo/domain/repository/openai_repository.dart';

class OpenAiRepositoryImpl implements OpenAiRepository {
  static const _apiUrl = 'https://api.openai.com/v1/chat/completions';
  final _apiKey = dotenv.env['OPENAI_API_KEY'];

  @override
  Future<String> analyzeCesdResult({
    required List<String> questions,
    required List<int> answers,
    required List<String> options,
    required int age
  }) async {
    try {
      final prompt = _buildReportPrompt(questions, answers, options,age);

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 700,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('💡데이터 : $data');
        return data['choices'][0]['message']['content'];
      } else {
        print('❌ OpenAI 응답 실패: ${response.body}');
        return 'AI 분석 실패 (code: ${response.statusCode})';
      }
    } catch (e) {
      print('❌ OpenAI API 호출 예외: $e');
      return '분석 중 오류가 발생했습니다. 나중에 다시 시도해주세요.';
    }
  }

  String _buildReportPrompt(
    List<String> questions,
    List<int> answers,
    List<String> options,
      int age
  ) {
    final buffer = StringBuffer();

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      final answerText = options[answers[i]];
      buffer.writeln('Q${i + 1}. $question\nA. $answerText\n');
    }

    return '''
너는 따뜻하고 공감 능력이 뛰어난 정신건강 상담사야.

다음은 한 $age세의 사용자의 CES-D(우울증 자가검사) 응답이야.  
이 응답을 분석해서 아래 항목들을 JSON 형태로 정리해줘.

반드시 영어 키로 구성되고 값은 한국어로 구성된 **Flutter 에서 변환 할수 있는 JSON 형식으로만** 응답해줘. 설명이나 다른 문장은 붙이지 마.

### ✅ JSON에 포함해야 할 항목:

1. "emotion_scores": 감정별 0~10점 점수 (숫자가 높을수록 해당 감정이 강함)
   - sadness  
   - anxiety  
   - helplessness  
   - loneliness  
   - hope  

2. "status_summary": 사용자의 현재 감정 상태를 1~2문장으로 요약

3. "advice": 감정을 어떻게 다루면 좋을지에 대한 짧은 조언

4. "recommended_activities": 오늘 사용자가 시도해볼 수 있는 매번 다른 간단한 활동 2~4개 (예: 산책, 명상, 글쓰기 등)

### ✅ 예시 형식:
{
  "emotion_scores": {
    "sadness": 6,
    "anxiety": 4,
    "helplessness": 7,
    "loneliness": 5,
    "hope": 3
  },
  "status_summary": "당신은 최근 정서적으로 지치고 의욕이 저하된 상태일 수 있어요.",
  "advice": "감정을 억누르지 말고 천천히 받아들이며, 자신에게 더 관대해지세요.",
  "recommended_activities": [
    "가벼운 산책하기",
    "조용한 음악 듣기",
    "감정 일기 쓰기"
  ]
}

아래는 사용자의 응답이야:
${buffer.toString()}
''';
  }
}

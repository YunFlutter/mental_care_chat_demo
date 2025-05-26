abstract class OpenAiRepository {
  Future<String> analyzeCesdResult({
    required List<String> questions,
    required List<int> answers,
    required List<String> options,
    required int age
  });
}
abstract class CesdRepository {
  Future<String?> saveCesdResultOnly({
    required int score,
    required List<int> answers,
  });

  Future<bool> updateAiAnalysis({
    required String resultId,
    required String aiAnalysis,
  });
}
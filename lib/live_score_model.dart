class LiveScoreModel {
  final String title;
  final String team1;
  final String team2;
  final int team1_score;
  final int team2_score;
  final String winnerTeam;
  final bool isRunning;

  LiveScoreModel({
    required this.title,
    required this.team1,
    required this.team2,
    required this.team1_score,
    required this.team2_score,
    required this.winnerTeam,
    required this.isRunning,
  });

  factory LiveScoreModel.fromJson(String docId,Map<String, dynamic> jsonData){
    return LiveScoreModel(
        title: docId,
        team1: jsonData["team1"] ?? '',
        team2: jsonData["team2"] ?? '',
        team1_score: jsonData["team1_score"] ?? 0,
        team2_score: jsonData["team2_score"] ?? 0,
        winnerTeam: jsonData["winner_team"] ?? '',
        isRunning: jsonData["isRunning"] ?? false
    );
  }
}

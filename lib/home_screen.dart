import 'package:flutter/material.dart';
import 'package:intro_firebase/live_score_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<LiveScoreModel> _scoreList = [];
  final FirebaseFirestore db = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Future<void> _getLiveScoreList() async {
  //   _scoreList.clear();
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   final QuerySnapshot snapshot = await db.collection('football').get();
  //   for (QueryDocumentSnapshot doc in snapshot.docs) {
  //     LiveScoreModel liveScoreModel = LiveScoreModel.fromJson(
  //       doc.id,
  //       doc.data() as Map<String, dynamic>,
  //     );
  //     _scoreList.add(liveScoreModel);
  //   }
  //   _isLoading = false;
  //   setState(() {});
  // }
  //
  // @override
  // void initState() {
  //   _getLiveScoreList();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Visibility(
          visible: _isLoading == false,
          replacement: Center(child: CircularProgressIndicator()),
          child: StreamBuilder(
            stream: db.collection('football').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (snapshot.hasData == false) {
                return const SizedBox.shrink();
              }
              _scoreList.clear();
              for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
                LiveScoreModel liveScoreModel = LiveScoreModel.fromJson(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                );
                _scoreList.add(liveScoreModel);
              }
              return ListView.builder(
                itemCount: _scoreList.length,
                itemBuilder: (context, index) {
                  LiveScoreModel liveScoreModel = _scoreList[index];
                  return ListTile(
                    title: Text(liveScoreModel.title),
                    trailing: Text(
                      "${liveScoreModel.team1_score}:${liveScoreModel.team2_score}",
                    ),
                    leading:
                        liveScoreModel.isRunning
                            ? CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 8,
                            )
                            : CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 8,
                            ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Team 1: ${liveScoreModel.team1}"),
                        Text("Team 2: ${liveScoreModel.team2}"),
                        Text("Winner Team: ${liveScoreModel.winnerTeam}"),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

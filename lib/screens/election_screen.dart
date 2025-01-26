import 'dart:ui';

import 'package:club_management_and_information_system/api/api_client.dart';
import 'package:club_management_and_information_system/model/election_results_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../model/candidate_model.dart';
import '../model/voter_exist_model.dart';
import '../shared_preference.dart';

class ElectionScreen extends StatefulWidget {
  @override
  _ElectionScreenState createState() => _ElectionScreenState();
}

class _ElectionScreenState extends State<ElectionScreen> {
  final PageController _controller = PageController();

  final List<Map<String, dynamic>> candidates = [
    {
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
      'name': 'John \n(ELECTED PRESIDENT)',
      'position': 'President',
      'votes': 75,
      'bio':
          'John has a strong background in leadership and community service, with a proven track record of organizing successful events.',
      'manifesto':
          'Focus on transparency, innovation, and inclusivity to create a better community for everyone.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
      'name': 'Jane Smith',
      'position': 'Vice President',
      'votes': 5,
      'bio':
          'Jane is passionate about fostering teamwork and empowering others to achieve their goals.',
      'manifesto':
          'Advocate for equal opportunities and provide support for new initiatives in the community.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
      'name': 'Alex Johnson',
      'position': 'General Secretary',
      'votes': 50,
      'bio':
          'Alex is experienced in managing logistics and ensuring smooth communication between different teams.',
      'manifesto':
          'Prioritize efficient management and improved communication channels for everyone.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
      'name': 'Emily Davis',
      'position': 'Treasurer',
      'votes': 25,
      'bio':
          'Emily has a strong financial acumen and is skilled in budgeting and resource allocation.',
      'manifesto':
          'Ensure transparency in financial matters and optimize resources for maximum benefit.',
    },
    {
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
      'name': 'Michael Brown',
      'position': 'Cultural Secretary',
      'votes': 69,
      'bio':
          'Michael is a creative thinker and a strong advocate for promoting cultural diversity.',
      'manifesto':
          'Encourage cultural events and celebrate the diversity of our community.',
    },
  ];


  Future<List<CandidateModel>?> getCandidates(String api, BuildContext context) async {
    return await ApiClient().getCandidatesForVoting(api, context);
  }

  Future<List<ElectionResultsModel>?> getResults(int id, BuildContext context) async {
    return await ApiClient().getElectionResults(id, context);
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Confirm Your Vote'),
          content: Text('Are you sure you want to vote for this candidate?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff154973), Color(0xff0f65a5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Election',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon:
                    Icon(Icons.arrow_back, color: Colors.transparent),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
          height: 650,
          child: Center(
            child: FutureBuilder<String>(
              future: ApiClient().fetchLatestElectionStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  String status = snapshot.data!;
                  switch (status) {
                    case 'No Elections':
                      return Center(
                          child: Card(
                            color: Colors.white,
                            elevation: 8.0,
                            child: Lottie.asset('animation/noData.json',
                                height: MediaQuery.of(context).size.height / 3),
                          )
                      );
                    case 'Election Upcoming':
                      return Center(
                        child: Card(
                          color: Colors.white,
                          elevation: 8.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Election Upcoming', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold, fontSize: 24),),
                              Lottie.asset(
                                'animation/electionScreen.json',
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                            ],
                          ),
                        ),
                      );
                    case 'Show Candidate':
                      return FutureBuilder<List<CandidateModel>?>(
                        future: getCandidates('?clubId=${SharedPrefs.getInt('club_id')}',context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(
                              color: Colors.white,
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Center(
                              child: Text(
                                'No data available.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                          final List<CandidateModel> candidates = snapshot.data!;
                          return Column(
                            children: [
                              Expanded(
                                child: PageView.builder(
                                  controller: _controller,
                                  itemCount: candidates.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10.0, right: 16.0,),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('Vote to Elect President', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold, fontSize: 28),),

                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(16),
                                                child: Image.network(
                                                  candidates[index].candidateProfilePic!,
                                                  height: 200,
                                                  width: 250,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                candidates[index].candidateName!,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                candidates[index].candidateUserId!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                              const SizedBox(height: 20),
                                              FutureBuilder<CheckVoterExists?>(
                                                future: ApiClient().getCheckVoterExists("?voterId=${SharedPrefs.getString('id')}&electionId=${candidates[index].electionId!}", context),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return Center(child: CircularProgressIndicator());
                                                  } else if (snapshot.hasError) {
                                                    return Center(child: Text('Error: ${snapshot.error}'));
                                                  } else if (snapshot.hasData) {
                                                    final exists = snapshot.data?.exists ?? false;
                                                    if (exists) {
                                                      return Center(child: Text('You have already given your vote.\nKindly wait for the Results',textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 20),));
                                                    } else {
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          bool? userConfirmed = await _showConfirmationDialog(context);
                                                          if (userConfirmed == true) {
                                                            var payload = {
                                                              "election_id": candidates[index].electionId!,
                                                              "candidate_id": candidates[index].candidateId!,
                                                              "vote_date": DateTime.now().toUtc().toIso8601String(),
                                                              "voter_id": "${SharedPrefs.getString('id')}",
                                                            };
                                                            print(payload);
                                                            await ApiClient().postVote(payload, context);
                                                            setState(() {
                                                            });
                                                          } else {
                                                            // User canceled, handle accordingly
                                                            print('User canceled the vote.');
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: 150,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(30),
                                                            gradient: LinearGradient(
                                                              colors: [Color(0xff154973), Color(0xff0f65a5)],
                                                            ),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Vote',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );

                                                    }
                                                  } else {
                                                    return Center(child: Text('No data available'));
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 15),
                              SmoothPageIndicator(
                                controller: _controller,
                                count: candidates.length,
                                effect: const WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.black26,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    case 'Processing Election':
                      return Center(
                        child: Card(
                          color: Colors.white,
                          elevation: 8.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Election Processing', style: TextStyle(color: Color(0xff154973), fontWeight: FontWeight.bold, fontSize: 24),),
                              Lottie.asset(
                                'animation/electionScreen.json',
                                height: MediaQuery.of(context).size.height / 3,
                              ),
                            ],
                          ),
                        ),
                      );
                    case 'Show Results':
                      return FutureBuilder<List<ElectionResultsModel>?>(
                        future: getResults(SharedPrefs.getInt('club_id')!, context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Center(
                              child: Text(
                                'No data available.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          final List<ElectionResultsModel> candidates = snapshot.data!;
                          ElectionResultsModel? electedCandidate = candidates.isEmpty
                              ? null
                              : candidates.reduce((curr, next) =>
                          (curr.votePercentage ?? 0) > (next.votePercentage ?? 0) ? curr : next);

                          return Container(
                            height: MediaQuery.of(context).size.height / 3,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.2),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0, right: 15, left: 15),
                                          child: Center(
                                            child: Text(
                                              'Election Results',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: candidates.length,
                                            itemBuilder: (context, index) {
                                              final candidate = candidates[index];
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 10.0, horizontal: 16.0),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundImage: NetworkImage(
                                                          candidates[index].candidateProfilePic!),
                                                      radius: 25,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              if (candidate == electedCandidate)
                                                                Text(' (Elected President)',
                                                                  style: TextStyle(
                                                                    color: Colors.green.shade500,
                                                                    fontSize: 17,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              Text(
                                                                '${candidate.candidateName}',
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                height: 20,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey.withOpacity(0.3),
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 20,
                                                                width: MediaQuery.of(context).size.width *
                                                                    0.6 *
                                                                    (candidate.votePercentage! / 100),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '${candidate.votePercentage!}%',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );

                    default:
                      return Center(child: Text('Unknown Status'));
                  }
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ),
        )
        ],
          )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

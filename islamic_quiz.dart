// lib/screens/quiz/islamic_quiz.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class IslamicQuizPage extends StatefulWidget {
  const IslamicQuizPage({super.key});

  @override
  State<IslamicQuizPage> createState() => _IslamicQuizPageState();
}

class _IslamicQuizPageState extends State<IslamicQuizPage> {
  int _currentQuestion = 0;
  int _score = 0;
  bool _quizCompleted = false;
  List<Map<String, dynamic>> _selectedQuestions = [];

  final List<Map<String, dynamic>> _allQuestions = [
    {
      'question': 'How many pillars of Islam are there?',
      'options': ['4', '5', '6', '7'],
      'correct': 1,
      'explanation': 'There are 5 pillars: Shahada, Salah, Zakat, Sawm, Hajj',
    },
    {
      'question': 'Which Surah is called "The Heart of the Quran"?',
      'options': ['Al-Fatiha', 'Al-Baqarah', 'Yasin', 'Al-Ikhlas'],
      'correct': 2,
      'explanation': 'Surah Yasin is often called the heart of the Quran',
    },
    {
      'question': 'How many times a day do Muslims pray?',
      'options': ['3', '4', '5', '6'],
      'correct': 2,
      'explanation': 'Muslims pray 5 times daily: Fajr, Dhuhr, Asr, Maghrib, Isha',
    },
    {
      'question': 'What is the first month of the Islamic calendar?',
      'options': ['Ramadan', 'Muharram', 'Shawwal', 'Dhul-Hijjah'],
      'correct': 1,
      'explanation': 'Muharram is the first month of the Islamic calendar',
    },
    {
      'question': 'Which angel delivered revelations to Prophet Muhammad (PBUH)?',
      'options': ['Jibreel (Gabriel)', 'Mika\'il (Michael)', 'Israfil', 'Izra\'il'],
      'correct': 0,
      'explanation': 'Angel Jibreel (Gabriel) delivered the Quranic revelations',
    },
    {
      'question': 'How many days is Ramadan?',
      'options': ['28', '29 or 30', '31', '40'],
      'correct': 1,
      'explanation': 'Ramadan is either 29 or 30 days, depending on the moon sighting',
    },
    {
      'question': 'What is the night of power called in Arabic?',
      'options': ['Laylat al-Mi\'raj', 'Laylat al-Qadr', 'Laylat al-Bara\'ah', 'Laylat al-Jumu\'ah'],
      'correct': 1,
      'explanation': 'Laylat al-Qadr (Night of Power) is better than 1000 months',
    },
    {
      'question': 'Which direction do Muslims face during prayer?',
      'options': ['East', 'West', 'Towards Kaaba', 'North'],
      'correct': 2,
      'explanation': 'Muslims face the Kaaba in Makkah during prayers',
    },
    {
      'question': 'What is the annual charity called in Islam?',
      'options': ['Sadaqah', 'Zakat', 'Khumus', 'Fidyah'],
      'correct': 1,
      'explanation': 'Zakat is the obligatory annual charity (2.5% of savings)',
    },
    {
      'question': 'How many verses are in Surah Al-Fatiha?',
      'options': ['5', '6', '7', '8'],
      'correct': 2,
      'explanation': 'Surah Al-Fatiha has 7 verses and is recited in every prayer',
    },
    {
      'question': 'What is the fasting before Eid al-Fitr called?',
      'options': ['Nafl Fast', 'Sunnah Fast', 'Ramadan Fast', 'Shawwal Fast'],
      'correct': 2,
      'explanation': 'Fasting during Ramadan is obligatory for every adult Muslim',
    },
    {
      'question': 'Which Prophet is mentioned the most in the Quran?',
      'options': ['Prophet Ibrahim', 'Prophet Musa', 'Prophet Isa', 'Prophet Muhammad'],
      'correct': 1,
      'explanation': 'Prophet Musa (Moses) is mentioned 136 times in the Quran',
    },
    {
      'question': 'What is the minimum amount for Zakat?',
      'options': ['Nisab', 'Mithqal', 'Qirat', 'Dirham'],
      'correct': 0,
      'explanation': 'Nisab is the minimum amount of wealth one must have before Zakat is due',
    },
    {
      'question': 'How many Rakats in Fajr prayer?',
      'options': ['2', '3', '4', '5'],
      'correct': 0,
      'explanation': 'Fajr prayer consists of 2 Rakats (units of prayer)',
    },
    {
      'question': 'What is the Islamic declaration of faith?',
      'options': ['Takbir', 'Tasbih', 'Shahada', 'Tahmid'],
      'correct': 2,
      'explanation': 'Shahada: "La ilaha illallah, Muhammadur rasulullah"',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    // Shuffle questions and pick 10 random ones
    final random = _allQuestions.toList()..shuffle();
    _selectedQuestions = random.take(10).toList();
  }

  Future<void> _saveQuizScore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('quizResults')
          .add({
        'score': _score,
        'totalQuestions': _selectedQuestions.length,
        'percentage': (_score / _selectedQuestions.length * 100).round(),
        'date': DateTime.now(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving quiz score: $e');
    }
  }

  void _answerQuestion(int selectedIndex) {
    if (selectedIndex == _selectedQuestions[_currentQuestion]['correct']) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestion < _selectedQuestions.length - 1) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
      _saveQuizScore();
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    final percentage = (_score / _selectedQuestions.length * 100).round();
    String message = '';
    Color color = Colors.green;

    if (percentage >= 90) {
      message = 'Excellent! MashaAllah! Your knowledge is impressive!';
      color = Colors.green;
    } else if (percentage >= 70) {
      message = 'Very Good! Keep learning and growing in your deen!';
      color = Colors.blue;
    } else if (percentage >= 50) {
      message = 'Good effort! There\'s always more to learn in Islam!';
      color = Colors.orange;
    } else {
      message = 'Keep learning! Every bit of Islamic knowledge is valuable!';
      color = Colors.red;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your score: $_score/${_selectedQuestions.length}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '($percentage%)',
              style: TextStyle(fontSize: 18, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            if (_selectedQuestions[_currentQuestion].containsKey('explanation'))
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Did you know: ${_selectedQuestions[_currentQuestion]['explanation']}',
                  style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartQuiz();
            },
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF074C4C),
            ),
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestion = 0;
      _score = 0;
      _quizCompleted = false;
      _initializeQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQ = _selectedQuestions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _selectedQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Quiz'),
        backgroundColor: const Color(0xFF074C4C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartQuiz,
            tooltip: 'Restart Quiz',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress
            Text(
              'Question ${_currentQuestion + 1}/${_selectedQuestions.length}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFFC39F47),
            ),
            const SizedBox(height: 30),

            // Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF074C4C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Score: $_score',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF074C4C),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC39F47).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}% Complete',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC39F47),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Question
            Text(
              currentQ['question'],
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 30),

            // Options
            ...List.generate(
              currentQ['options'].length,
                  (index) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF074C4C),
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFF074C4C)),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF074C4C).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF074C4C),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          currentQ['options'][index],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Next button
            if (!_quizCompleted && _currentQuestion < _selectedQuestions.length - 1)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentQuestion++;
                    });
                  },
                  icon: const Icon(Icons.skip_next),
                  label: const Text('Skip Question'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
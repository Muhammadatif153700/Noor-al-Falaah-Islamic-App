// lib/screens/habits/habit_tracker.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HabitTracker extends StatefulWidget {
  const HabitTracker({super.key});

  @override
  State<HabitTracker> createState() => _HabitTrackerState();
}

class _HabitTrackerState extends State<HabitTracker> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  final List<Map<String, dynamic>> _defaultHabits = [
    {'id': 'fajr', 'name': 'Fajr Prayer', 'emoji': '🌅', 'color': Colors.blue, 'completed': false},
    {'id': 'dhuhr', 'name': 'Dhuhr Prayer', 'emoji': '☀️', 'color': Colors.orange, 'completed': false},
    {'id': 'asr', 'name': 'Asr Prayer', 'emoji': '⛅', 'color': Colors.amber, 'completed': false},
    {'id': 'maghrib', 'name': 'Maghrib Prayer', 'emoji': '🌇', 'color': Colors.purple, 'completed': false},
    {'id': 'isha', 'name': 'Isha Prayer', 'emoji': '🌙', 'color': Colors.indigo, 'completed': false},
    {'id': 'quran', 'name': 'Quran Reading', 'emoji': '📖', 'color': Colors.green, 'completed': false},
    {'id': 'dhikr', 'name': 'Dhikr Remembrance', 'emoji': '📿', 'color': Colors.teal, 'completed': false},
    {'id': 'charity', 'name': 'Daily Charity', 'emoji': '🤲', 'color': Colors.red, 'completed': false},
  ];

  List<Map<String, dynamic>> _habits = [];
  int _completedCount = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    if (_user == null) {
      setState(() {
        _habits = List.from(_defaultHabits);
        _updateProgress();
      });
      return;
    }

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('habits')
          .doc(todayStr)
          .get();

      if (doc.exists && doc.data() != null) {
        setState(() {
          _habits = List<Map<String, dynamic>>.from(doc.data()!['habits'] ?? _defaultHabits);
          _updateProgress();
        });
      } else {
        setState(() {
          _habits = List.from(_defaultHabits);
        });
        await _saveHabits();
      }
    } catch (e) {
      print('Error loading habits: $e');
      setState(() {
        _habits = List.from(_defaultHabits);
        _updateProgress();
      });
    }
  }

  Future<void> _saveHabits() async {
    if (_user == null) return;

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    try {
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('habits')
          .doc(todayStr)
          .set({
        'date': todayStr,
        'habits': _habits,
        'completed': _completedCount,
        'progress': _progress,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving habits: $e');
    }
  }

  void _updateProgress() {
    final completed = _habits.where((h) => h['completed'] == true).length;
    setState(() {
      _completedCount = completed;
      _progress = _habits.isEmpty ? 0.0 : completed / _habits.length;
    });
  }

  Future<void> _toggleHabit(int index) async {
    setState(() {
      _habits[index]['completed'] = !_habits[index]['completed'];
      _updateProgress();
    });
    await _saveHabits();
  }

  void _addCustomHabit() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Habit Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  _habits.add({
                    'id': 'custom_${DateTime.now().millisecondsSinceEpoch}',
                    'name': controller.text.trim(),
                    'emoji': '➕',
                    'color': Colors.grey,
                    'completed': false,
                  });
                });
                _updateProgress();
                _saveHabits();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiritual Habits Tracker'),
        backgroundColor: const Color(0xFF074C4C),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: const Color(0xFF074C4C).withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('Today\'s Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircularProgressIndicator(
                            value: _progress,
                            strokeWidth: 10,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC39F47)),
                          ),
                        ),
                        Column(
                          children: [
                            Text('${(_progress * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                            Text('$_completedCount/${_habits.length}', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _completedCount == _habits.length ? 'Masha Allah! All habits completed! 🎉' : 'Keep going! Every good deed counts.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text('Your Spiritual Habits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF074C4C))),
            const SizedBox(height: 16),

            ..._habits.asMap().entries.map((entry) {
              final index = entry.key;
              final habit = entry.value;
              final Color habitColor = habit['color'] is Color ? habit['color'] : Colors.grey;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: habitColor.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: Text(habit['emoji'].toString(), style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(habit['name'].toString(), style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: habit['completed'] == true ? const Color(0xFF2E7D32) : const Color(0xFF333333),
                    decoration: habit['completed'] == true ? TextDecoration.lineThrough : TextDecoration.none,
                  )),
                  trailing: Switch(
                    value: habit['completed'] == true,
                    activeColor: const Color(0xFFC39F47),
                    onChanged: (_) => _toggleHabit(index),
                  ),
                  onTap: () => _toggleHabit(index),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _addCustomHabit,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Custom Habit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC39F47),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
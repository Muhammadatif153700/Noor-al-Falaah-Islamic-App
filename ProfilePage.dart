// lib/screens/ProfilePage.dart - UPDATED VERSION
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  Map<String, dynamic> _userStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    _user = _auth.currentUser;

    if (_user != null) {
      await _fetchUserStats();
    }

    setState(() => _isLoading = false);
  }

  // Helper function to format date without intl
  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // Helper function to parse date without intl
  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        final year = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final day = int.tryParse(parts[2]);
        if (year != null && month != null && day != null) {
          return DateTime(year, month, day);
        }
      }
    } catch (e) {
      print('Date parse error: $e');
    }
    return null;
  }

  Future<void> _fetchUserStats() async {
    if (_user == null) return;

    try {
      // Get habits for streak
      final habitsSnapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('habits')
          .get();

      // Calculate streak
      int streak = 0;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      // Get all dates with completed habits
      final completedDates = <DateTime>[];

      for (var doc in habitsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final dateStr = doc.id;
        final date = _parseDate(dateStr);

        if (date != null && _hasCompletedHabit(data)) {
          completedDates.add(date);
        }
      }

      // Sort dates
      completedDates.sort((a, b) => b.compareTo(a));

      // Calculate consecutive days
      if (completedDates.isNotEmpty) {
        DateTime currentDate = today;
        int currentStreak = 0;

        for (var completedDate in completedDates) {
          final normalizedDate = DateTime(completedDate.year, completedDate.month, completedDate.day);
          final diff = currentDate.difference(normalizedDate).inDays;

          if (diff == 0 || (currentStreak == 0 && diff <= 1)) {
            currentStreak++;
            currentDate = normalizedDate.subtract(const Duration(days: 1));
          } else if (diff == 1) {
            currentStreak++;
            currentDate = normalizedDate;
          } else {
            break;
          }
        }

        streak = currentStreak;
      }

      // Get goals
      final goalsSnapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('goals')
          .get();

      int completedGoals = goalsSnapshot.docs
          .where((doc) => (doc.data() as Map<String, dynamic>)['isCompleted'] == true)
          .length;

      // Get quiz score (if exists)
      int quizScore = 0;
      try {
        final quizSnapshot = await _firestore
            .collection('users')
            .doc(_user!.uid)
            .collection('quizResults')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (quizSnapshot.docs.isNotEmpty) {
          quizScore = (quizSnapshot.docs.first.data() as Map<String, dynamic>)['score'] ?? 0;
        }
      } catch (e) {
        // No quiz data yet
      }

      // Get saved ayats (if exists)
      int savedAyats = 0;
      try {
        final ayatsSnapshot = await _firestore
            .collection('users')
            .doc(_user!.uid)
            .collection('savedAyats')
            .get();

        savedAyats = ayatsSnapshot.docs.length;
      } catch (e) {
        // No saved ayats yet
      }

      setState(() {
        _userStats = {
          'dayStreak': streak,
          'goalsMet': completedGoals,
          'totalGoals': goalsSnapshot.docs.length,
          'quizScore': quizScore,
          'savedAyats': savedAyats,
        };
      });
    } catch (e) {
      print('Error fetching stats: $e');
      setState(() {
        _userStats = {
          'dayStreak': 0,
          'goalsMet': 0,
          'totalGoals': 0,
          'quizScore': 0,
          'savedAyats': 0,
        };
      });
    }
  }

  bool _hasCompletedHabit(Map<String, dynamic> data) {
    return data.entries.any((entry) {
      final key = entry.key;
      final value = entry.value;
      return key != 'date' && key != 'timestamp' && key != 'updatedAt' && value == true;
    });
  }

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('Please sign in'))
          : SingleChildScrollView(
        child: Column(
          children: [
            // User info card - WIDER GREEN SECTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32), // Increased padding
              decoration: const BoxDecoration(
                color: Color(0xFF074C4C),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30), // More rounded
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60, // Slightly larger
                    backgroundColor: Colors.white,
                    child: _user?.photoURL != null
                        ? ClipOval(
                      child: Image.network(
                        _user!.photoURL!,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    )
                        : Icon(Icons.person, size: 70, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _user?.displayName ?? 'User Name',
                    style: const TextStyle(
                      fontSize: 28, // Slightly larger
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _user?.email ?? 'user@example.com',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Member since ${_user?.metadata.creationTime?.year ?? '2024'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Stats - SMALLER CARDS
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12, // Reduced spacing
                mainAxisSpacing: 12,
                childAspectRatio: 0.9, // Makes cards more compact
                children: [
                  _buildStatCard('Day Streak', '${_userStats['dayStreak']}', Icons.local_fire_department, Colors.orange),
                  _buildStatCard('Goals Met', '${_userStats['goalsMet']}/${_userStats['totalGoals']}', Icons.flag, Colors.green),
                  _buildStatCard('Quiz Score', '${_userStats['quizScore']}', Icons.quiz, Colors.blue),
                  _buildStatCard('Saved Ayats', '${_userStats['savedAyats']}', Icons.bookmark, Colors.purple),
                ],
              ),
            ),

            // Menu
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.bookmark, color: Colors.purple),
                    title: const Text('Saved Ayats'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14), // Smaller arrow
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_userStats['savedAyats']} ayats saved')),
                      );
                    },
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.blue),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),

                  // DEVELOPED BY SECTION
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Developed By:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF074C4C),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Developer 1
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF074C4C).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 20,
                                color: Color(0xFF074C4C),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Abdul Haseeb',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '241899',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'swagger.haseeb999@gmail.com',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Developer 2
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC39F47).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 20,
                                color: Color(0xFFC39F47),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Muhammad Atif',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '241929',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'ati.here@gmail.com',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade700,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),
                        const Divider(height: 20),
                        const SizedBox(height: 8),

                        // App Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.code, size: 14, color: Colors.grey.shade600),
                            const SizedBox(width: 6),
                            const Text(
                              'Noor Al Falah v1.0',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0, indent: 16, endIndent: 16),

                  // Logout Button
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
                    onTap: _logout,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12), // Reduced padding for smaller cards
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color), // Smaller icon
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20, // Smaller font
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12, // Smaller font
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
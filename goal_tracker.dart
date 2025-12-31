// lib/screens/goals/goal_tracker.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoalTracker extends StatefulWidget {
  const GoalTracker({super.key});

  @override
  State<GoalTracker> createState() => _GoalTrackerState();
}

class _GoalTrackerState extends State<GoalTracker> {
  String _activeTab = 'daily';
  final TextEditingController _goalController = TextEditingController();
  final User? _user = FirebaseAuth.instance.currentUser;

  CollectionReference _getGoalsRef() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('goals');
  }

  void _addGoal() async {
    if (_goalController.text.isEmpty) return;

    final goalText = _goalController.text;
    _goalController.clear();
    Navigator.pop(context);

    await _getGoalsRef().add({
      'text': goalText,
      'isCompleted': false,
      'category': _activeTab,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  void _toggleGoal(String docId, bool currentStatus) {
    _getGoalsRef().doc(docId).update({'isCompleted': !currentStatus});
  }

  void _deleteGoal(String docId) {
    _getGoalsRef().doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Spiritual Goals", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF074C4C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Tab Selector
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF074C4C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: ['daily', 'weekly', 'monthly'].map((tab) {
                final isActive = _activeTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTab = tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF074C4C) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)] : [],
                      ),
                      child: Center(
                        child: Text(
                          tab.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.white : const Color(0xFF074C4C),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Goals List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getGoalsRef().orderBy('createdAt', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading goals"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter goals by category
                final docs = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['category'] == _activeTab;
                }).toList();

                if (docs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final docId = doc.id;

                    return _buildGoalCard(docId, data);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalSheet,
        backgroundColor: const Color(0xFFC39F47),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Goal", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildGoalCard(String id, Map<String, dynamic> data) {
    bool isDone = data['isCompleted'] ?? false;
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _deleteGoal(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: IconButton(
            icon: Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isDone ? const Color(0xFF2E7D32) : Colors.grey,
              size: 28,
            ),
            onPressed: () => _toggleGoal(id, isDone),
          ),
          title: Text(
            data['text'] ?? '',
            style: TextStyle(
              fontSize: 16,
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? Colors.grey : const Color(0xFF333333),
            ),
          ),
          subtitle: Text(
            '${data['category']} goal',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flag_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "No ${_activeTab} goals yet",
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add your first goal to get started",
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showAddGoalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "New Spiritual Goal",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "What do you want to achieve in your spiritual journey?",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _goalController,
              autofocus: true,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "e.g., Memorize Surah Al-Kahf, Read Quran daily, Give charity every Friday...",
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _addGoal(),
            ),
            const SizedBox(height: 20),
            // Category Selection
            Row(
              children: ['daily', 'weekly', 'monthly'].map((tab) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(tab.toUpperCase()),
                      selected: _activeTab == tab,
                      selectedColor: const Color(0xFF074C4C),
                      labelStyle: TextStyle(
                        color: _activeTab == tab ? Colors.white : Colors.grey,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _activeTab = tab),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _addGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF074C4C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save Goal"),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
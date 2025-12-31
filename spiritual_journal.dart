// lib/screens/journal/spiritual_journal.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class SpiritualJournal extends StatefulWidget {
  const SpiritualJournal({super.key});

  @override
  State<SpiritualJournal> createState() => _SpiritualJournalState();
}

class _SpiritualJournalState extends State<SpiritualJournal> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _journalController = TextEditingController();
  List<JournalEntry> _entries = [];
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = true;

  // Sample prompt texts
  final List<String> _samplePrompts = [
    "How connected did I feel to Allah today?",
    "What good deeds did I perform today?",
    "What sins did I commit and how can I seek forgiveness?",
    "How did I control my anger or negative emotions?",
    "What Quran verses or duas did I recite today?",
    "What am I grateful for today?",
    "How did I help someone today?",
    "What spiritual lessons did I learn today?",
  ];

  @override
  void initState() {
    super.initState();
    // Set initial text with a sample prompt
    _journalController.text = _samplePrompts[DateTime.now().day % _samplePrompts.length];
    _loadEntries();
  }

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> _loadEntries() async {
    if (_userId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('journal')
          .orderBy('date', descending: true)
          .limit(20) // Load last 20 entries
          .get();

      setState(() {
        _entries = snapshot.docs.map((doc) {
          final data = doc.data();
          return JournalEntry(
            id: doc.id,
            content: data['content'] ?? '',
            date: data['date']?.toDate() ?? DateTime.now(),
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading journal: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveEntry() async {
    if (_journalController.text.trim().isEmpty || _userId.isEmpty) return;

    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('journal')
          .add({
        'content': _journalController.text.trim(),
        'date': DateTime.now(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _journalController.clear();
        // Set a new random prompt for the next entry
        final randomIndex = DateTime.now().second % _samplePrompts.length;
        _journalController.text = _samplePrompts[randomIndex];
      });

      // Reload entries to show the new one
      await _loadEntries();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Journal entry saved! ✨'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error saving journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearEntry() async {
    setState(() {
      _journalController.clear();
      final randomIndex = DateTime.now().second % _samplePrompts.length;
      _journalController.text = _samplePrompts[randomIndex];
    });
  }

  Future<void> _deleteEntry(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('journal')
          .doc(id)
          .delete();

      await _loadEntries();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Entry deleted'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error deleting entry: $e');
    }
  }

  void _viewEntry(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          DateFormat('MMM d, yyyy').format(entry.date),
          style: const TextStyle(color: Color(0xFF074C4C)),
        ),
        content: SingleChildScrollView(
          child: Text(
            entry.content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spiritual Journal'),
        backgroundColor: const Color(0xFF074C4C),
        foregroundColor: Colors.white,
        actions: [
          if (_entries.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear All Entries'),
                    content: const Text('Are you sure you want to delete all journal entries?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            // Delete all entries from Firestore
                            final batch = _firestore.batch();
                            final snapshot = await _firestore
                                .collection('users')
                                .doc(_userId)
                                .collection('journal')
                                .get();

                            for (final doc in snapshot.docs) {
                              batch.delete(doc.reference);
                            }

                            await batch.commit();
                            await _loadEntries();

                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('All entries cleared'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error clearing all entries: $e');
                          }
                        },
                        child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: Stack(
        children: [
          // Background image with opacity
          Opacity(
            opacity: 0.15,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1516557070061-deb6c56de0f5?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Content
          Column(
            children: [
              // Journal Writing Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Header
                          Row(
                            children: [
                              Icon(Icons.edit_note, color: Theme.of(context).primaryColor),
                              const SizedBox(width: 8),
                              Text(
                                'Reflect on Your Day',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat('EEE, MMM d').format(DateTime.now()),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Writing Prompt
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF074C4C).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF074C4C).withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.lightbulb_outline,
                                        color: Theme.of(context).colorScheme.secondary,
                                        size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Writing Prompt',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _journalController.text.isEmpty
                                      ? _samplePrompts[0]
                                      : _journalController.text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Journal Text Field
                          Expanded(
                            child: TextField(
                              controller: _journalController,
                              focusNode: _focusNode,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Start writing your reflections here...\n\nSome things to think about:\n• How conscious was I of Allah today?\n• What good deeds did I perform?\n• What could I have done better?\n• What am I grateful for?',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(fontSize: 16, height: 1.6),
                            ),
                          ),

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _clearEntry,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('New Prompt'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF074C4C),
                                    side: const BorderSide(color: Color(0xFF074C4C)),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _saveEntry,
                                  icon: const Icon(Icons.save),
                                  label: const Text('Save Entry'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF074C4C),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Saved Entries Section
              Container(
                height: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.history, color: Theme.of(context).primaryColor),
                        const SizedBox(width: 8),
                        const Text(
                          'Previous Entries',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_entries.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Entries List
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _entries.isEmpty
                          ? const Center(
                        child: Text(
                          'No entries yet\nStart writing your first reflection!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                          : ListView.builder(
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final entry = _entries[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF074C4C).withOpacity(0.1),
                                child: Text(
                                  DateFormat('d').format(entry.date),
                                  style: const TextStyle(
                                    color: Color(0xFF074C4C),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                entry.content.length > 80
                                    ? '${entry.content.substring(0, 80)}...'
                                    : entry.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                DateFormat('MMM d, yyyy • h:mm a').format(entry.date),
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility, size: 20),
                                    onPressed: () => _viewEntry(entry),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                                    onPressed: () => _deleteEntry(entry.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _entries.isEmpty ? null : FloatingActionButton(
        onPressed: () {
          // Scroll to top and focus on text field
          _focusNode.requestFocus();
        },
        backgroundColor: const Color(0xFFC39F47),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}

class JournalEntry {
  final String id;
  final String content;
  final DateTime date;

  JournalEntry({
    required this.id,
    required this.content,
    required this.date,
  });
}
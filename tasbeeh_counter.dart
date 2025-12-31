// lib/screens/tasbeeh_counter.dart - FINAL VERSION
import 'package:flutter/material.dart';

class TasbeehCounter extends StatefulWidget {
  const TasbeehCounter({super.key});

  @override
  State<TasbeehCounter> createState() => _TasbeehCounterState();
}

class _TasbeehCounterState extends State<TasbeehCounter> {
  int _count = 0;
  String _selectedTasbeeh = 'Subhanallah';

  final List<Map<String, dynamic>> _tasbeehat = [
    {
      'name': 'Subhanallah',
      'arabic': 'سُبْحَانَ ٱللَّٰهِ',
      'translation': 'Glory be to Allah',
      'target': 33,
      'benefits': [
        'Fills your scale with good deeds',
        'Removes sins like leaves fall from tree',
        'Light on Day of Judgment',
        'Plantation in Paradise'
      ]
    },
    {
      'name': 'Alhamdulillah',
      'arabic': 'ٱلْحَمْدُ لِلَّٰهِ',
      'translation': 'Praise be to Allah',
      'target': 33,
      'benefits': [
        'Complete expression of gratitude',
        'Increases blessings in life',
        'Protects from pride and arrogance',
        'Key to contentment'
      ]
    },
    {
      'name': 'Allahu Akbar',
      'arabic': 'ٱللَّٰهُ أَكْبَرُ',
      'translation': 'Allah is the Greatest',
      'target': 34,
      'benefits': [
        'Removes sins between two repetitions',
        'Protection from Hellfire',
        'Counts as charity for each joint',
        'Magnifies Allah in your heart'
      ]
    },
    {
      'name': 'La ilaha illallah',
      'arabic': 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ',
      'translation': 'There is no god but Allah',
      'target': 100,
      'benefits': [
        'Entry ticket to Paradise',
        'Protection from Hellfire',
        'Best form of remembrance',
        'Declaration of faith'
      ]
    },
    {
      'name': 'Astaghfirullah',
      'arabic': 'أَسْتَغْفِرُ ٱللَّٰهَ',
      'translation': 'I seek forgiveness from Allah',
      'target': 100,
      'benefits': [
        'Erases sins completely',
        'Opens doors of mercy',
        'Relieves stress and anxiety',
        'Brings sustenance from Allah'
      ]
    },
    {
      'name': 'Subhanallah wa bihamdihi',
      'arabic': 'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ',
      'translation': 'Glory and praise be to Allah',
      'target': 100,
      'benefits': [
        'Date palm planted in Paradise',
        'Erases sins of 10 years',
        'Most beloved phrase to Allah',
        'Light in the grave'
      ]
    },
    {
      'name': 'Subhanallahi wa bihamdihi Subhanallahil Adheem',
      'arabic': 'سُبْحَانَ ٱللَّٰهِ وَبِحَمْدِهِ سُبْحَانَ ٱللَّٰهِ ٱلْعَظِيمِ',
      'translation': 'Glory and praise be to Allah, Glory be to Allah the Almighty',
      'target': 100,
      'benefits': [
        'Weighs heavy on scale',
        'Easy way to earn rewards',
        'Protects from sins',
        'Peace in heart'
      ]
    },
  ];

  void _incrementCount() {
    setState(() {
      _count++;
      if (_count >= _getCurrentTarget()) {
        _count = 0;
      }
    });
  }

  void _resetCounter() {
    setState(() {
      _count = 0;
    });
  }

  int _getCurrentTarget() {
    final current = _tasbeehat.firstWhere(
          (t) => t['name'] == _selectedTasbeeh,
      orElse: () => _tasbeehat[0],
    );
    return current['target'];
  }

  Map<String, dynamic> _getCurrentTasbeeh() {
    return _tasbeehat.firstWhere(
          (t) => t['name'] == _selectedTasbeeh,
      orElse: () => _tasbeehat[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTasbeeh = _getCurrentTasbeeh();
    final target = _getCurrentTarget();
    final Color primaryColor = const Color(0xFF074C4C);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Tasbeeh'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Tasbeeh Selection
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tasbeehat.length,
                  itemBuilder: (context, index) {
                    final tasbeeh = _tasbeehat[index];
                    final isSelected = _selectedTasbeeh == tasbeeh['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTasbeeh = tasbeeh['name'];
                            _resetCounter();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? primaryColor : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? primaryColor : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            tasbeeh['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Arabic Text
            Text(
              currentTasbeeh['arabic'],
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Amiri',
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Translation
            Text(
              currentTasbeeh['translation'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 30),

            // Counter Circle
            GestureDetector(
              onTap: _incrementCount,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _count.toString(),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'of $target',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Progress Bar
            Container(
              width: 200,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _count / target,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementCount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('COUNT'),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: _resetCounter,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                  child: const Text('RESET'),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Benefits Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, size: 18, color: primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Benefits of ${currentTasbeeh['name']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...(currentTasbeeh['benefits'] as List<String>).map((benefit) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: primaryColor)),
                          Expanded(
                            child: Text(
                              benefit,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Simple Instructions
            Text(
              'Tip: Tap the circle to count. Automatically resets at target.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
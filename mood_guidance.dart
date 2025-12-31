// lib/screens/mood_guidance.dart - COMPLETE FILE
import 'package:flutter/material.dart';

class MoodGuidancePage extends StatefulWidget {
  const MoodGuidancePage({super.key});

  @override
  State<MoodGuidancePage> createState() => _MoodGuidancePageState();
}

class _MoodGuidancePageState extends State<MoodGuidancePage> {
  final List<MoodCategory> _moods = [
    MoodCategory(
      name: 'Anxiety & Worry',
      emoji: '😰',
      color: Colors.blue,
      ayahs: [
        MoodContent(
          text: '۞ أَلَا بِذِكْرِ ٱللَّهِ تَطْمَئِنُّ ٱلْقُلُوبُ',
          translation: '"Unquestionably, by the remembrance of Allah hearts are assured."',
          reference: 'Surah Ar-Ra\'d 13:28',
          type: ContentType.ayah,
        ),
        MoodContent(
          text: 'وَقَالَ رَبُّكُمُ ٱدْعُونِىٓ أَسْتَجِبْ لَكُمْ',
          translation: '"And your Lord says, \'Call upon Me; I will respond to you.\'"',
          reference: 'Surah Ghafir 40:60',
          type: ContentType.ayah,
        ),
        MoodContent(
          text: 'إِنَّ مَعَ ٱلْعُسْرِ يُسْرًا',
          translation: '"For indeed, with hardship [will be] ease."',
          reference: 'Surah Al-Inshirah 94:5',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Sadness & Grief',
      emoji: '😔',
      color: Colors.purple,
      ayahs: [
        MoodContent(
          text: 'وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنتُمُ ٱلْأَعْلَوْنَ إِن كُنتُم مُّؤْمِنِينَ',
          translation: '"So do not weaken and do not grieve, and you will be superior if you are [true] believers."',
          reference: 'Surah Al-Imran 3:139',
          type: ContentType.ayah,
        ),
        MoodContent(
          text: 'وَلَنَبْلُوَنَّكُم بِشَىْءٍۢ مِّنَ ٱلْخَوْفِ وَٱلْجُوعِ وَنَقْصٍۢ مِّنَ ٱلْأَمْوَٰلِ وَٱلْأَنفُسِ وَٱلثَّمَرَٰتِ ۗ وَبَشِّرِ ٱلصَّٰبِرِينَ',
          translation: '"And We will surely test you with something of fear and hunger and a loss of wealth and lives and fruits, but give good tidings to the patient."',
          reference: 'Surah Al-Baqarah 2:155',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Stress & Pressure',
      emoji: '😥',
      color: Colors.orange,
      ayahs: [
        MoodContent(
          text: 'فَإِنَّ مَعَ ٱلْعُسْرِ يُسْرًا إِنَّ مَعَ ٱلْعُسْرِ يُسْرًا',
          translation: '"For indeed, with hardship [will be] ease. Indeed, with hardship [will be] ease."',
          reference: 'Surah Al-Inshirah 94:5-6',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Joy & Gratitude',
      emoji: '😊',
      color: Colors.green,
      ayahs: [
        MoodContent(
          text: 'قُلْ بِفَضْلِ ٱللَّهِ وَبِرَحْمَتِهِۦ فَبِذَٰلِكَ فَلْيَفْرَحُوا۟ هُوَ خَيْرٌۭ مِّمَّا يَجْمَعُونَ',
          translation: '"Say, \'In the bounty of Allah and in His mercy - in that let them rejoice; it is better than what they accumulate.\'"',
          reference: 'Surah Yunus 10:58',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Anger & Frustration',
      emoji: '😠',
      color: Colors.red,
      ayahs: [
        MoodContent(
          text: 'وَٱلْكَٰظِمِينَ ٱلْغَيْظَ وَٱلْعَافِينَ عَنِ ٱلنَّاسِ ۗ وَٱللَّهُ يُحِبُّ ٱلْمُحْسِنِينَ',
          translation: '"And those who restrain anger and who pardon the people - and Allah loves the doers of good."',
          reference: 'Surah Al-Imran 3:134',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Fear & Insecurity',
      emoji: '😨',
      color: Colors.indigo,
      ayahs: [
        MoodContent(
          text: 'أَلَيْسَ ٱللَّهُ بِكَافٍ عَبْدَهُۥ ۖ وَيُخَوِّفُونَكَ بِٱلَّذِينَ مِن دُونِهِۦ',
          translation: '"Is not Allah sufficient for His servant? And they frighten you of those other than Him."',
          reference: 'Surah Az-Zumar 39:36',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Hope & Optimism',
      emoji: '🌟',
      color: Colors.amber,
      ayahs: [
        MoodContent(
          text: 'وَلَا تَا۟يْـَٔسُوا۟ مِن رَّوْحِ ٱللَّهِ ۖ إِنَّهُۥ لَا يَا۟يْـَٔسُ مِن رَّوْحِ ٱللَّهِ إِلَّا ٱلْقَوْمُ ٱلْكَٰفِرُونَ',
          translation: '"And do not lose hope in the mercy of Allah. Indeed, no one loses hope in the mercy of Allah except the disbelieving people."',
          reference: 'Surah Yusuf 12:87',
          type: ContentType.ayah,
        ),
      ],
    ),
    MoodCategory(
      name: 'Peace & Tranquility',
      emoji: '😌',
      color: Colors.teal,
      ayahs: [
        MoodContent(
          text: 'هُوَ ٱلَّذِىٓ أَنزَلَ ٱلسَّكِينَةَ فِى قُلُوبِ ٱلْمُؤْمِنِينَ لِيَزْدَادُوٓا۟ إِيمَٰنًۭا مَّعَ إِيمَٰنِهِمْ ۗ وَلِلَّهِ جُنُودُ ٱلسَّمَٰوَٰتِ وَٱلْأَرْضِ ۚ وَكَانَ ٱللَّهُ عَلِيمًا حَكِيمًۭا',
          translation: '"It is He who sent down tranquility into the hearts of the believers that they would increase in faith along with their [present] faith."',
          reference: 'Surah Al-Fath 48:4',
          type: ContentType.ayah,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Guidance'),
        backgroundColor: const Color(0xFF074C4C),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Minimal header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How are you feeling?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select a mood for spiritual guidance',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Row-by-row list (SMALL CARDS)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                final mood = _moods[index];
                return _buildMoodRow(mood);
              },
            ),
          ),
        ],
      ),
    );
  }

  // SMALL ROW DESIGN - Much smaller!
  Widget _buildMoodRow(MoodCategory mood) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoodDetailPage(mood: mood),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Emoji
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: mood.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      mood.emoji,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Mood name
                Expanded(
                  child: Text(
                    mood.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                // Count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: mood.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${mood.ayahs.length}',
                    style: TextStyle(
                      fontSize: 10,
                      color: mood.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Chevron
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ================ REQUIRED CLASS DEFINITIONS ================

enum ContentType { ayah, hadith, quote }

class MoodContent {
  final String text;
  final String translation;
  final String reference;
  final ContentType type;

  MoodContent({
    required this.text,
    required this.translation,
    required this.reference,
    required this.type,
  });
}

class MoodCategory {
  final String name;
  final String emoji;
  final Color color;
  final List<MoodContent> ayahs;

  MoodCategory({
    required this.name,
    required this.emoji,
    required this.color,
    required this.ayahs,
  });
}

class MoodDetailPage extends StatelessWidget {
  final MoodCategory mood;

  const MoodDetailPage({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mood.name),
        backgroundColor: mood.color,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Simple header
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: mood.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 10),
                Text(
                  'Guidance for ${mood.name.toLowerCase()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Content
          ...mood.ayahs.map((ayah) {
            return _buildGuidanceCard(ayah, mood.color);
          }).toList(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildGuidanceCard(MoodContent content, Color moodColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getTypeColor(content.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                content.type.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: _getTypeColor(content.type),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Arabic text if it's an ayah
            if (content.type == ContentType.ayah)
              Text(
                content.text,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 20,
                  height: 1.6,
                ),
              ),
            if (content.type == ContentType.ayah) const SizedBox(height: 12),

            // Content text
            Text(
              content.type == ContentType.ayah ? content.translation : content.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),

            // Reference
            Row(
              children: [
                Icon(
                  _getTypeIcon(content.type),
                  size: 14,
                  color: moodColor,
                ),
                const SizedBox(width: 6),
                Text(
                  content.reference,
                  style: TextStyle(
                    fontSize: 12,
                    color: moodColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(ContentType type) {
    switch (type) {
      case ContentType.ayah:
        return const Color(0xFF074C4C);
      case ContentType.hadith:
        return const Color(0xFFC39F47);
      case ContentType.quote:
        return Colors.purple;
    }
  }

  IconData _getTypeIcon(ContentType type) {
    switch (type) {
      case ContentType.ayah:
        return Icons.book;
      case ContentType.hadith:
        return Icons.format_quote;
      case ContentType.quote:
        return Icons.lightbulb;
    }
  }
}
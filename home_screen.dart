// lib/screens/home_screen.dart - COMPLETE HOME SCREEN
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:hijri/hijri_calendar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String getRandomQuote() {
    final random = Random();
    int index = random.nextInt(dailyQuotes.length);
    return dailyQuotes[index];
  }

  @override
  Widget build(BuildContext context) {
    final String randomQuote = getRandomQuote();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const ImageCarousel(),
          const SizedBox(height: 24.0),

          const Text(
            "Explore",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: 'Spiritual Goals',
                  subtitle: 'Set and track your long-term spiritual objectives.',
                  icon: Icons.flag_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/goals');
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FeatureCard(
                  title: 'Daily Habits',
                  subtitle: 'Track your daily spiritual practices.',
                  icon: Icons.checklist_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/habits');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: 'Spiritual Journal',
                  subtitle: 'Log your daily reflections and gratitude.',
                  icon: Icons.book_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/journal');
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FeatureCard(
                  title: 'Digital Tasbeeh',
                  subtitle: 'Interactive dhikr counter with beautiful design.',
                  icon: Icons.touch_app,
                  onTap: () {
                    Navigator.pushNamed(context, '/tasbeeh');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: 'Guidance Chat',
                  subtitle: 'Get Islamic guidance for your questions.',
                  icon: Icons.chat_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/chatbot');
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FeatureCard(
                  title: 'Mood Guidance',
                  subtitle: 'Find comfort according to your feeling.',
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/moodAyat');
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          RandomQuoteBlock(quote: randomQuote),

          const SizedBox(height: 16.0),

          const IslamicClock(),

          const SizedBox(height: 16.0),

          Row(
            children: [
              Expanded(
                child: FeatureCard(
                  title: 'Islamic Quiz',
                  subtitle: 'Test your basic Islamic knowledge.',
                  icon: Icons.quiz_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/islamicQuiz');
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: FeatureCard(
                  title: 'Zakat Calculator',
                  subtitle: 'Calculate your annual charity.',
                  icon: Icons.calculate_rounded,
                  onTap: () {
                    Navigator.pushNamed(context, '/zakat');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== DATA & CONSTANTS ====================
const List<String> dailyQuotes = [
  "The best of people are those who benefit others.",
  "Indeed, with hardship [will be] ease.",
  "Be in this world as if you were a stranger or a traveler.",
  "Take account of yourselves before you are taken account of.",
  "Silence is wisdom, and few practice it.",
  "Seek knowledge from the cradle to the grave.",
  "Modesty is a part of faith.",
  "The strongest among you is the one who controls his anger.",
  "A kind word is charity.",
  "Do not lose hope, nor be sad.",
  "Whoever believes in Allah and the Last Day, let him speak good or remain silent.",
  "Cleanliness is half of faith.",
  "The best charity is that given when one is in need.",
  "Allah is with those who are patient.",
  "Speak good or remain silent.",
  "The most beloved deed to Allah is the most regular and constant even if it were little.",
  "Whoever is not grateful to the people, he is not grateful to Allah.",
  "Make things easy and do not make them difficult.",
  "The world is the prison of the believer and the paradise of the disbeliever.",
  "Allah does not look at your appearance or your wealth, but He looks at your hearts and your deeds.",
  "The best of you are those who are best to their families.",
  "A Muslim is the one from whose tongue and hands other Muslims are safe.",
  "He who does not thank people, does not thank Allah.",
  "The best among you are those who have the best manners and character.",
  "When you see a person who has been given more than you in wealth and beauty, look to those who have been given less.",
  "The upper hand is better than the lower hand.",
  "Whoever treads a path in search of knowledge, Allah will make easy for him the path to Paradise.",
  "Allah is beautiful and He loves beauty.",
  "The example of a believer is that of a fresh tender plant.",
  "The most perfect believer in faith is the one who is best in character.",
];

// UPDATED: Local image paths with your actual file names
const List<String> imageCarouselAssets = [
  'assets/images/carousel_quran.jpg',
  'assets/images/carousel_mosque.jpg',
  'assets/images/carousel_prayer.jpg',
];

const List<String> imageCarouselCaptions = [
  "Guidance from the Noble Book",
  "The beauty of faith in architecture",
  "Peace at the end of the day",
];

// ==================== HOME SCREEN COMPONENTS ====================
class IslamicClock extends StatefulWidget {
  const IslamicClock({super.key});

  @override
  State<IslamicClock> createState() => _IslamicClockState();
}

class _IslamicClockState extends State<IslamicClock> {
  late String _timeString;
  late String _gregorianDate;
  late String _islamicDate;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final hijriDate = HijriCalendar.fromDate(now);

    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    final String second = now.second.toString().padLeft(2, '0');

    setState(() {
      _timeString = '$hour:$minute:$second';
      _gregorianDate = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
      _islamicDate = '${hijriDate.hDay} ${hijriDate.hMonth} ${hijriDate.hYear} AH';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _timeString,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w200,
                color: Theme.of(context).primaryColor,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Islamic Date: $_islamicDate',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Gregorian Date: $_gregorianDate',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RandomQuoteBlock extends StatelessWidget {
  final String quote;

  const RandomQuoteBlock({required this.quote, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inspiration of the Day',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFC39F47),
            ),
          ),
          const Divider(color: Color(0xFFC39F47), thickness: 0.5, height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_quote_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  quote,
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < imageCarouselAssets.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            // FIXED: Changed from imageCarouselUrls to imageCarouselAssets
            itemCount: imageCarouselAssets.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // FIXED: Changed from Image.network to Image.asset
                      Image.asset(
                        imageCarouselAssets[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.mosque,
                                    color: Theme.of(context).primaryColor,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    imageCarouselCaptions[index],
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 16.0,
                        right: 16.0,
                        child: Text(
                          imageCarouselCaptions[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // FIXED: Changed from imageCarouselUrls to imageCarouselAssets
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(imageCarouselAssets.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentPage == index ? 24.0 : 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index ? Theme.of(context).colorScheme.secondary : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
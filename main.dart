// lib/main.dart - MINIMAL VERSION
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Import screens
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart'; // Import HomeScreen
import 'screens/habits/habit_tracker.dart';
import 'screens/goals/goal_tracker.dart';
import 'screens/chatbot/islamic_chatbot.dart';
import 'screens/islamic_quiz.dart';
import 'screens/journal/spiritual_journal.dart';
import 'screens/mood_guidance.dart';
import 'screens/tasbeeh_counter.dart';
import 'screens/zakat_calculator.dart';

// Import your existing files
import 'splash_screen.dart';
import 'ProfilePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCOzbj54Ht8Z1l53juEOj3wPLEoDpN0BR0",
          authDomain: "noorulfalah-88fc4.firebaseapp.com",
          projectId: "noorulfalah-88fc4",
          storageBucket: "noorulfalah-88fc4.firebasestorage.app",
          messagingSenderId: "1094294259698",
          appId: "1:1094294259698:web:047b3736103de21018cd6b",
          measurementId: "G-NNDQJFRR7N"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const NoorAlFalahApp());
}

class NoorAlFalahApp extends StatelessWidget {
  const NoorAlFalahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noor Al Falah',
      theme: ThemeData(
        primaryColor: const Color(0xFF074C4C),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: createMaterialColor(const Color(0xFF074C4C)),
        ).copyWith(
          secondary: const Color(0xFFC39F47),
          surface: const Color(0xFFF5F5F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF074C4C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/auth': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainScreen(),
        '/home': (context) => const HomeScreen(), // Add this route
        '/quotesList': (context) => const QuotesListPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/moodAyat': (context) => const MoodGuidancePage(),
        '/islamicQuiz': (context) => const IslamicQuizPage(),
        '/habits': (context) => HabitTracker(),
        '/goals': (context) => const GoalTracker(),
        '/chatbot': (context) => const IslamicChatbot(),
        '/journal': (context) => const SpiritualJournal(),
        '/tasbeeh': (context) => const TasbeehCounter(),
        '/zakat': (context) => const ZakatCalculator(),
      },
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

// ==================== AUTHENTICATION ====================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

// ==================== MAIN SCREEN (Navigation Only) ====================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const GoalTracker(),
    HabitTracker(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ['NOOR - Al Falah', 'Spiritual Goals', 'Daily Habits', 'Account'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        centerTitle: false,
        automaticallyImplyLeading: _selectedIndex == 0,
        actions: [
          if (_selectedIndex == 3)
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: _logout,
              tooltip: 'Logout',
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_rounded),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_rounded),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).primaryColor.withOpacity(0.7),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ==================== APP DRAWER ====================
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final Color primaryColor = Theme.of(context).primaryColor;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user?.displayName ?? 'User Name',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(user?.email ?? 'user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: user?.photoURL != null
                  ? ClipOval(
                child: Image.network(
                  user!.photoURL!,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                ),
              )
                  : const Icon(Icons.person, color: Colors.white, size: 40),
            ),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Spiritual Goals'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/goals');
            },
          ),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: const Text('Habit Tracker'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/habits');
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Spiritual Journal'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/journal');
            },
          ),
          ListTile(
            leading: const Icon(Icons.touch_app),
            title: const Text('Digital Tasbeeh'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/tasbeeh');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Zakat Calculator'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/zakat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.sentiment_satisfied_alt),
            title: const Text('Mood Guidance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/moodAyat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Guidance Chat'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Islamic Quiz'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/islamicQuiz');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// ==================== OTHER PAGES ====================
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable app notifications'),
            value: true,
            onChanged: (value) {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('English'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Font Size'),
            subtitle: const Text('Medium'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class QuotesListPage extends StatelessWidget {
  const QuotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> quotes = [
      {
        'text': 'And whoever relies upon Allah – then He is sufficient for him.',
        'reference': 'Surah At-Talaq 65:3'
      },
      {
        'text': 'Allah does not burden a soul beyond that it can bear.',
        'reference': 'Surah Al-Baqarah 2:286'
      },
      {
        'text': 'Indeed, Allah is with those who fear Him and those who are doers of good.',
        'reference': 'Surah An-Nahl 16:128'
      },
      {
        'text': 'And your Lord says, "Call upon Me; I will respond to you."',
        'reference': 'Surah Ghafir 40:60'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Quotes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quotes[index]['text']!,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    quotes[index]['reference']!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
      ),
      home: const SplashScreen(nextScreen: MainScreen()),
    );
  }
}

// ---------- MAIN SCREEN (with bottom nav) ----------
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool darkMode = false;
  int currentIndex = 0;
  bool isLoading = true;

  List<Map<String, dynamic>> habits = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> names = habits.map((h) => h['name'] as String).toList();
    final List<bool> dones = habits.map((h) => h['done'] as bool).toList();
    await prefs.setStringList('names', names);
    await prefs.setStringList('dones', dones.map((e) => e.toString()).toList());
    await prefs.setBool('darkMode', darkMode);
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final names = prefs.getStringList('names');
    final dones = prefs.getStringList('dones');
    final dm = prefs.getBool('darkMode') ?? false;

    if (names != null && dones != null) {
      final icons = [
        Icons.water_drop,
        Icons.fitness_center,
        Icons.book,
        Icons.self_improvement,
        Icons.star,
      ];
      final colors = [
        Colors.blue,
        Colors.orange,
        Colors.purple,
        Colors.teal,
        Colors.pink,
      ];
      habits = List.generate(names.length, (i) {
        return {
          'name': names[i],
          'icon': icons[i % icons.length],
          'color': colors[i % colors.length],
          'done': dones[i] == 'true',
        };
      });
    } else {
      habits = [
        {'name': 'पानी पिउने', 'icon': Icons.water_drop, 'color': Colors.blue, 'done': false},
        {'name': 'Exercise', 'icon': Icons.fitness_center, 'color': Colors.orange, 'done': false},
        {'name': 'पढ्ने', 'icon': Icons.book, 'color': Colors.purple, 'done': false},
        {'name': 'Meditation', 'icon': Icons.self_improvement, 'color': Colors.teal, 'done': false},
      ];
    }

    setState(() {
      darkMode = dm;
      isLoading = false;
    });
  }

  void _update() {
    setState(() {});
    _saveData();
  }

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D0D),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00FF41)),
        ),
      );
    }

    final screens = [
      HomeScreen(
        habits: habits,
        onUpdate: _update,
        onDelete: _deleteHabit,
        darkMode: darkMode,
      ),
      StatsScreen(habits: habits, darkMode: darkMode),
      SettingsScreen(
        darkMode: darkMode,
        onDarkModeChanged: (v) {
          setState(() => darkMode = v);
          _saveData();
        },
      ),
    ];

    return Theme(
      data: darkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color(0xFF121212),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF4CAF50),
                brightness: Brightness.dark,
              ),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: const Color(0xFFF5F7FA),
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
            ),
      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (i) => setState(() => currentIndex = i),
          backgroundColor: darkMode ? const Color(0xFF1E1E1E) : Colors.white,
          indicatorColor: const Color(0xFF4CAF50).withOpacity(0.2),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: Color(0xFF4CAF50)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF4CAF50)),
              label: 'Stats',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: Color(0xFF4CAF50)),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- HOME SCREEN ----------
class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> habits;
  final VoidCallback onUpdate;
  final Function(int) onDelete;
  final bool darkMode;

  const HomeScreen({
    super.key,
    required this.habits,
    required this.onUpdate,
    required this.onDelete,
    required this.darkMode,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int get completed => widget.habits.where((h) => h['done'] == true).length;
  double get progress =>
      widget.habits.isEmpty ? 0 : completed / widget.habits.length;

  @override
  Widget build(BuildContext context) {
    final textColor = widget.darkMode ? Colors.white : const Color(0xFF1A1A1A);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('नमस्ते ',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
              const SizedBox(height: 4),
              Text('आजको लक्ष्य',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 20),
              _buildProgressCard(),
              const SizedBox(height: 25),
              Expanded(
                child: widget.habits.isEmpty
                    ? _buildEmpty()
                    : ListView.builder(
                        itemCount: widget.habits.length,
                        itemBuilder: (context, i) => _buildHabitCard(i),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
                Text('${(progress * 100).toInt()}%',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$completed / ${widget.habits.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('आज पूरा गरिएको',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitCard(int i) {
    final h = widget.habits[i];
    final isDone = h['done'] as bool;
    final cardColor = widget.darkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = widget.darkMode ? Colors.white : const Color(0xFF1A1A1A);
    return Dismissible(
      key: ValueKey(h['name'].toString() + i.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete?'),
            content: Text('"${h['name']}" मेट्ने हो?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('होइन'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('हो', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        widget.onDelete(i);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${h['name']}" मेटियो')),
        );
      },
      child: GestureDetector(
        onTap: () {
          setState(() => h['done'] = !isDone);
          widget.onUpdate();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDone
                ? (h['color'] as Color).withOpacity(0.1)
                : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDone ? h['color'] as Color : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (h['color'] as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(h['icon'] as IconData,
                    color: h['color'] as Color, size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  h['name'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDone ? Colors.grey : textColor,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isDone ? h['color'] as Color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone
                        ? h['color'] as Color
                        : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, size: 80, color: Colors.grey),
          SizedBox(height: 15),
          Text('कुनै habit छैन',
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 5),
          Text('+ थिचेर थप्नुहोस्',
              style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }

  void _showAddSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('नयाँ Habit थप्नुहोस्',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'जस्तै: पानी पिउने',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        widget.habits.add({
                          'name': controller.text,
                          'icon': Icons.star,
                          'color': Colors.pink,
                          'done': false,
                        });
                      });
                      widget.onUpdate();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('थप्नुहोस्',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
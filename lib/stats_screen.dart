import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  final bool darkMode;

  const StatsScreen({
    super.key,
    required this.habits,
    required this.darkMode,
  });

  @override
  Widget build(BuildContext context) {
    final totalDone = habits.where((h) => h['done'] == true).length;
    final total = habits.length;
    final percent = total == 0 ? 0 : (totalDone / total * 100).toInt();
    final textColor = darkMode ? Colors.white : const Color(0xFF1A1A1A);
    final cardColor = darkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('तथ्याङ्क',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  )),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _statCard('आज', '$percent%', Icons.today,
                        Colors.green, cardColor, textColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _statCard('पूरा', '$totalDone/$total',
                        Icons.check_circle, Colors.blue, cardColor, textColor),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text('यो हप्ता',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
              const SizedBox(height: 15),
              Expanded(
                child: habits.isEmpty
                    ? const Center(
                        child: Text('डेटा छैन',
                            style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: habits.length,
                        itemBuilder: (context, i) {
                          final h = habits[i];
                          final done = h['done'] as bool;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(h['icon'] as IconData,
                                        color: h['color'] as Color, size: 20),
                                    const SizedBox(width: 10),
                                    Text(h['name'] as String,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: textColor)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(7, (index) {
                                    final filled = done && index < 5;
                                    return Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: filled
                                            ? h['color'] as Color
                                            : Colors.grey.shade400
                                                .withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(8),
                                      ),
                                      child: filled
                                          ? const Icon(Icons.check,
                                              color: Colors.white, size: 16)
                                          : null,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color,
      Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
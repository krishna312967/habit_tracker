import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final bool darkMode;
  final ValueChanged<bool> onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'सेटिङ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                  title: const Text('Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  secondary: const Icon(Icons.dark_mode,
                      color: Color(0xFF4CAF50)),
                  value: darkMode,
                  activeColor: const Color(0xFF4CAF50),
                  onChanged: onDarkModeChanged,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const ListTile(
                  leading: Icon(Icons.info, color: Colors.blue),
                  title: Text('Version 1.0.0',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Habit Tracker and developed by kr Techonology'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
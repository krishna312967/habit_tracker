import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;

  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String displayText = '';
  final String fullText = '> INITIALIZING...\n> LOADING MODULES...\n> ACCESS GRANTED ✓';

  @override
  void initState() {
    super.initState();
    _typeWriter();

    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => widget.nextScreen,
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  void _typeWriter() async {
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          displayText += fullText[i];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Terminal header
              Row(
                children: [
                  _dot(Colors.red),
                  const SizedBox(width: 6),
                  _dot(Colors.yellow),
                  const SizedBox(width: 6),
                  _dot(Colors.green),
                  const SizedBox(width: 12),
                  const Text(
                    'terminal — krishna@dev',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Typewriter text
              Text(
                displayText,
                style: const TextStyle(
                  color: Color(0xFF00FF41),
                  fontSize: 16,
                  fontFamily: 'monospace',
                  height: 1.6,
                ),
              ),

              const Spacer(),

              // Developer name
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF00FF41),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'HABIT_TRACKER v1.0',
                        style: TextStyle(
                          color: Color(0xFF00FF41),
                          fontSize: 14,
                          fontFamily: 'monospace',
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'DEVELOPED BY',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                        fontFamily: 'monospace',
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'KRISHNA BISWAKARMA',
                      style: TextStyle(
                        color: Color(0xFF00FF41),
                        fontSize: 18,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 60,
                      height: 2,
                      color: const Color(0xFF00FF41),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
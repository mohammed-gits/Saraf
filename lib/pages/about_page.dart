import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Saraf')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Saraf is an educational USD↔LBP converter with an optional live-rate sync.\n\n'
              '• No database\n'
              '• Manual rate control + live sync\n'
              '• Built for CSCI410 Mobile Application Project\n\n'
              'Disclaimer: Educational simulation only. Not financial advice.',
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class MotivationWidget extends StatefulWidget {
  const MotivationWidget({super.key});

  @override
  State<MotivationWidget> createState() => _MotivationWidgetState();
}

class _MotivationWidgetState extends State<MotivationWidget> {
  String? _quote;

  final List<String> _fallbackQuotes = [
    "You are capable of achieving great things, one small step at a time.",
    "Your mind is a sanctuary — nourish it with peace, kindness, and rest.",
    "Breathe in strength, exhale doubt. Every day is a fresh start.",
    "Be proud of how far you’ve come, and excited for how far you’ll go.",
    "Give yourself credit for the quiet progress no one else sees.",
    "You are stronger than you think and more resilient than you know."
  ];

  @override
  void initState() {
    super.initState();
    _fetchQuote();
  }

  Future<void> _fetchQuote() async {
    final random = Random();
    try {
      final quoteId = random.nextInt(30) + 1;
      final response = await http
          .get(Uri.parse('https://dummyjson.com/quotes/$quoteId'))
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _quote = data['quote'];
          });
        }
      } else {
        _setFallbackQuote();
      }
    } catch (e) {
      _setFallbackQuote();
    }
  }

  void _setFallbackQuote() {
    if (mounted) {
      final random = Random();
      setState(() {
        _quote = _fallbackQuotes[random.nextInt(_fallbackQuotes.length)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          child: _quote == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100,
                        child: Text(
                          _quote!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

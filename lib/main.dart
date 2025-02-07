import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: KritTextSuite(),
    ),
  );
}

class KritTextSuite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Krit Text Suite',
          theme: themeProvider.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: TextSearchScreen(),
        );
      },
    );
  }
}

class TextSearchScreen extends StatefulWidget {
  @override
  _TextSearchScreenState createState() => _TextSearchScreenState();
}

class _TextSearchScreenState extends State<TextSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic> _results = {};
  bool _isLoading = false;

  final List<String> _endpoints = [
    "https://wordsapiv1.p.rapidapi.com/words/{word}/definitions",
    "https://wordsapiv1.p.rapidapi.com/words/{word}/synonyms",
    "https://wordsapiv1.p.rapidapi.com/words/{word}/antonyms",
    "https://wordsapiv1.p.rapidapi.com/words/{word}/pronunciation",
    "https://wordsapiv1.p.rapidapi.com/words/{word}/syllables",
    "https://wordsapiv1.p.rapidapi.com/words/{word}/examples",
    "https://wordsapiv1.p.rapidapi.com/words/{word}/rhymes",
  ];

  Future<void> _searchWord(String word) async {
    if (word.isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = {};
    });

    for (String endpoint in _endpoints) {
      final url = endpoint.replaceAll("{word}", word);
      try {
        final response = await http.get(Uri.parse(url), headers: {
          'x-rapidapi-key': 'xxxxxx',  // Replace with your API key
          'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com',
        });

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data != null && data.isNotEmpty) {
            if (endpoint.contains("synonyms") && data["synonyms"] != null) {
              _results["Synonyms"] = data["synonyms"];
            } else if (endpoint.contains("definitions") && data["definitions"] != null) {
              _results["Definitions"] = data["definitions"];
            } else if (endpoint.contains("antonyms") && data["antonyms"] != null) {
              _results["Antonyms"] = data["antonyms"];
            } else if (endpoint.contains("pronunciation") && data["pronunciation"] != null) {
              _results["Pronunciation"] = data["pronunciation"];
            } else if (endpoint.contains("syllables") && data["syllables"] != null) {
              _results["Syllables"] = data["syllables"];
            } else if (endpoint.contains("examples") && data["examples"] != null) {
              _results["Examples"] = data["examples"];
            } else if (endpoint.contains("rhymes") && data["rhymes"] != null) {
              _results["Rhymes"] = data["rhymes"];
            }
          }
        }
      } catch (e) {
        // Handle API errors
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _clearFields() {
    setState(() {
      _controller.clear();
      _results = {};
    });
  }

  Widget _buildResultCard(String key, dynamic value) {
    if (value == null || (value is List && value.isEmpty)) {
      return SizedBox.shrink();
    }
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 8),
            if (value is List)
              ...value.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  "- ${item.toString().replaceAll(RegExp(r"[{}]"), "")}",
                  style: TextStyle(fontSize: 16),
                ),
              ))
            else
              Text(
                value.toString().replaceAll(RegExp(r"[{}]"), ""),
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Krit Text Suite'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a word',
              ),
              onSubmitted: (_) => _searchWord(_controller.text.trim()), // Hides keyboard on Enter
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
                    foregroundColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus(); // Hides keyboard
                    _searchWord(_controller.text.trim());
                  },
                  child: Text('Search'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
                    foregroundColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _clearFields();
                  },
                  child: Text('Clear'),
                ),
              ],
            ),

            SizedBox(height: 16),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: _results.keys.length,
                itemBuilder: (context, index) {
                  String key = _results.keys.elementAt(index);
                  return _buildResultCard(key, _results[key]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

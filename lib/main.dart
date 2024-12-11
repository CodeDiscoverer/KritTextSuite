import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(KritTextSuite());
}

class KritTextSuite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krit Text Suite',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TextSearchScreen(),
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
    setState(() {
      _isLoading = true;
      _results = {};
    });

    for (String endpoint in _endpoints) {
      final url = endpoint.replaceAll("{word}", word);
      try {
        final response = await http.get(Uri.parse(url), headers: {
          'x-rapidapi-key': 'API_KEY', // Add your API KEY
          'x-rapidapi-host': 'wordsapiv1.p.rapidapi.com',
        });

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data != null && data.isNotEmpty) {
            if (endpoint.contains("synonyms") && data["synonyms"] != null) {
              setState(() {
                _results["SYNONYMS"] = data["synonyms"];
              });
            } else if (endpoint.contains("definitions") && data["definitions"] != null) {
              setState(() {
                _results["DEFINITIONS"] = data["definitions"];
              });
            } else if (endpoint.contains("antonyms") && data["antonyms"] != null) {
              setState(() {
                _results["ANTONYMS"] = data["antonyms"];
              });
            } else if (endpoint.contains("pronunciation") && data["pronunciation"] != null) {
              setState(() {
                _results["PRONUNCIATION"] = data["pronunciation"];
              });
            } else if (endpoint.contains("syllables") && data["syllables"] != null) {
              setState(() {
                _results["SYLLABLES"] = data["syllables"];
              });
            } else if (endpoint.contains("examples") && data["examples"] != null) {
              setState(() {
                _results["EXAMPLES"] = data["examples"];
              });
            } else if (endpoint.contains("rhymes") && data["rhymes"] != null) {
              setState(() {
                _results["RHYMES"] = data["rhymes"];
              });
            }
          }
        }
      } catch (e) {}
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
    return Scaffold(
      appBar: AppBar(title: Text('Krit Text Suite')),
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
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _searchWord(_controller.text.trim()),
                  child: Text('Search'),
                ),
                ElevatedButton(
                  onPressed: _clearFields,
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

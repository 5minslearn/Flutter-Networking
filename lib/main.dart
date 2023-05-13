import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> _resources = [];

  @override
  void initState() {
    super.initState();
    _fetchResources();
  }

  void _fetchResources() async {
    final response = await http.get(Uri.parse(
        'https://api.sampleapis.com/codingresources/codingResources'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      setState(() {
        _resources = data;
      });
    } else {
      throw Exception('Failed to load resources');
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _resources.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _resources.length,
                itemBuilder: (context, index) {
                  final resource = _resources[index];
                  return InkWell(
                      onTap: () => {_launchURL(resource['url'])},
                      child: Card(
                          child: ListTile(
                        title: Text(resource['description']),
                        subtitle: Text(resource['url']),
                        leading: const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                        trailing: Text(resource['types'].join(', ')),
                      )));
                }));
  }
}

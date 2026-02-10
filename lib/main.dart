import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String baseUrl = 'https://harelike-vicente-epimyocardial.ngrok-free.dev';
  List<dynamic> projects = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        // Parse HTML to get projects (simplified)
        setState(() {
          projects = [
            {'name': 'CRISZAN', 'icon': '📁'},
            {'name': 'XrisHub', 'icon': '💾'},
            {'name': 'XrisChat', 'icon': '💬'},
            {'name': 'PPDB Online', 'icon': '🎓'},
            {'name': 'PHP OOP', 'icon': '💻'},
          ];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadProjects,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadProjects,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Text(
                        project['icon'],
                        style: const TextStyle(fontSize: 32),
                      ),
                      title: Text(project['name']),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectDetailPage(
                              projectName: project['name'],
                              baseUrl: baseUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class ProjectDetailPage extends StatelessWidget {
  final String projectName;
  final String baseUrl;

  const ProjectDetailPage({
    super.key,
    required this.projectName,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              projectName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Open project in webview or browser
              },
              icon: const Icon(Icons.open_in_browser),
              label: const Text('Open Project'),
            ),
          ],
        ),
      ),
    );
  }
}

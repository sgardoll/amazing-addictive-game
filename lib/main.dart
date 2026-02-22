import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindsort/core/providers/game_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MindSort - Emotion Sorting Puzzle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MindSort'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() {> MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  void initState() {
    super.initState();
    ref.read(gameControllerProvider.notifier).initializeGame();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerState = ref.watch(gameControllerProvider);
    
    if (controllerState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Open settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Game board goes here
          Expanded(
            child: Center(
              child: Text(
                'Game board will be implemented in Wave 2',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: () {
                    ref.read(gameControllerProvider.notifier).undo();
                  },
                  tooltip: 'Undo last move',
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(gameControllerProvider.notifier).restartLevel();
                  },
                  tooltip: 'Restart level',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:orodomop/utils/time.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:async';

enum Mode { focus, rest }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ShadApp(
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(background: Colors.black),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int timer = 0;
  Mode mode = Mode.focus;
  Timer? _stopwatchTimer;
  bool isRunning = false;
  String message = "";

  void startStopwatch() {
    if (_stopwatchTimer != null && _stopwatchTimer!.isActive) return;

    message = "";

    _stopwatchTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        switch (mode) {
          case Mode.focus:
            timer++;
            break;
          case Mode.rest:
            timer--;
            if (timer <= 0) {
              // break is done
              resetStopwatch();
              mode = Mode.focus;
              message = "Rest time finished! Back to Focus mode.";
            }
            break;
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopStopwatch() {
    if (timer < 5 * 60 && mode == Mode.focus) {
      message = "Focus time must be at least 5 minutes!";
      resetStopwatch();
    } else {
      setState(() {
        mode = Mode.rest;
        timer = getBreakTime(timer);
      });
    }

    _stopwatchTimer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void resetStopwatch() {
    _stopwatchTimer?.cancel();
    setState(() {
      timer = 0;
      isRunning = false;
    });
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              mode.name[0].toUpperCase() + mode.name.substring(1),
              style: ShadTheme.of(context).textTheme.h4,
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(timer),
              style: ShadTheme.of(context).textTheme.h1Large,
            ),
            const SizedBox(height: 20),
            isRunning
                ? ShadButton.outline(
                    child: Text('Stop'),
                    onPressed: () {
                      stopStopwatch();
                    },
                    size: ShadButtonSize.lg,
                  )
                : ShadButton(
                    child: Text('Start'),
                    onPressed: () {
                      startStopwatch();
                    },
                    size: ShadButtonSize.lg,
                  ),
            const SizedBox(height: 20),
            Text(message, style: ShadTheme.of(context).textTheme.muted),
          ],
        ),
      ),
    );
  }
}

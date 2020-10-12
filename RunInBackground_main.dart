import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class LifecycleWatcher extends StatefulWidget {
  @override
  _LifecycleWatcherState createState() => _LifecycleWatcherState();
}

// State WidgetsBindingObserver ile mix olacak
class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  Timer _timer;
  int _second = 0;

  void _handleTimer(Timer timer) {
    setState(() {
      _second++;
    });
  }

  // Timer oluştur. Daha önce oluşturulmuşsa onu iptal et yenisini oluştur.
  // Oluşturulmamışsa baştan oluştur.
  void _initTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), _handleTimer);
    } else
      _timer = Timer.periodic(Duration(seconds: 1), _handleTimer);
  }

  @override
  void initState() {
    super.initState();

    // Widget kurulurken timer hazırlansın
    _initTimer();

    // Widget lifecycle takibi için gerekli
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Dispose etmeyi unutmuyoruz.
    WidgetsBinding.instance.removeObserver(this);
    _timer.cancel();
    super.dispose();
  }

  // Burada Widget Lifecycle takibi yapıyoruz.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Bu sayfa/widget için uygulama uyanıkken, arkaplana alındığında,
    // veya kilit ekranında pause edildiğinde Timer yeniden hazırlansın.
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        setState(() {
          _initTimer();
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '$_second',
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LifecycleWatcher(),
  ));
}

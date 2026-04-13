import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _videoController;
  bool _loginShown = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/animations/splash.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(false);
        _videoController.play();
      });

    _videoController.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    if (_loginShown) return;
    final pos = _videoController.value.position;
    final dur = _videoController.value.duration;
    if (_videoController.value.isInitialized &&
        dur.inMilliseconds > 0 &&
        pos.inMilliseconds >= dur.inMilliseconds - 200) {
      _loginShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLogin());
    }
  }

  void _showLogin() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) => const LoginScreen(),
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoUpdate);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _videoController.value.isInitialized
          ? SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
    );
  }
}

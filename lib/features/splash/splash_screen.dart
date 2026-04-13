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
        _videoController.play();
        _videoController.setLooping(false);
      });

    _videoController.addListener(_onVideoUpdate);
  }

  void _onVideoUpdate() {
    if (!_loginShown &&
        _videoController.value.isInitialized &&
        !_videoController.value.isPlaying &&
        _videoController.value.position >= _videoController.value.duration) {
      _loginShown = true;
      _showLogin();
    }
  }

  void _showLogin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: LoginScreen(),
      ),
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

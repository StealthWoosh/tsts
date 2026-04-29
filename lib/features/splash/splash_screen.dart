import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_colors.dart';
import '../auth/presentation/screens/auth_screen.dart'; // Import auth screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _textController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Controller untuk icon
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animasi icon jatuh dari atas
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -10),
      end: const Offset(0, -0.5),
    ).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.bounceOut,
      ),
    );

    // Controller untuk text
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Animasi text muncul satu persatu
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );

    // Jalankan animasi icon
    _iconController.forward();

    // Jalankan animasi text setelah animasi icon selesai
    _iconController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textController.forward();
      }
    });

    // Navigasi ke AuthScreen setelah semua animasi selesai
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AuthScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon dengan animasi slide
            SlideTransition(
              position: _slideAnimation,
              child: SvgPicture.asset(
                'assets/icons/logo.svg',
                width: 120,
                height: 120,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Text dengan animasi muncul
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: _textAnimation.value,
                    child: child,
                  ),
                );
              },
              child: const Text(
                'Ruang Sehat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeadlineText extends StatelessWidget {
  final bool isLogin;
  final double bottomHeight;

  const HeadlineText({
    super.key,
    required this.isLogin,
    required this.bottomHeight,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: bottomHeight * 0.4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/logo.svg',
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isLogin 
                    ? 'Go ahead and complete your \naccount and setup' 
                    : 'Register now to acces \nyour personal account ',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isLogin
                      ? 'Create your account and simplify your workflow instantly'
                      : 'Register now to access your personal account',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
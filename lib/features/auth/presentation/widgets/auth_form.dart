import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:ruang_sehat/features/auth/presentation/widgets/headline_text.dart';
import 'package:ruang_sehat/features/auth/presentation/widgets/auth_form.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';
import 'package:ruang_sehat/features/home/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/utils/snackbar_helper.dart';
import 'package:ruang_sehat/widgets/bottom_navbar.dart';


class AuthForm extends StatefulWidget {
    final bool isLogin;
    final VoidCallback onSwitchToLogin;

  const AuthForm({
    super.key,
    required this.isLogin,
    required this.onSwitchToLogin,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  bool _rememberMe = false;

  Future<void> handleSubmit(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    bool success;

    if (widget.isLogin) {
      success = await auth.login(
        nameController.text.trim(),
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    } else {
      success = await auth.register(
        nameController.text.trim(),
        usernameController.text.trim(),
        passwordController.text.trim(),
      );
    }

    if (!context.mounted) return;

    if (success) {
      // tampilkan success message dari provider
      if (auth.successMessage != null) {
        SnackbarHelper.show(context, message: auth.successMessage!);
      }

      if (widget.isLogin) {
        Navigator.pushReplacementNamed(
          context,
          BottomNavbar.routeName,
          arguments: 0,
        );
      } else {
        widget.onSwitchToLogin();
      }
    } else {
      // tampilkan error provider
      if (auth.errorMessage != null) {
        SnackbarHelper.show(
          context,
          message: auth.errorMessage!,
          isError: true,
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isLogin == false) ... [
        // field Name
        SizedBox(height: 18),
        Text(
          'Name',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: 'Enter Your Name',
            hintStyle: TextStyle(color: AppColors.hintText),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 14.0,
            ),
          ),
        ),
        ],
      // field Username
      SizedBox(height: 18),
      Text(
        'Username',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: usernameController,
        decoration: InputDecoration( 
          hintText: 'Enter Your Username',
          hintStyle: TextStyle(color: AppColors.hintText),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 14.0,
        ),
      ),
      ),
      
      // field password
      SizedBox(height: 18),
      Text(
        'Password',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: passwordController,
        obscureText: _isObscure,
        decoration: InputDecoration(
          hintText: 'Enter Your Password',
          hintStyle: TextStyle(color: AppColors.hintText),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 14.0,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              color: AppColors.hintText,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
        ),
      ),
      
      // Button Login/Register
      SizedBox(height: 18),
      ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          minimumSize: Size(double.infinity, 53),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          widget.isLogin ? 'Login' : 'Register',
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Remember me & forgot password
      SizedBox(height: 18),
      Row(
        children: [
          Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: const BorderSide(color: AppColors.hintText, width: 2),
          ),
          const Text(
            'Remember me',
            style: TextStyle(
              color: AppColors.hintText,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
      
      //Divider with Text
      SizedBox(height: 18),
      Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: AppColors.border)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Or login with",
              style: TextStyle(
                color: AppColors.hintText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: AppColors.border)),
        ],
      ),
      
      // Login with Google
      SizedBox(height: 18),
      Center(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, width: 2),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/icons/google.svg',
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
      ],
      
    );
  }
}
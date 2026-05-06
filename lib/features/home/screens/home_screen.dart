import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:ruang_sehat/features/home/widgets/featured_card.dart';
import 'package:ruang_sehat/features/home/widgets/recommended_card.dart';
import 'package:ruang_sehat/widgets/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/auth/providers/auth_provider.dart';
import 'package:ruang_sehat/utils/snackbar_helper.dart';
import 'package:ruang_sehat/features/auth/presentation/screens/auth_screen.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';
  
  @override
  Widget build(BuildContext context) {
      final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  "assets/images/profile.png",
                  fit: BoxFit.cover,
                  width: size.width / 8,
                  height: size.width / 8,
                ),
              ),
              SizedBox(width: 12),
              // username
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<AuthProvider>(  
                    builder: (context, provider, _) {
                    return Text(
                      'Hi, ${provider.profile?.name ?? 'user'}',
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.w600
                      ),
                  );
                    },
                  ),
                  Text(
                    'How are you feeling today?',
                    style: TextStyle(fontSize:16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Spacer(),
              
              //Overflow Menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, size: 28),
                offset: const Offset(0, 50),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                color: AppColors.secondary,
                onSelected: (value) {
                  ModalBottomSheet.show(  
                    context: context,
                    label: 'Are you sure you want to log out?',
                    isLogout: true,
                    onConfirm: () async {
                      final authProvider = context.read<AuthProvider>();
                      await authProvider.logout();

                      if (authProvider.errorMessage == null) {
                        SnackbarHelper.show(  
                          context,
                          message: authProvider.successMessage ?? 'success',
                          isError: false,
                        );
                        Navigator.pushNamedAndRemoveUntil(  
                          context,
                          AuthScreen.routeName,
                          (route) => false,
                        );
                      } else {
                        SnackbarHelper.show(  
                          context,
                          message: authProvider.errorMessage ?? 'error',
                          isError: true,
                        );
                      }
                    },
                  );
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: AppColors.error),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(color: AppColors.error)
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrolInfo) {
          // Cek jika sisa scroll kurang dari 200 pixel dari bawah
          if (scrolInfo.metrics.pixels >= scrolInfo.metrics.maxScrollExtent - 200) {
            final provider = context.read<ArticleProvider>();

            // Panggil fungsi getArticles dengan isRefresh = false (Load More)
            if (!provider.isFetchingMore && provider.hasNextPage) {
              provider.getArticles(isRefresh: false);
            }
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Featured',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const Text(
                      'See More >',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.hintText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              //Featured Card
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 16),
              ),
              // Recommend Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recommended for you',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    RecommendedCard(),
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
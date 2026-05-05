import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:ruang_sehat/features/articles/providers/articles_provider.dart';
import 'package:ruang_sehat/features/articles/presentation/widgets/container_detail.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  static const routeName = '/detail-article';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  static final String baseUrl = dotenv.env['BASE_URL']!;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      final id = args['id'];

      context.read<ArticleProvider>().getDetailArticle(id);
    });
  } 

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ArticleProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.detailArticle == null) {
      return const Center(child: Text("Tidak ada Artikel"));
    }

    final article = provider.detailArticle!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(  
          children: [
            // Image article
            Image(   
              image: NetworkImage("$baseUrl/${article.image}"),
              width: double.infinity,
              height: 500,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    AppColors.background.withOpacity(
                      1.0
                    ), //bagian bawah lebih solid
                    AppColors.background.withOpacity(
                      0.0,
                    ),
                  ]
                )),
              ),
            ),
            // Container Detail
            Positioned(  
              left: 20,
              right: 20,
              top: 0,
              bottom: 0,
              child: ContainerDetail(article: article),
            ),
            
            // Back button
            Positioned(  
              top: 25,
              left: 25,
              right: 25,
              child: Row(  
                children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(  
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textPrimary.withOpacity(0.3),
                ),
                child: Padding(  
                  padding: const EdgeInsets.only(left: 7),
                  child: IconButton(  
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(  
                      Icons.arrow_back_ios,
                      color: AppColors.secondary,
                      size: 25,
                    ),
                  ),
                ),
              ),
              
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(   
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textPrimary.withOpacity(0.3),
                ),
              ),
              ],
              ),
            )
          ],
        )
      )
    );
  }
}
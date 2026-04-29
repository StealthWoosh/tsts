import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';
class MyArticlesCard extends StatelessWidget {
  const MyArticlesCard({super.key});

  @override  
  Widget build(BuildContext context) {
    return ListView.separated(  
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      separatorBuilder: (_, __) => const SizedBox(height: 7),
      itemBuilder: (context, index) {
        return Card(  
          color: AppColors.secondary,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(  
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(  
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [  
                Stack(  
                  children: [
                    // container image
                    Container(
                      width: double.infinity,
                      height: 196,
                      decoration: BoxDecoration(  
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(  
                          image: NetworkImage("assets/images/artikel.jpg"),
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    // label category
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric( 
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(  
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'Healthy Tips',
                          style: TextStyle(  
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )
                        )
                      ),
                    ),
                  ],
                ),
              
              // title article
              Padding( 
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(  
                      'Artikel ke $index',
                      style: TextStyle(  
                        fontSize: 12,
                        color: AppColors.hintText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(  
                      '2022-10-01',
                      style: TextStyle(  
                        fontSize: 12,
                        color: AppColors.hintText,
                        fontWeight: FontWeight.w500,
                      )
                    )
                  ],
                ),
              ),
              Text(  
                  "The Benefits of Running and Tips to get Started",
                  style: TextStyle(  
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        );
      },
    );
  }
}
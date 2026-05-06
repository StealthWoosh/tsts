import 'package:flutter/material.dart';
import 'package:ruang_sehat/theme/app_colors.dart';

class ModalBottomSheet {
  static void show({
    required BuildContext context,
    required String label,
    required VoidCallback onConfirm,
    required bool isLogout,
  }) {
    showModalBottomSheet(  
      context: context,
      shape: const RoundedRectangleBorder(  
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Column(  
            mainAxisSize: MainAxisSize.min,
            children: [
              // Container Icon
              Container(  
                decoration: BoxDecoration(  
                  color: AppColors.sheetError,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(  
                  padding: EdgeInsetsGeometry.all(10),
                  child: Icon(  
                    isLogout ? Icons.logout : Icons.delete_outline,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),
              ),
              // Teks Label
              SizedBox(height: 20),
              Text(  
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              // Teks untuk Logout
              if (isLogout)
              Text(  
                'You will need to sign in again to access your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              // Button Cancel
              SizedBox(height: 20),
              ElevatedButton(  
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(  
                  backgroundColor: AppColors.secondary,
                  minimumSize: Size(double.infinity, 53),
                  shape: RoundedRectangleBorder(  
                    side: BorderSide(color: AppColors.border, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(  
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Button Ok
              SizedBox(height: 10),
              ElevatedButton(  
                onPressed: () async {
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(  
                  backgroundColor: AppColors.error,
                  minimumSize: Size(double.infinity, 53),
                  shape: RoundedRectangleBorder(  
                    borderRadius:  BorderRadius.circular(10),
                  ),
                ),
                child: Text(  
                  isLogout ? 'Logout' : 'Delete',
                  style: TextStyle(  
                    color: AppColors.secondary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
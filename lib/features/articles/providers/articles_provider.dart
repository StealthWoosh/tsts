import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/articles_model.dart';
import 'package:ruang_sehat/features/articles/data/articles_services.dart';

class ArticleProvider with ChangeNotifier {
  List<ArticlesModel> _articles = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getter
  List<ArticlesModel> get articles => _articles;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> getArticles() async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.getArticles();

      _articles = result;

      if (result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  // Helper
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _resetMessage() {
    _errorMessage = null;
    _successMessage = null;
  }

  String _parseError(Object e) {
    return e.toString().replaceAll('Exception: ', '');
  }
}
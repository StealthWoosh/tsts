import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ruang_sehat/features/articles/data/articles_model.dart';
import 'package:ruang_sehat/features/articles/data/articles_services.dart';

class ArticleProvider with ChangeNotifier {
  List<ArticlesModel> _articles = [];
  List<ArticlesModel> _myArticles = [];
  ArticlesModel? _detailArticle;
  List<ArticlesModel> _featuredArticles = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _isFetchingMore = false;
  int _currentPage = 1;
  bool _hasNextPage = true;

  // Getter
  List<ArticlesModel> get articles => _articles;
  List<ArticlesModel> get myArticles => _myArticles;
  ArticlesModel? get detailArticle => _detailArticle;
  List<ArticlesModel> get featuredArticles => _featuredArticles;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasNextPage => _hasNextPage;

  // get all article
  Future<void> getArticles({bool isRefresh = true}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasNextPage = true;
      _setLoading(true);
    } else {
      if (!_hasNextPage || _isFetchingMore) return;
      _setFetchingMore(true);
    }

    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.getArticles(
        page: _currentPage,
        limit: 5,
      );

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

  // get my article
  Future<void> getMyArticles() async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.getMyArticles();

      _myArticles = result;

      if(result.isEmpty) {
        _errorMessage = "Data artikel kosong";
      
      }
    } catch (err) {
      _errorMessage = _parseError(err);
      _myArticles = [];
    } finally {
      _setLoading(false);
    }
  }

  // get detail artcle
  Future<void> getDetailArticle(String id) async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.getDetailArticle(id);
      _detailArticle = result;
    } catch (e) {
      _errorMessage = _parseError(e);
      _detailArticle = null;
    } finally {
      _setLoading(false);
    }
  }
  
  // create article
  Future<void> createArticle(  
    String title,
    String description,
    String category,
    String imagePath,
  ) async {
    _setLoading(true);
    _resetMessage();

    try {
      final streamedResponse = await ArticlesServices.createArtikel(  
        File(imagePath),
        title,
        description,
        category,
      );

      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel berhasil dibuat';
      } else if (response.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? "Terjadi kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan koneksi';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // update article
  Future<void> updateArticle( 
    String id, {
      String? title,
      String? description,
      String? category,
      String? imagePath,
    }) async {
      _setLoading(true);
      _resetMessage();

      try {
        final streamedResponse = await ArticlesServices.updateArtikel(
          id,
          title: title,
          description: description,
          category: category,
          image: imagePath != null ? File(imagePath) : null,
        );

        final response = await http.Response.fromStream(streamedResponse);

        final data = jsonDecode(response.body);

        if (response.statusCode == 201 || response.statusCode == 200) {
          await getMyArticles();
          await getArticles();
          await getDetailArticle(id);
          _successMessage = data['message'] ?? 'Artikel berhasil diperbarui';
        } else if (response.statusCode == 400) {
          final firstError = data['errors'][0];
          _errorMessage = firstError['message'] ?? "Terjadi kesalahan";
        } else {
          _errorMessage = data['message'] ?? 'Terjadi kesalahan';
        }
      } catch (e) {
        _errorMessage = 'Terjadi kesalahan koneksi';
      } finally {
        _setLoading(false);
        notifyListeners();
      }
    }
  
  // delete artikel
  Future<void> deleteArticle(String id) async {
    _setLoading(true);
    _resetMessage();

    try {
      final result = await ArticlesServices.deleteArtikel(id);

      final data = jsonDecode(result.body);

      if (result.statusCode == 200) {
        await getMyArticles();
        await getArticles();
        _successMessage = data['message'] ?? 'Artikel berhasil dihapus';
      } else if (result.statusCode == 400) {
        final firstError = data['errors'][0];
        _errorMessage = firstError['message'] ?? "Terjadi kesalahan";
      } else {
        _errorMessage = data['message'] ?? 'Terjadi kesalahan';
      }
    } catch (e) {
      _errorMessage = _parseError(e);
    } finally {
      _setLoading(false);
      notifyListeners();
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

  void _setFetchingMore(bool value) {
    _isFetchingMore = value;
    notifyListeners();
  }
}
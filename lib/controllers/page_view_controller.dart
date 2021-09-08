import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewController extends GetxController {
  final PageController _controller = PageController(initialPage: 0);
  final _currentPage = 0.obs;

  PageController get controller => _controller;

  int get currentPage => _currentPage.value;

  set setCurrentPage(int index) => _currentPage.value = index;

  void animateToPage(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionAskerScreen extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function onTap;

  const PermissionAskerScreen(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: kToolbarHeight / 2),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            const SizedBox(height: kToolbarHeight / 2),
            Icon(
              Icons.storage_rounded,
              color: context.theme.iconTheme.color,
              size: 150,
            ),
            const SizedBox(height: kToolbarHeight / 2),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            const SizedBox(height: kToolbarHeight / 2),
            TextButton(
              onPressed: () => onTap(),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

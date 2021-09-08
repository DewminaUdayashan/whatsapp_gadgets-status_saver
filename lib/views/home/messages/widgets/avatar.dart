import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';

class Avatar extends StatelessWidget {
  final IconData icon;

  const Avatar({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: avatarColors[Random().nextInt(avatarColors.length)],
      child: Icon(
        icon,
      ),
    );
  }
}

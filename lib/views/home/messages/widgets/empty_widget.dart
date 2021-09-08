import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "🙄\nLooks Like there isn't any of massages saved yet\n\n"
            "App will automatically save messages when notification posted to your mobile.\n🤗",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "-- Note --\n"
            "01. Messages receiving while you are on that chat will not be saved.\n"
            "02. Other messages receiving as notification will be saved and will not be deleted.\n"
            "03. Also you can view messages from here without letting sender know that you did seen the message\n"
            "-",
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline6!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:get/get.dart';

class ContactUsButton extends StatelessWidget {
  const ContactUsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        try {
          const number = '+94787693462';
          const message = "";
          const url = "https://wa.me/$number?text=$message";
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            SnackHelper.contactError();
          }
        } catch (e, stack) {
          SnackHelper.contactError();
          FirebaseCrashlytics.instance.log(e.toString());
          FirebaseCrashlytics.instance.recordError(e, stack);
        }
      },
      icon: Row(
        children: [
          Icon(
            FontAwesomeIcons.whatsapp,
            color: context.theme.iconTheme.color,
          ),
          const SizedBox(width: 5),
          Text(
            "Contact Us",
            style: context.theme.textTheme.headline6!.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

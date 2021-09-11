import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_gadgets/constants/constants.dart';
import 'package:whatsapp_gadgets/constants/texts.dart';
import 'package:whatsapp_gadgets/helpers/snack_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class DirectMessageDialog extends StatelessWidget {
  DirectMessageDialog({Key? key}) : super(key: key);
  final _number = TextEditingController();
  final _message = TextEditingController(text: '');
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(7),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                sendDirectMessage2,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            Divider(color: Theme.of(context).accentColor),
            const SizedBox(height: 16),
            Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return 'Enter Mobile Number';
                        }
                        if (!value.startsWith('+')) {
                          return 'Enter number with country code.. eg: +91xxxxxxx';
                        }
                        if (value == '' || value == ' ') {
                          return 'Enter Mobile Number';
                        }
                      },
                      controller: _number,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                      decoration: InputDecoration(
                        labelText: enterNumber,
                        hintText: 'Eg : +94xxxxxxxxx',
                        labelStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        hintStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white24,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: lightGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _message,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                      decoration: InputDecoration(
                        labelText: enterMessage,
                        hintText: 'Eg : Hello..',
                        labelStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal,
                                ),
                        hintStyle:
                            Theme.of(context).textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white24,
                                ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: lightGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 25),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                if (_key.currentState!.validate()) {
                  try {
                    final number = _number.text.replaceAll("+", "").trim();
                    final message = _message.text;
                    final url = "https://wa.me/$number?text=$message";
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      SnackHelper.cantSendMessage();
                    }
                  } catch (e, stack) {
                    SnackHelper.cantSendMessage(err: e.toString());
                    FirebaseCrashlytics.instance.log(e.toString());
                    FirebaseCrashlytics.instance.recordError(e, stack);
                  }
                }
              },
              child: const Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

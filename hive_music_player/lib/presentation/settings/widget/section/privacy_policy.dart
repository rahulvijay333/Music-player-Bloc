import 'package:flutter/material.dart';
import 'package:hive_music_player/common/common.dart';

privacyPolicy(BuildContext context) {
  showDialog(
      barrierColor: Colors.transparent.withOpacity(0.8),
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: mainColor.withOpacity(0.8),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
            content: Container(
              width: 320,
              child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: const [
                    Text(
                      '''We take your privacy very seriously. This privacy policy explains how we collect, use, and protect your personal information when you use our RythemRider.\n1. Information We Collect:\nRythemRider does not collect any personal information about you. We do not require you to create an account or provide any personal information to use our app.\n2. Use of Information:\nSince we do not collect any personal information, we do not use any such information.\n3. Protection of Information: \nWe take all necessary measures to protect your personal information, but since we don't collect any data there is nothing to protect.\n4. Third-Party Disclosure:\nSince we do not collect any data, we do not disclose any personal information to any third-party organizations.\n5. Changes to this Privacy Policy:\nWe reserve the right to update or modify this Privacy Policy at any time without prior notice. Your continued use of our RythemRider after any such changes constitutes your acceptance of the new Privacy Policy.\n\n6. Contact Us:\nIf you have any questions about this Privacy Policy, please contact us at rjust.test1496@gmail.com.\n''',
                      style: TextStyle(color: Colors.white),
                    ),
                  ]),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Dismiss',
                    style: TextStyle(color: Colors.white),
                  )),
            ]);
      });
}

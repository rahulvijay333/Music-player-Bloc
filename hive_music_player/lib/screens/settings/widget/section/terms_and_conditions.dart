import 'package:flutter/material.dart';
import 'package:hive_music_player/common/common.dart';

termsAndCondition(BuildContext context) {
  showDialog(
      barrierColor: Colors.transparent.withOpacity(0.8),
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: mainColor.withOpacity(0.8),
          title: const Text(
            'Terms and Conditions',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            height: 500,
            width: 300,
            child: ListView(
                physics: const BouncingScrollPhysics(),
                children: const [
                  Text(
                    '''License Agreement:\nThe user acknowledges that this app is licensed, not sold, to them. The user may use this app only as permitted by applicable law or by licensing terms agreed upon between the user and the owner of the app.
            \nCopyright:\nAll the content available on this app, including but not limited to, text, graphics, logos, button icons, images, audio clips, digital downloads, data compilations, and software, is the property of the app owner or its content suppliers and is protected by international copyright laws.
            \nUse of the App:\nThe user agrees to use this app only for lawful purposes and in accordance with these terms and conditions. The user is prohibited from using this app in any way that violates any applicable federal, state, local, or international law or regulation.
            \nLimitation of Liability:\nThe app owner shall not be liable for any damages of any kind arising from the use of this app, including but not limited to, direct, indirect, incidental, punitive, and consequential damages.
            \nPrivacy Policy:\nThe app owner respects the privacy of its users and has a Privacy Policy in place that describes the type of data the app collects, how the data is used, and how it is protected. By using this app, the user agrees to the terms of the Privacy Policy.
            \nIndemnification:\nThe user agrees to indemnify, defend, and hold harmless the app owner and its affiliates, officers, directors, employees, and agents from and against any and all claims, liabilities, damages, losses, costs, expenses, or fees arising from the user's use of the app or violation of these terms and conditions.
            \nTermination:\nThe app owner reserves the right to terminate or suspend the user's access to the app without notice for any reason, including but not limited to, violation of these terms and conditions.
            \nChanges to Terms and Conditions:\nThe app owner reserves the right to update or modify these terms and conditions at any time without prior notice. The user is responsible for regularly reviewing these terms and conditions to stay informed of any changes.
            \nGoverning Law:\nThese terms and conditions shall be governed by and construed in accordance with the laws of the jurisdiction where the app owner is located, without giving effect to any choice of law or conflict of law provisions.\nBy downloading and using this app, the user agrees to be bound by these terms and conditions.
            ''',
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
          ],
        );
      });
}

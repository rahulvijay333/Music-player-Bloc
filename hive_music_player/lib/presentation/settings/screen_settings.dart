import 'package:flutter/material.dart';

import 'package:rythem_rider/common/common.dart';
import 'package:rythem_rider/domain/db_functions/reset/reset_app.dart';
import 'package:rythem_rider/presentation/settings/widget/section/about_section.dart';
import 'package:rythem_rider/presentation/settings/widget/section/privacy_policy.dart';
import 'package:rythem_rider/presentation/settings/widget/section/terms_and_conditions.dart';
import 'package:rythem_rider/presentation/settings/widget/setting.dart';
import 'package:share_plus/share_plus.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({
    super.key,
  });

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: mainColor,
          appBar: AppBar(
            title: const Text(
              'Settings',
            ),
            centerTitle: true,
            backgroundColor: mainColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                //-----------------------------------about us
                GestureDetector(
                    onTap: () {
                      aboutSection(context);
                    },
                    child: const SettingTileCustom(
                        name: 'About Us', icon: Icons.info)),
                const SizedBox(
                  height: 10,
                ),

                //----------------------------------terms and condition
                GestureDetector(
                  onTap: () {
                    termsAndCondition(context);
                  },
                  child: const SettingTileCustom(
                      name: 'Terms and Conditions', icon: Icons.book),
                ),
                const SizedBox(
                  height: 10,
                ),
                //------------------------------------privacy policy
                GestureDetector(
                  onTap: () {
                    privacyPolicy(context);
                  },
                  child: const SettingTileCustom(
                      name: 'Privacy Policy', icon: Icons.security),
                ),
                const SizedBox(
                  height: 10,
                ),

                GestureDetector(
                    onTap: () {
                      Share.share(shareRythemRiderAppLink);
                    },
                    child: const SettingTileCustom(
                        name: 'Share', icon: Icons.share)),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: () {
                      confirmReset(context);
                    },
                    child: const SettingTileCustom(
                        name: 'Reset App', icon: Icons.restore_sharp)),
                const Spacer(),
                const Text(
                 '${versionNumber}v',
                  style: TextStyle(color: Colors.white),
                ),
               
              ],
            ),
          )),
    );
  }

  confirmReset(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent.withOpacity(0.8),
      context: context,
      builder: (ctx1) {
        return AlertDialog(
          backgroundColor: mainColor.withOpacity(0.8),
          title: const Text(
            'Important',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Do you want to reset app ?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  resetApp(context);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx1);
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        );
      },
    );
  }
}

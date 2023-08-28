import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  // The package version. CFBundleShortVersionString on iOS, versionName on Android.
  late String _version = "1";

  @override
  void initState() {
    _load();
    super.initState();
  }

  void _load() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    _version = packageInfo.version;

    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle? textStyle = theme.textTheme.bodyMedium;
    final List<Widget> aboutBoxChildren = <Widget>[
      const SizedBox(height: 24),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: textStyle,
                text: "Flutter is Google's UI toolkit for building beautiful, "
                    '\nnatively compiled applications for mobile, web, and desktop '
                    '\nfrom a single codebase. Learn more about Flutter at '),
            TextSpan(
              text: '\nhttps://flutter.dev',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL2();
                },
            ),
            TextSpan(style: textStyle, text: '.'),
          ],
        ),
      ),
    ];
    return Scaffold(
        appBar: AppBar(title: const Text(("about"))),
        body: SafeArea(
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Card(
                        color: Colors.grey[300],
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: 'Wake! Wake! version: $_version\n',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                    children: <TextSpan>[
                                      const TextSpan(
                                          text: '\nWake! Wake! is aplication created in'),
                                      TextSpan(
                                        text: ' flutter',
                                        style: const TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showAboutDialog(
                                              context: context,
                                              applicationIcon: const FlutterLogo(),
                                              applicationName: 'Flutter',
                                              applicationVersion: 'August 2019',
                                              applicationLegalese:
                                                  '\u{a9} 2014 The Flutter Authors',
                                              children: aboutBoxChildren,
                                            );
                                          },
                                      ),
                                      const TextSpan(
                                          text:
                                              ".\n App is totally free and do not contain any advertisements.\n Application do not collect any data.\n As an user of Wake! Wake! you agree with our"),
                                      TextSpan(
                                        text: '\nprivacy policy',
                                        style: const TextStyle(color: Colors.blue),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _launchURL();
                                          },
                                      )
                                    ]))),
                      )
                    ]))));
  }

  _launchURL() async {
    const url = ''; //add privacy policy url
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

_launchURL2() async {
  const url = 'https://flutter.dev'; //add privacy policy url
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

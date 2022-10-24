import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: () {
          run(context);
        }),
      ),
    );
  }
}

InterstitialAd? _ad;
Future<void> run(BuildContext context) async {
  if (_ad != null) {
    _ad!.show();
    return;
  }
  InterstitialAd.load(
      adUnitId: "wrong id",
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdFailedToLoad: (_) {
          print("onAdFailedToLoad $_");
        },
        onAdLoaded: (ad) {
          _ad = ad;
          print("onAdLoaded");
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print(" onAdDismissedFullScreenContent");
              ad.dispose();
              _ad = null;
            },
            onAdFailedToShowFullScreenContent:
                (InterstitialAd ad, AdError error) {
              print("onAdFailedToShowFullScreenContent $error");
            },
          );
        },
      ));
}

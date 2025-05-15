import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdMobService {
  InterstitialAd? _interstitialAd;

  void initialize() {
    MobileAds.instance.initialize();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: "ca-app-pub-3940256099942544/1033173712", // Use test ad unit ID
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          print('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() async {
    print('Showing interstitial ad...');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPurchasedPremium = prefs.getBool('isPurchasedPremium') ?? false;
    bool hasDisabledAds = prefs.getBool('hasDisabledAds') ?? false;

    if (isPurchasedPremium || hasDisabledAds) {
      print('User has purchased premium or disabled ads. Not showing ad.');
      return;
    }

    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null; // Dispose of the ad after showing
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  void dispose() {
    _interstitialAd?.dispose();
  }
}

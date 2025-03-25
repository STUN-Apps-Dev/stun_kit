import 'package:stun_kit/models/advert/interstitial_listener.dart';
import 'package:stun_kit/models/advert/rewarded_listener.dart';

abstract class AdvertService {
  Future<void> init(Map<String, dynamic> params) async {}

  void setUserConsent(bool hasConsent);

  void setInterstitialListener(InterstitialListener listener);

  void setRewardedListener(RewardedListener listener);

  Future<void> loadInterstitialAd(String unitID);

  Future<void> loadRewardedAd(String unitID);

  Future<void> showInterstitialAd(String unitID);

  Future<void> showRewardedAd(String unitID);

  void destroyInterstitial();

  void destroyRewarded();
}

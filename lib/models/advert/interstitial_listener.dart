abstract class InterstitialListener {
  void onInterstitialLoadFailed(String error);

  void onInterstitialLoaded();

  void onInterstitialShowFailed(String error);

  void onInterstitialShown();

  void onInterstitialClosed();

  void onInterstitialClicked();
}

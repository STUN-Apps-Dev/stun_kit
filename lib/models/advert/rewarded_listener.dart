abstract class RewardedListener {
  void onRewardedLoadFailed(String error);

  void onRewardedLoaded();

  void onRewardedShowFailed(String error);

  void onRewardedShown();

  void onRewardedClosed();

  void onRewardedFinished();

  void onRewardedClicked();
}

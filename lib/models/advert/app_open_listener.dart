abstract class AppOpenListener {
  void onAppOpenLoadFailed(String error);

  void onAppOpenLoaded();

  void onAppOpenShowFailed(String error);

  void onAppOpenShown();

  void onAppOpenClosed();

  void onAppOpenClicked();
}

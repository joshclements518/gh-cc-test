/// Release tips baked in at `flutter build web` via `--dart-define`.
class ReleaseInfo {
  const ReleaseInfo._();

  static const uiSha = String.fromEnvironment('UI_SHA', defaultValue: 'unknown');
  static const apiSha = String.fromEnvironment('API_SHA', defaultValue: 'unknown');

  static String short(String sha) =>
      sha.length <= 12 ? sha : sha.substring(0, 12);

  static String get uiShort => short(uiSha);
  static String get apiShort => short(apiSha);
}

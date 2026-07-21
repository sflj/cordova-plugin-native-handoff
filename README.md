# cordova-plugin-native-handoff

A minimal Cordova plugin that writes key-value string pairs to **NSUserDefaults** (iOS) and **SharedPreferences** (Android), so a successor native or Flutter app can read them on first launch without requiring the user to log in again.

## Installation

```bash
cordova plugin add https://github.com/sflj/cordova-plugin-native-handoff.git
```

With a custom Android SharedPreferences file name (see [Configuration](#configuration)):

```bash
cordova plugin add https://github.com/sflj/cordova-plugin-native-handoff.git \
  --variable ANDROID_PREFS_FILE=my_app_handoff
```

Or in `package.json` / `config.xml`:

```json
"cordova-plugin-native-handoff": {
  "ANDROID_PREFS_FILE": "my_app_handoff"
}
```

## Configuration

| Variable | Default | Description |
|---|---|---|
| `ANDROID_PREFS_FILE` | `native_handoff` | Name of the `SharedPreferences` file on Android. Set this to match whatever your Flutter/native app reads from. |

On iOS, `NSUserDefaults.standard` is used — no configuration needed. Because both apps share the same bundle ID (app update scenario), the same standard defaults container is accessible to both.

## API

```typescript
// Store a value
await window.NativeHandoff.set('my_key', 'my_value');

// Remove a value
await window.NativeHandoff.remove('my_key');
```

Both methods return a `Promise<void>` and reject with an error message string on failure.

## Typical usage: Supabase session handoff

Write the session tokens whenever auth state changes, so a Flutter successor app can restore the session without prompting the user to log in again.

```typescript
supabaseService.authChanges(async (event, session) => {
    if (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') {
        await window.NativeHandoff.set('handoff_access_token', session.access_token);
        await window.NativeHandoff.set('handoff_refresh_token', session.refresh_token);
        await window.NativeHandoff.set('handoff_user_id', session.user.id);
    }
    if (event === 'SIGNED_OUT') {
        await window.NativeHandoff.remove('handoff_access_token');
        await window.NativeHandoff.remove('handoff_refresh_token');
        await window.NativeHandoff.remove('handoff_user_id');
    }
});
```

### Reading in Flutter

Flutter's `shared_preferences` uses a `flutter.` key prefix by default. To read keys written by this plugin (which have no prefix), call `setPrefix('')` before accessing preferences:

```dart
SharedPreferences.setPrefix(''); // must be called before getInstance()
final prefs = await SharedPreferences.getInstance();

final accessToken = prefs.getString('handoff_access_token');
final refreshToken = prefs.getString('handoff_refresh_token');

if (accessToken != null && refreshToken != null) {
    await supabase.auth.setSession(accessToken, refreshToken);
    // Clean up after a successful restore
    await prefs.remove('handoff_access_token');
    await prefs.remove('handoff_refresh_token');
}
```

> `setSession` will automatically refresh the access token if it has expired — the refresh token is the important value to carry across.

## Platform notes

- **iOS**: Uses `UserDefaults.standard`. Works out of the box when the Flutter app ships with the same bundle ID (standard app update).
- **Android**: Uses a named `SharedPreferences` file (`MODE_PRIVATE`). The file name is set via the `ANDROID_PREFS_FILE` variable at install time.

## License

MIT

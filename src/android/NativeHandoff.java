package com.plugin.nativehandoff;

import android.content.Context;
import android.content.SharedPreferences;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;

public class NativeHandoff extends CordovaPlugin {

    private String getPrefsFileName() {
        int resId = cordova.getActivity().getResources().getIdentifier(
            "native_handoff_prefs_file", "string",
            cordova.getActivity().getPackageName()
        );
        return cordova.getActivity().getString(resId);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext)
            throws JSONException {

        if ("set".equals(action)) {
            if (args.length() < 2) {
                callbackContext.error("Invalid arguments: key and value required");
                return true;
            }
            String key = args.getString(0);
            String value = args.getString(1);
            SharedPreferences prefs = cordova.getActivity()
                .getSharedPreferences(getPrefsFileName(), Context.MODE_PRIVATE);
            prefs.edit().putString(key, value).apply();
            callbackContext.success();
            return true;
        }

        if ("remove".equals(action)) {
            if (args.length() < 1) {
                callbackContext.error("Invalid arguments: key required");
                return true;
            }
            String key = args.getString(0);
            SharedPreferences prefs = cordova.getActivity()
                .getSharedPreferences(getPrefsFileName(), Context.MODE_PRIVATE);
            prefs.edit().remove(key).apply();
            callbackContext.success();
            return true;
        }

        return false;
    }
}

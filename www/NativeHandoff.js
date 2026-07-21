var exec = require('cordova/exec');

/**
 * Writes key-value string pairs to NSUserDefaults (iOS) or SharedPreferences (Android)
 * so a successor native/Flutter app can read them on first launch.
 */
var NativeHandoff = {
    /**
     * Store a string value under the given key.
     * @param {string} key
     * @param {string} value
     * @returns {Promise<void>}
     */
    set: function (key, value) {
        return new Promise(function (resolve, reject) {
            exec(resolve, reject, 'NativeHandoff', 'set', [key, value]);
        });
    },

    /**
     * Remove the value stored under the given key.
     * @param {string} key
     * @returns {Promise<void>}
     */
    remove: function (key) {
        return new Promise(function (resolve, reject) {
            exec(resolve, reject, 'NativeHandoff', 'remove', [key]);
        });
    },
};

module.exports = NativeHandoff;

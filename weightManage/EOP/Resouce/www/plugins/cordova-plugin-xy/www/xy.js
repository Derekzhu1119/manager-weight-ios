cordova.define("com.derekzhu.plugin.xy",
    function (require, exports, module) {
        var exec = require('cordova/exec');
        exports.share = function (type, url, title, content, image, success, error) {
            exec(success, error, 'xy', 'share', [type, url, title, content, image]);
        };
               
        exports.vibrate = function (time) {
            exec(null, null, 'xy', 'vibrate', [time]);
        };
               
        exports.getPreferredLanguage = function (success, error) {
            exec(success, error, 'xy', 'getPreferredLanguage', []);
        };

        exports.gototab = function (index,success, error) {
            exec(success, error, 'xy', 'gototab', [index]);
        };

        exports.getLoginUserInfo = function (success, error) {
            exec(success, null, 'xy', 'getLoginUserInfo', null);
        };

        exports.getLoginUserInfoAgain = function (success, error) {
            exec(success, null, 'xy', 'getLoginUserInfoAgain', null);
        };

        exports.openWindow = function (url) {
            exec(null, null, 'xy', 'openWindow', [url]);
        };
               
        exports.closeWindow = function () {
            exec(null, null, 'xy', 'closeWindow', null);
        };

        exports.isHideTab = function (isHide) {
            exec(null, null, 'xy', 'isHideTab', [isHide]);
        };

        exports.logout = function () {
            exec(null, null, 'xy', 'logout', null);
        };

        exports.playSound = function () {
            exec(null, null, 'xy', 'playSound', null);
        };

        exports.writeHealthDataToPhone = function (type,count,success, error) {
            exec(success, error, 'xy', 'writeHealthDataToPhone', [type,count]);
        };

    });

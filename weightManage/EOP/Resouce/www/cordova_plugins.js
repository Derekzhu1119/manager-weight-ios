cordova.define('cordova/plugin_list', function(require, exports, module) {
               module.exports = [
                                 {
                                 "id": "cordova-plugin-camera.Camera",
                                 "file": "plugins/cordova-plugin-camera/www/CameraConstants.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "Camera"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.CameraPopoverOptions",
                                 "file": "plugins/cordova-plugin-camera/www/CameraPopoverOptions.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "CameraPopoverOptions"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.camera",
                                 "file": "plugins/cordova-plugin-camera/www/Camera.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "navigator.camera"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.CameraPopoverHandle",
                                 "file": "plugins/cordova-plugin-camera/www/ios/CameraPopoverHandle.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "CameraPopoverHandle"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-device.device",
                                 "file": "plugins/cordova-plugin-device/www/device.js",
                                 "pluginId": "cordova-plugin-device",
                                 "clobbers": [
                                              "device"
                                              ]
                                 },
                                 {
                                 "id": "com.derekzhu.plugin.xy",
                                 "file": "plugins/cordova-plugin-xy/www/xy.js",
                                 "pluginId": "cordova-plugin-xy",
                                 "clobbers": [
                                              "xy"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-wkwebview-engine.ios-wkwebview-exec",
                                 "file": "plugins/cordova-plugin-wkwebview-engine/src/www/ios/ios-wkwebview-exec.js",
                                 "pluginId": "cordova-plugin-wkwebview-engine",
                                 "clobbers": [
                                              "cordova.exec"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-wkwebview-engine.ios-wkwebview",
                                 "file": "plugins/cordova-plugin-wkwebview-engine/src/www/ios/ios-wkwebview.js",
                                 "pluginId": "cordova-plugin-wkwebview-engine",
                                 "clobbers": [
                                              "window.WkWebView"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-secure-storage.SecureStorage",
                                 "file": "plugins/cordova-plugin-secure-storage/www/securestorage.js",
                                 "pluginId": "cordova-plugin-secure-storage",
                                 "clobbers": [
                                              "SecureStorage"
                                              ]
                                 }
                                 ];
               module.exports.metadata = {
               "cordova-plugin-whitelist": "1.3.3",
               "cordova-plugin-camera": "4.0.3",
               "cordova-plugin-device": "2.0.2",
               "cordova-plugin-xy": "1.0",
               "cordova-plugin-wkwebview-engine": "1.1.4",
               "cordova-plugin-secure-storage": "3.0.2"
               };
               });

books_app_viewer_sandbox
========================

Proof of concept app for iOS viewer

+ Require Xcode 7 (beta 3 or later)
+ Written in swift
+ Xcode 7 beta does not support iOS 8.4, use iOS 8.3 or 9.0 beta instead
+ Or you try the following workaround

This might make Xcode 7 beta work with iOS 8.4 devices

````
ln -s /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSup‌​port/8.4\ \(12H141\) /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Devi‌​ceSupport
````

Viewer code
-----------

+ You should place viewer code inside `books_app_viewer_sandbox/viewer`, other files are all owned by App
+ `ViewerBridge.js` is glue file that iOS App will injet into webView during loading, it is not part of viewer
+ Android does not have `ViewerBridge.js`, it is using a different approach
+ Regardless bridge implementation difference between iOS and Android, viewer API is the same

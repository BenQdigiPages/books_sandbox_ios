books_app_viewer_sandbox
========================

Proof of concept app for iOS viewer

+ Require Xcode 7 (beta 4 or later)
+ Written in swift 2.0

Viewer code
-----------

+ You should place viewer code inside `books_app_viewer_sandbox/viewer`, other files are all owned by App
+ `ViewerBridge.js` is glue file that iOS App will injet into webView during loading, it is not part of viewer
+ Android does not have `ViewerBridge.js`, it is using a different approach
+ Regardless bridge implementation difference between iOS and Android, viewer API is the same

books_sandbox_ios
=================

Proof of concept app for iOS viewer

+ Require Xcode 7 (beta 4 or later)
+ Written in swift 2.0
+ Viewer code should be placed into `books_sandbox_ios/viewer`
+ Sample book should be placed into `books_sandbox_ios/book`

Notes
-----

+ All other files are all owned by App
+ `ViewerBridge.js` is glue file that iOS App will inject into webView during loading, it is not part of viewer
+ Android will have different `ViewerBridge.js`, it is platform dependent
+ Regardless bridge implementation difference between iOS and Android, viewer API is the same

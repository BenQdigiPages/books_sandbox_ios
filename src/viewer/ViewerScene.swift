//***************************************************************************
//* Written by Steve Chiu <steve.chiu@benq.com>
//* BenQ Corporation, All Rights Reserved.
//*
//* NOTICE: All information contained herein is, and remains the property
//* of BenQ Corporation and its suppliers, if any. Dissemination of this
//* information or reproduction of this material is strictly forbidden
//* unless prior written permission is obtained from BenQ Corporation.
//***************************************************************************

import UIKit

//---------------------------------------------------------------------------

class ViewerScene : UIViewController, UIWebViewDelegate {
    @IBOutlet weak var bar: UIView!
    @IBOutlet weak var barTitle: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    var viewerUrl: NSURL!
    var bridge: ViewerBridge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        self.bridge = ViewerBridge(scene: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        self.viewerUrl = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "viewer")!
        self.webView.loadRequest(NSURLRequest(URL: self.viewerUrl))

        let uri = "http://fake.benqguru.com/book/"
        ViewerURL = NSURL(string: uri)
        self.bridge.loadBook(uri)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return !self.bridge.dispatchCallback(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView.request?.URL == self.viewerUrl {
            self.bridge.bindCallbacks()
        }
    }

    @IBAction func onTapTOC(sender: AnyObject) {
    }
    
    @IBAction func onTapOptions(sender: AnyObject) {
    }
    
    @IBAction func onTapBookmark(sender: AnyObject) {
    }
}

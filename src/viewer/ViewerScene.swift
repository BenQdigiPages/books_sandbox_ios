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
    
    var bookUrl: NSURL! = NSURL(string: "http://fake.benqguru.com/book/")
    var viewerUrl: NSURL!
    var bridge: ViewerBridge!
    var tableOfContent: JsonArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        self.bridge = ViewerBridge(scene: self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        self.viewerUrl = NSBundle.mainBundle().URLForResource("index", withExtension: "html", subdirectory: "viewer")!
        self.webView.loadRequest(NSURLRequest(URL: self.viewerUrl))
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
  
    func loadBook(url: NSURL) {
        self.bookUrl = url
        ViewerURL = url
        self.bridge.loadBook(url.absoluteString)
    }
  
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return !self.bridge.dispatchCallback(request)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if webView.request?.URL == self.viewerUrl {
            self.bridge.bindCallbacks()
            loadBook(self.bookUrl)
        }
    }

    @IBAction func onTapTOC(sender: AnyObject) {
        let popup = PopoverMenu()
        
        if let toc = self.tableOfContent {
            for i in 0 ..< toc.count {
                if i > 7 {
                    popup.addItem("Too many to show...")
                    break
                }
                
                let item = try! toc.getObject(i)
                var title = item.optString("title") ?? "[unknown]"
                let level = item.optInt("level") ?? 0
                let cfi = item.optString("cfi")
                
                if level > 0 {
                    title = String(count: level * 4, repeatedValue: Character(" ")) + title
                }
                
                if let cfi = cfi {
                    popup.addItem(title) {
                        self.bridge.gotoLink(cfi)
                    }
                } else {
                    popup.addItem(title)
                }
            }
        } else {
            popup.addItem("No table of content")
        }

        popup.show(from: self, anchor: sender)
    }
    
    @IBAction func onTapOptions(sender: AnyObject) {
        let layout = self.bridge.getLayoutMode()!
        
        PopoverMenu()
            .addItem("Font scale +25%") {
                let scale = min((self.bridge.getFontScale() ?? 1.0) + 0.25, 4)
                self.bridge.setFontScale(scale)
            }
            .addItem("Font scale -25%") {
                let scale = max((self.bridge.getFontScale() ?? 1.0) - 0.25, 0.25)
                self.bridge.setFontScale(scale)
            }
            .addItem("background: [128, 128, 128]") {
                self.bridge.setBackgroundColor(UIColor(r: 128, g: 128, b: 128))
            }
            .addItem("background: [255, 255, 255]") {
                self.bridge.setBackgroundColor(UIColor(r: 255, g: 255, b: 255))
            }
            .addItem("mode: single", checked: layout == .Single) {
                self.bridge.setLayoutMode(.Single)
            }
            .addItem("mode: side_y_side", checked: layout == .SideBySide) {
                self.bridge.setLayoutMode(.SideBySide)
            }
            .addItem("mode: continuous", checked: layout == .Continuous) {
                self.bridge.setLayoutMode(.Continuous)
            }
            .show(from: self, anchor: sender)
    }
    
    @IBAction func onTapBookmark(sender: AnyObject) {
        PopoverMenu()
            .addItem("[255, 0, 0]") {
                self.bridge.toggleBookmark(UIColor(r: 255, g: 0, b: 0))
            }
            .addItem("[0, 255, 0]") {
                self.bridge.toggleBookmark(UIColor(r: 0, g: 255, b: 0))
            }
            .addItem("[0, 0, 255]") {
                self.bridge.toggleBookmark(UIColor(r: 0, g: 0, b: 255))
            }
            .addItem("Remove") {
                self.bridge.toggleBookmark(nil)
            }
            .show(from: self, anchor: sender)
    }
}

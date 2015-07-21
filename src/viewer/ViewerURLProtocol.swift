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
import MobileCoreServices

var ViewerURL: NSURL?

//---------------------------------------------------------------------------

class ViewerURLProtocol : NSURLProtocol {

    override class func canInitWithRequest(request: NSURLRequest) -> Bool {
        if let base_url = ViewerURL?.absoluteString, url = request.URL?.absoluteString {
            return url.hasPrefix(base_url)
        }
        return false
    }
    
    override class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
    }
     
    override class func requestIsCacheEquivalent(request: NSURLRequest, toRequest: NSURLRequest) -> Bool {
        return super.requestIsCacheEquivalent(request, toRequest: toRequest)
    }
     
    override func startLoading() {
        let client = self.client!

        guard let path = self.request.URL?.path?.substring(ViewerURL?.path?.length ?? 0) else {
            client.URLProtocol(self, didFailWithError: NSError(domain: "err.protocol"))
            return
        }
        
        guard let book = NSBundle.mainBundle().URLForResource("book", withExtension: "") else {
            client.URLProtocol(self, didFailWithError: NSError(domain: "err.path"))
            return
        }
        
        let UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, path.pathExtension, nil)!
        let UTIMimeType = UTTypeCopyPreferredTagWithClass(UTI.takeUnretainedValue(), kUTTagClassMIMEType)
        let mimeType = (UTIMimeType?.takeUnretainedValue() ?? "application/octet-stream") as String
        
        let fileUrl = book.URLByAppendingPathComponent(path)
        let data = NSData(contentsOfFile: fileUrl.path!)!
        
        let headers: [String: String] = [
            "Access-Control-Allow-Origin": "*",
            "Content-Type": mimeType,
            "Content-Length": "\(data.length)",
            "Cache-Control": "no-cache",
        ]
 
        let response = NSHTTPURLResponse(URL: self.request.URL!, statusCode: 200, HTTPVersion: "1.1", headerFields: headers)!
        
        client.URLProtocol(self, didReceiveResponse: response, cacheStoragePolicy: .NotAllowed)
        client.URLProtocol(self, didLoadData: data)
        client.URLProtocolDidFinishLoading(self)
    }
     
    override func stopLoading() {
        // do nothing
    }
}

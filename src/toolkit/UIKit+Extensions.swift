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
// MARK: - Color utils

public extension UIColor {
    public convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    public convenience init(rgb888: UInt32) {
        self.init(r: Int((rgb888 >> 16) & 0xff), g: Int((rgb888 >> 8) & 0xff), b: Int(rgb888 & 0xff))
    }
    
    public convenience init?(hexString value: String) {
        if value.hasPrefix("#") {
            let len = value.characters.count
            if len == 7 {
                if let r = Int(value[1...2], radix: 16),
                       g = Int(value[3...4], radix: 16),
                       b = Int(value[5...6], radix: 16) {
                    self.init(r: r, g: g, b: b)
                    return
                }
            } else if len == 9 {
                if let a = Int(value[1...2], radix: 16),
                       r = Int(value[3...4], radix: 16),
                       g = Int(value[5...6], radix: 16),
                       b = Int(value[7...8], radix: 16) {
                    self.init(r: r, g: g, b: b, a: a)
                    return
                }
            }
        }
        return nil
    }
    
    public var rgba: (r: Int, g: Int, b: Int, a: Int) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r: Int(r * 255), g: Int(g * 255), b: Int(b * 255), a: Int(a * 255))
    }

    public var rgb: (r: Int, g: Int, b: Int) {
        let (r, g, b, _) = self.rgba
        return (r: r, g: g, b: b)
    }

    public var rgb888: UInt32 {
        let (r, g, b, _) = self.rgba
        return UInt32((r << 16) | (g << 8) | b)
    }

    public func toHexString() -> String {
        let (r, g, b, a) = self.rgba
        if a == 255 {
            return String(format: "#%02X%02X%02X", r, g, b)
        } else {
            return String(format: "#%02X%02X%02X%02X", a, r, g, b)
        }
    }
}

//---------------------------------------------------------------------------

@objc(UIColorTransformer)
public class UIColorTransformer : NSValueTransformer {
    public override class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }

    public override class func allowsReverseTransformation() -> Bool {
        return true
    }

    public override func transformedValue(value: AnyObject?) -> AnyObject? {
        if let color = value as? UIColor {
            return color.toHexString()
        }
        return nil
    }
    
    public override func reverseTransformedValue(value: AnyObject?) -> AnyObject? {
        if let hex = value as? String {
            return UIColor(hexString: hex)
        }
        return nil
    }
}

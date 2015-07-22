//***************************************************************************
//* Written by Steve Chiu <steve.chiu@benq.com>
//* BenQ Corporation, All Rights Reserved.
//*
//* NOTICE: All information contained herein is, and remains the property
//* of BenQ Corporation and its suppliers, if any. Dissemination of this
//* information or reproduction of this material is strictly forbidden
//* unless prior written permission is obtained from BenQ Corporation.
//***************************************************************************

import Foundation

//---------------------------------------------------------------------------
// MARK: - Locking utils

public func synchronized(lock: AnyObject, @noescape _ block: () -> Void) {
    objc_sync_enter(lock)
    block()
    objc_sync_exit(lock)
}

public func synchronized(lock: NSLocking, @noescape _ block: () -> Void) {
    lock.lock()
    block()
    lock.unlock()
}

public func synchronized<T>(lock: AnyObject, @noescape _ block: () -> T) -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return block()
}

public func synchronized<T>(lock: NSLocking, @noescape _ block: () -> T) -> T {
    lock.lock()
    defer { lock.unlock() }
    return block()
}

public func synchronized(lock: AnyObject, @noescape _ block: () throws -> Void) throws {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try block()
}

public func synchronized(lock: NSLocking, @noescape _ block: () throws -> Void) throws {
    lock.lock()
    defer { lock.unlock() }
    return try block()
}

public func synchronized<T>(lock: AnyObject, @noescape _ block: () throws -> T) throws -> T {
    objc_sync_enter(lock)
    defer { objc_sync_exit(lock) }
    return try block()
}

public func synchronized<T>(lock: NSLocking, @noescape _ block: () throws -> T) throws -> T {
    lock.lock()
    defer { lock.unlock() }
    return try block()
}

//---------------------------------------------------------------------------
// MARK: - String utils

public extension String {
    public var length: Int {
        return self.characters.count
    }
    
    public subscript(r: Range<Int>) -> String {
        let startIndex = advance(self.startIndex, r.startIndex)
        let endIndex = advance(self.startIndex, r.endIndex)
        return self[startIndex ..< endIndex]
    }
    
    public func substring(start: Int, length: Int) -> String {
        let startIndex = advance(start >= 0 ? self.startIndex : self.endIndex, start)
        let endIndex = advance(startIndex, length)
        return self[startIndex ..< endIndex]
    }

    public func substring(start: Int) -> String {
        let startIndex = advance(start >= 0 ? self.startIndex : self.endIndex, start)
        return self[startIndex ..< self.endIndex]
    }
}

public func + (left: String.Index, right: Int) -> String.Index {
    return advance(left, right)
}

public func - (left: String.Index, right: Int) -> String.Index {
    return advance(left, -right)
}

//---------------------------------------------------------------------------
// MARK: - Error utils

public extension NSError {
    public convenience init(domain: String, code: Int = 0, reason: String? = nil) {
        if let reason = reason {
            self.init(domain: domain, code: code, userInfo: ["reason": reason])
        } else {
            self.init(domain: domain, code: code, userInfo: nil)
        }
    }
    
    public var reason: String? {
        return self.userInfo["reason"] as? String
    }
}

//---------------------------------------------------------------------------
// MARK: - Date utils

private let _dateFormat: NSDateFormatter = {
    let fmt = NSDateFormatter()
    fmt.dateFormat = "yyyy-MM-dd"
    return fmt
}()

private let _timeFormat: NSDateFormatter = {
    let fmt = NSDateFormatter()
    fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    return fmt
}()

public extension NSDate {
    public convenience init?(iso8601 value: String) {
        guard let time = _timeFormat.dateFromString(value) ?? _dateFormat.dateFromString(value) else {
            return nil
        }
        self.init(timeIntervalSinceReferenceDate: time.timeIntervalSinceReferenceDate)
    }

    public func toIso8601() -> String {
        return _timeFormat.stringFromDate(self)
    }
}

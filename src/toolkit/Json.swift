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

public protocol JsonConvertible {
    typealias JsonIndex
    typealias JsonValue
    
    var value: Self.JsonValue { get }
    init(value: Self.JsonValue)

    func get(key: Self.JsonIndex) throws -> AnyObject
    func opt(key: Self.JsonIndex) -> AnyObject?
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getBool(key: Self.JsonIndex) throws -> Bool {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.boolValue
        } else if let value = value as? NSString {
            return value.boolValue
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to Bool")
        }
    }

    public func optBool(key: Self.JsonIndex) -> Bool? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.boolValue
        } else if let value = value as? NSString {
            return value.boolValue
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getInt(key: Self.JsonIndex) throws -> Int {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.integerValue
        } else if let value = value as? NSString {
            return value.integerValue
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to Int")
        }
    }
    
    public func optInt(key: Self.JsonIndex) -> Int? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.integerValue
        } else if let value = value as? NSString {
            return value.integerValue
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getInt32(key: Self.JsonIndex) throws -> Int32 {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.intValue
        } else if let value = value as? NSString {
            return value.intValue
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to Int")
        }
    }
    
    public func optInt32(key: Self.JsonIndex) -> Int32? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.intValue
        } else if let value = value as? NSString {
            return value.intValue
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getInt64(key: Self.JsonIndex) throws -> Int64 {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.longLongValue
        } else if let value = value as? NSString {
            return value.longLongValue
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to Int")
        }
    }
    
    public func optInt64(key: Self.JsonIndex) -> Int64? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.longLongValue
        } else if let value = value as? NSString {
            return value.longLongValue
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getFloat(key: Self.JsonIndex) throws -> Float {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.floatValue
        } else if let value = value as? NSString {
            return value.floatValue
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to Float")
        }
    }
    
    public func optFloat(key: Self.JsonIndex) -> Float? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.floatValue
        } else if let value = value as? NSString {
            return value.floatValue
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getDouble(key: Self.JsonIndex) throws -> Double {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.doubleValue
        } else if let value = value as? NSString {
            return value.doubleValue
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to Double")
        }
    }
    
    public func optDouble(key: Self.JsonIndex) -> Double? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.doubleValue
        } else if let value = value as? NSString {
            return value.doubleValue
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getNumber(key: Self.JsonIndex) throws -> NSNumber {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value
        } else if let string = value as? String,
                  let number = NSNumberFormatter().numberFromString(string) {
            return number
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to NSNumber")
        }
    }
    
    public func optNumber(key: Self.JsonIndex) -> NSNumber? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value
        } else if let string = value as? String {
            return NSNumberFormatter().numberFromString(string)
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getString(key: Self.JsonIndex) throws -> String {
        let value = try get(key)
        if let value = value as? NSNumber {
            return value.stringValue
        } else if let value = value as? String {
            return value
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to String")
        }
    }

    public func optString(key: Self.JsonIndex) -> String? {
        let value = opt(key)
        if let value = value as? NSNumber {
            return value.stringValue
        } else if let value = value as? String {
            return value
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getObject(key: Self.JsonIndex) throws -> JsonObject {
        let value = try get(key)
        if let value = value as? [String: AnyObject] {
            return JsonObject(value: value)
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to JsonObject")
        }
    }

    public func optObject(key: Self.JsonIndex) -> JsonObject? {
        let value = opt(key)
        if let value = value as? [String: AnyObject] {
            return JsonObject(value: value)
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getArray(key: Self.JsonIndex) throws -> JsonArray {
        let value = try get(key)
        if let value = value as? [AnyObject] {
            return JsonArray(value: value)
        } else {
            throw NSError(domain: "err.json", reason: "key[\(key)] can not convert to JsonArray")
        }
    }

    public func optArray(key: Self.JsonIndex) -> JsonArray? {
        let value = opt(key)
        if let value = value as? [AnyObject] {
            return JsonArray(value: value)
        } else {
            return nil
        }
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getTime(key: Self.JsonIndex) throws -> NSDate {
        let value = try getString(key)
        guard let time = NSDate(iso8601: value) else {
            throw NSError(domain: "err.json", reason: "key[\(key)] (\(value)) is not ISO8601 format")
        }
        return time
   }

    public func optTime(key: Self.JsonIndex) -> NSDate? {
        guard let value = optString(key) else {
            return nil
        }
        return NSDate(iso8601: value)
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public func getColor(key: Self.JsonIndex) throws -> UIColor {
        let value = try getString(key)
        guard let color = UIColor(hexString: value) else {
            throw NSError(domain: "err.json", reason: "key[\(key)] (\(value)) is not color format")
        }
        return color
    }

    public func optColor(key: Self.JsonIndex) -> UIColor? {
        guard let value = optString(key) else {
            return nil
        }
        return UIColor(hexString: value)
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public init(data: NSData, options: NSJSONReadingOptions = .AllowFragments) throws {
        let value = try NSJSONSerialization.JSONObjectWithData(data, options: options)
        guard let obj = value as? Self.JsonValue else {
            throw NSError(domain: "err.json", reason: "invalid json value")
        }
        self.init(value: obj)
    }

    public init(string: String, options: NSJSONReadingOptions = .AllowFragments) throws {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)!
        try self.init(data: data, options: options)
    }

    public func toData(options: NSJSONWritingOptions = []) throws -> NSData {
        return try NSJSONSerialization.dataWithJSONObject(self.value as! AnyObject, options: options)
    }

    public func toString(options: NSJSONWritingOptions = .PrettyPrinted) throws -> String {
        let data = try toData(options)
        return NSString(data: data, encoding: NSUTF8StringEncoding)! as String
    }
}

//---------------------------------------------------------------------------

public extension JsonConvertible {
    public var description: String {
        do {
            return try toString(.PrettyPrinted)
        } catch {
            return "\(self.value)"
        }
    }

    public var debugDescription: String {
        return self.description
    }
}

//---------------------------------------------------------------------------

private func normalizeArray(elements: [Any]) -> [AnyObject] {
    var list = [AnyObject]()
    for item in elements {
        list.append(normalizeValue(item))
    }
    return list
}

private func normalizeDictionary(elements: [String: Any]) -> [String: AnyObject] {
    var map = [String: AnyObject]()
    for (k, v) in elements {
        map[k] = normalizeValue(v)
    }
    return map
}

private func normalizeValue(value: Any) -> AnyObject {
    if let v = value as? JsonObject {
        return v.value
    } else if let v = value as? JsonArray {
        return v.value
    } else if let v = value as? NSDate {
        return v.toIso8601()
    } else if let v = value as? UIColor {
        return v.toHexString()
    } else if let v = value as? [String: AnyObject] {
        return normalizeDictionary(v)
    } else if let v = value as? [AnyObject] {
        return normalizeArray(v)
    } else if let v = value as? AnyObject {
        return v
    } else {
        return "\(value)"
    }
}

//---------------------------------------------------------------------------

public struct JsonObject : JsonConvertible,
        Swift.DictionaryLiteralConvertible, Swift.Printable, Swift.DebugPrintable {
    private var _map: [String: AnyObject]

    public var value: [String: AnyObject] {
        return _map
    }

    public init() {
        _map = [String: AnyObject]()
    }

    public init(value: [String: AnyObject]) {
        _map = value
    }
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        _map = [String: AnyObject](minimumCapacity: elements.count)
        for (k, v) in elements {
            _map[k] = normalizeValue(v)
        }
    }

    public subscript(key: String) -> Any? {
        get {
            return _map[key]
        }
        set {
            _map[key] = normalizeValue(newValue ?? NSNull())
        }
    }
    
    public var isEmpty: Bool {
        return _map.isEmpty
    }
    
    public var count: Int {
        return _map.count
    }
    
    public func has(key: String) -> Bool {
        return _map[key] != nil
    }
    
    public var keys: LazyForwardCollection<MapCollection<[String : AnyObject], String>> {
        return _map.keys
    }
    
    public mutating func removeValueForKey(key: String) -> AnyObject? {
        return _map.removeValueForKey(key)
    }
    
    public mutating func removeAll() {
        _map.removeAll()
    }
    
    public func opt(key: String) -> AnyObject? {
        return _map[key]
    }
    
    public func get(key: String) throws -> AnyObject {
        guard let value = _map[key] else {
            throw NSError(domain: "err.json", reason: "key[\(key)] not found")
        }
        return value
    }
}

//---------------------------------------------------------------------------

public struct JsonArray : JsonConvertible,
        Swift.ArrayLiteralConvertible, Swift.Printable, Swift.DebugPrintable {
    private var _list: [AnyObject]

    public var value: [AnyObject] {
        return _list
    }

    public init() {
        _list = [AnyObject]()
    }

    public init(value: [AnyObject]) {
        _list = value
    }
    
    public init(arrayLiteral elements: Any...) {
        _list = normalizeArray(elements)
    }

    public subscript(key: Int) -> Any? {
        get {
            return _list[key]
        }
        set {
            _list[key] = normalizeValue(newValue ?? NSNull())
        }
    }
    
    public var isEmpty: Bool {
        return _list.isEmpty
    }
    
    public var count: Int {
        return _list.count
    }
    
    public mutating func append(value: Any) {
        _list.append(normalizeValue(value))
    }
    
    public mutating func insert(value: Any, atIndex i: Int) {
        _list.insert(normalizeValue(value), atIndex: i)
    }
    
    public mutating func removeAtIndex(key: Int) -> AnyObject? {
        return _list.removeAtIndex(key)
    }
    
    public mutating func removeAll() {
        return _list.removeAll()
    }

    public func opt(key: Int) -> AnyObject? {
        return key >= 0 && key < _list.count ? _list[key] : nil
    }
    
    public func get(key: Int) throws -> AnyObject {
        return _list[key]
    }
}

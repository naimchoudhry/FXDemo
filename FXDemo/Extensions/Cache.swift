//
//  SwiftCache.swift
//  FXDemo
//
//  Created by Naim on 22/01/2022.
//
// Wrappper around NSCache for Swift use

import Foundation

final class Cache<Key: Hashable, Value> {

    private let cache = NSCache<KeyWrapper, CacheEntry>()

    private final class CacheEntry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
    
    private final class KeyWrapper: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }
        
        override var hash: Int { key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? KeyWrapper else { return false }
            return value.key == key
        }
    }
}

extension Cache {
    func insert(_ value: Value, forKey key: Key) {
        let entry = CacheEntry(value: value)
        cache.setObject(entry, forKey: KeyWrapper(key))
    }

    func value(forKey key: Key) -> Value? {
        guard let entry = cache.object(forKey: KeyWrapper(key)) else { return nil }
        return entry.value
    }

    func removeValue(forKey key: Key) {
        cache.removeObject(forKey: KeyWrapper(key))
    }
    
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

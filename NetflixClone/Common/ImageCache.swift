//
//  ImageCache.swift
//  NetflixClone
//
//  Created by 강동영 on 7/23/24.
//

import UIKit.UIImage

protocol Cache {
    associatedtype Key: Hashable
    associatedtype Value
    subscript(key: Key) -> Value? { get set }
    func removeAll()
}

final class ImageCache: Cache {
    static let shaerd: ImageCache = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    subscript(key: String) -> UIImage? {
        get {
            return cache.object(forKey: key as NSString) }
        set {
            guard let value = newValue else {
                cache.removeObject(forKey: key as NSString)
                return
            }
            cache.setObject(value, forKey: key as NSString) }
    }
    
//    private init() {}
    func removeAll() {
        cache.removeAllObjects()
    }
}

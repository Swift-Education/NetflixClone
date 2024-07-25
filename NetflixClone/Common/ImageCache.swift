//
//  ImageCache.swift
//  NetflixClone
//
//  Created by 강동영 on 7/23/24.
//

import UIKit.UIImage

protocol CacheProtocol {
    func store(_ image: UIImage, forKey key: String)
    func retrieve(forKey key: String) -> UIImage?
    func remove(forKey key: String)
    func removeAll()
}

final class ImageCache: CacheProtocol {
    static let shaerd: ImageCache = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()
//    private let diskCache = DiskCache()
    
    func store(_ image: UIImage, forKey key: String) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
    
    func retrieve(forKey key: String) -> UIImage? {
        return memoryCache.object(forKey: key as NSString)
    }
    
    func remove(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
    }
    
    func removeAll() {
        memoryCache.removeAllObjects()
    }
}

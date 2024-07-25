//
//  DiskCache.swift
//  NetflixClone
//
//  Created by 강동영 on 7/25/24.
//

import UIKit.UIImage

protocol DiskCacheProtocol: CacheProtocol {
    var maximumCapacity: Int { get }
}

final class DiskCache: DiskCacheProtocol {
    private let fileManager: FileManager
    private let cacheDirectoryURL: URL
    var maximumCapacity: Int
    
    init(fileManager: FileManager = .default, maximumCapacity: Int = 1024 * 1024 * 100) {
        self.fileManager = fileManager
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        cacheDirectoryURL = cacheDirectory.appendingPathComponent("DiskImageCache")
        if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true)
        }
        self.maximumCapacity = maximumCapacity
    }
    
    func store(_ image: UIImage, forKey key: String) {
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
    }
    
    func retrieve(forKey key: String) -> UIImage? {
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    func remove(forKey key: String) {
        let fileURL = cacheDirectoryURL.appendingPathComponent(key)
        try? fileManager.removeItem(at: fileURL)
    }
    
    func removeAll() {
        try? fileManager.contentsOfDirectory(at: cacheDirectoryURL, includingPropertiesForKeys: nil).forEach {
            try fileManager.removeItem(at: $0)
        }
    }
}

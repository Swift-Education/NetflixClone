//
//  NBCWrapper.swift
//  NetflixClone
//
//  Created by 강동영 on 7/25/24.
//

import UIKit

public struct NBCWrapper<Base> {
    typealias NBCImageView = UIImageView
    public let base: Base
    private let imageCache = ImageCache.shared
    public init(_ base: Base) {
        self.base = base
    }
}

extension NBCWrapper where Base: NBCImageView {
    func setImage(path: String) {
        // do something
        cache(with: path) { self.base.image = $0 }
    }
    
    private func cache(with path: String, completion: @escaping ((UIImage) -> Void)) {
        // 4. 없는 경우, URLString으로 이미지를 네트워크 다운로드
        if let image = imageCache.retrieve(forKey: path) {
            completion(image)
        } else {
            let urlString = "https://image.tmdb.org/t/p/w500/\(path).jpg"
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.sync {
                            // 5. 메모리 캐시와 디스크 캐시에 해당 이미지를 저장
                            self.imageCache.store(image, forKey: path)
                            completion(image)
                        }
                    }
                }
            }
        }
    }
}
extension UIImageView: NBCCompatible {}
public protocol NBCCompatible: AnyObject { }

extension NBCCompatible {
    /// Gets a namespace holder for Kingfisher compatible types.
    public var nbc: NBCWrapper<Self> {
        get { return NBCWrapper(self) }
        set { }
    }
}

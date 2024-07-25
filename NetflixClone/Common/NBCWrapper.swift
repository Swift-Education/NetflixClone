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
        self.base.image = imageCache.retrieve(forKey: path)
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

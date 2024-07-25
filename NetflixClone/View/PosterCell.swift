//
//  PosterCell.swift
//  NetflixClone
//
//  Created by 강동영 on 7/22/24.
//

import UIKit

class PosterCell: UICollectionViewCell {
    static let id = "PosterCell"
    private let imageCache = ImageCache.shared
    private let diskCache = DiskCache()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(with movie: Movie) {
        guard let posterPath = movie.posterPath else { return }
        print("posterPath: \(posterPath)")
//        cacheByDisk(with: posterPath)
//        cache(with: posterPath)
        self.imageView.nbc.setImage(path: posterPath)
    }
    
    func cache(with path: String) {
        // 4. 없는 경우, URLString으로 이미지를 네트워크 다운로드
        if let image = imageCache.retrieve(forKey: path) {
            print("cache hit")
            self.imageView.image = image
        } else {
            print("cache miss")
            let urlString = "https://image.tmdb.org/t/p/w500/\(path).jpg"
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.sync {
                            // 5. 메모리 캐시와 디스크 캐시에 해당 이미지를 저장
                            self?.imageCache.store(image, forKey: path)
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    func cacheByDisk(with path: String) {
        if let image = diskCache.retrieve(forKey: path) {
            print("cache hit")
            self.imageView.image = image
        } else {
            print("cache miss")
            
        
            let urlString = "https://image.tmdb.org/t/p/w500/\(path).jpg"
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.sync {
                            self?.diskCache.store(image, forKey: path)
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}


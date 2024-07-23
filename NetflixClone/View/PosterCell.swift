//
//  PosterCell.swift
//  NetflixClone
//
//  Created by 강동영 on 7/22/24.
//

import UIKit

class PosterCell: UICollectionViewCell {
    static let id = "PosterCell"
    private let imageCache = ImageCache.shaerd
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
        if let image = imageCache[posterPath] {
            print("cache hit")
            self.imageView.image = image
        } else {
            print("cache miss")
            let urlString = "https://image.tmdb.org/t/p/w500/\(posterPath).jpg"
            guard let url = URL(string: urlString) else { return }
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.sync {
                            self?.imageCache[posterPath] = image
                            self?.imageView.image = image
                        }
                    }
                }
            }
        }
    }
}


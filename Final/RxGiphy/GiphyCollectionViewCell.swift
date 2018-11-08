//
//  GiphyCollectionViewCell.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class GiphyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    func configure(with giphy: Giphy) {
        titleLabel.text = giphy.title
        ratingLabel.text = giphy.rating.flatMap{ String(describing: $0.description) } ?? "Unrated"
        sizeLabel.text = giphy.images.original.sizeDescription
        GifCache.shared.image(for: giphy.images.fixedHeight.url) { [weak self] result in
            switch result {
            case .success(let image, let downloadedURL):
                guard downloadedURL == giphy.images.fixedHeight.url else {
                    return
                }
                DispatchQueue.main.async {
                    self?.gifImageView.image = image
                }
            case .failure:
                break
            }
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        gifImageView.image = nil
    }
}

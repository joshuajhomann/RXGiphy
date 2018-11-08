//
//  GiphyDetailViewController.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class GiphyDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var copiedView: UIView!
    var giphy: Giphy?
    private let coordinator: Coordinator
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: GiphyDetailViewController.name, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        giphy.flatMap { configure(with: $0) }
    }

    func configure(with giphy: Giphy) {
        navigationItem.title = giphy.title
        titleLabel.text = giphy.title
        ratingLabel.text = giphy.rating.flatMap{ String(describing: $0.description) } ?? "Unrated"
        sizeLabel.text = giphy.images.original.sizeDescription
        GifCache.shared.image(for: giphy.images.fixedHeight.url) { [weak self] result in
            switch result {
            case .success(let image, _):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    @IBAction private func copyToClipBoard(_ sender: Any) {
        guard let urlString = giphy?.images.original.url.absoluteString else {
            return
        }
        UIPasteboard.general.string = urlString
        copiedView.isHidden = false
        UIView.animate(withDuration: 1, animations: {
            self.copiedView.alpha = 0
        }, completion: {_ in
            self.copiedView.isHidden = true
            self.copiedView.alpha = 1
        })
    }

    @IBAction private func tap(_ sender: Any) {
        coordinator.handle(.closeDetail)
    }

}

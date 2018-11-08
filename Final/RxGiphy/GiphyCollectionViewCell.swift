//
//  GiphyCollectionViewCell.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action

class GiphyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    var viewModel: GiphyCellViewModel?
    private var disposeBag: DisposeBag?
    func configure(with viewModel: GiphyCellViewModel) {
        let disposeBag = DisposeBag()
        viewModel.titleDriver.drive(titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.ratingDriver.drive(ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.ratingColorDriver.drive(onNext: { [ratingLabel] color in
            ratingLabel?.textColor = color
        }).disposed(by: disposeBag)
        viewModel.sizeDriver.drive(sizeLabel.rx.text).disposed(by: disposeBag)
        viewModel.gifDriver.drive(gifImageView.rx.image).disposed(by: disposeBag)
        self.viewModel = viewModel
        self.disposeBag = disposeBag
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
        viewModel = nil
    }

}

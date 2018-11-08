//
//  GiphyCellViewModel.swift
//  RxGiphy
//
//  Created by Joshua Homann on 11/3/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit.UIColor
import UIKit.UIImage
import RxSwift
import RxCocoa
import Action

struct GiphyCellViewModel {
    let gifDriver: Driver<UIImage>
    let titleDriver: Driver<String>
    let ratingDriver: Driver<String>
    let ratingColorDriver: Driver<UIColor>
    let sizeDriver: Driver<String>
    let selectAction: CocoaAction
    init(coordinator: CoordinatorProtocol, gifCacheService: GifCacheServiceProtocol, giphy: Giphy) {
        gifDriver = gifCacheService.image(for: giphy.images.fixedHeight.url).asDriver(onErrorJustReturn: UIImage())
        titleDriver = .just(giphy.title)
        ratingDriver = .just(giphy.rating.flatMap { $0.description } ?? "Unrated")
        ratingColorDriver = .just(giphy.rating == .g ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : .black)
        sizeDriver = .just(ByteCountFormatter.fileSizeFormatter.string(fromByteCount: Int64(giphy.images.original.size)))
        selectAction = CocoaAction {
            .create { observer in
                DispatchQueue.main.async{
                    coordinator.handle(.showDetail(giphy))
                }
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}

//
//  GiphyDetailViewModel.swift
//  RxGiphy
//
//  Created by Joshua Homann on 11/5/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

struct GiphyDetailViewModel {
    let gifDriver: Driver<UIImage>
    let titleDriver: Driver<String>
    let ratingDriver: Driver<String>
    let sizeDriver: Driver<String>
    let copyAction: CocoaAction
    let closeAction: CocoaAction
    init(coordinator: CoordinatorProtocol, gifCacheService: GifCacheServiceProtocol, giphy: Giphy) {
        gifDriver =  gifCacheService.image(for: giphy.images.fixedHeight.url).asDriver(onErrorJustReturn: UIImage())
        titleDriver = .just(giphy.title)
        ratingDriver = .just(giphy.rating.flatMap { $0.description } ?? "Unrated")
        sizeDriver = .just(ByteCountFormatter.fileSizeFormatter.string(fromByteCount: Int64(giphy.images.original.size)))
        copyAction = CocoaAction {
            .create { observer in
                UIPasteboard.general.string = giphy.images.original.url.absoluteString
                observer.onNext(())
                observer.onCompleted()
                return Disposables.create()
            }
        }
        closeAction = CocoaAction {
            .create { _ in
                DispatchQueue.main.async{
                    coordinator.handle(.closeDetail)
                }
                return Disposables.create()
            }
        }
    }
}


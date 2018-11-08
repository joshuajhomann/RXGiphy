//
//  GifCacheService.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift

protocol GifCacheServiceProtocol {
    func image(for url: URL) -> Observable<UIImage>
}

final class GifCacheService: GifCacheServiceProtocol {
    private let cache = NSCache<NSURL, UIImage>()
    func image(for url: URL) -> Observable<UIImage> {
        guard let image = cache.object(forKey: url as NSURL) else {
            return Observable<UIImage>.create { [cache] observer in
                DispatchQueue.global(qos: .userInitiated).async { [cache] in
                    guard let image = UIImage.gif(url: url.absoluteString) else {
                        observer.onError(NSError())
                        return
                    }
                    cache.setObject(image, forKey: url as NSURL)
                    observer.onNext(image)
                    observer.onCompleted()
                }
                return Disposables.create()
            }
        }
        return Observable.just(image)
    }
}

final class MockGifCacheService: GifCacheServiceProtocol {
    var image = UIImage()
    func image(for url: URL) -> Observable<UIImage> {
        return .just(image)
    }
}


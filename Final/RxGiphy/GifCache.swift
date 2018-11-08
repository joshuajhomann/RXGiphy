//
//  GifCache.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift

class GifCache {
    enum Result {
        case success(UIImage, URL), failure (Error)
    }
    static let shared = GifCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() { }
    func image(for url: URL, completion: @escaping (Result) -> ()) {
        guard let image = cache.object(forKey: url as NSURL) else {
            DispatchQueue.global(qos: .userInitiated).async { [cache] in
                guard let image = UIImage.gif(url: url.absoluteString) else {
                    completion(.failure(NSError()))
                    return
                }
                cache.setObject(image, forKey: url as NSURL)
                completion(.success(image, url))
            }
            return
        }
        completion(.success(image, url))
    }
}

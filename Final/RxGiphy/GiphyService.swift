//
//  GiphyService.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol GiphyServiceProtocol {
    func getSearchResults(term: String, page: Int) -> Observable<GiphyPage>
}


struct GiphyService: GiphyServiceProtocol {
    enum APIError: Error {
        case invalidRequest
    }

    private static let baseUrl = "https://api.giphy.com/v1/gifs/"
    private static let requiredQueryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: "dc6zaTOxFJmzC")]
    private static let pageSize = 25
    private func get<Decoded: Decodable>(_ type: Decodable.Type, from path: String, parameters: [URLQueryItem] = []) -> Observable<Decoded> {
        return Observable<URLRequest>.create { observer in
            guard var components = URLComponents(string: "\(GiphyService.baseUrl)\(path)") else {
                observer.onError(APIError.invalidRequest)
                return Disposables.create()
            }
            components.queryItems = GiphyService.requiredQueryItems + parameters
            guard let request = components.url.flatMap({ URLRequest(url: $0) }) else {
                observer.onError(APIError.invalidRequest)
                return Disposables.create()
            }
            observer.onNext(request)
            observer.onCompleted()
            return Disposables.create()
        }.flatMapLatest {
            return URLSession.shared.rx.data(request: $0).map {try JSONDecoder().decode(Decoded.self, from: $0) }
        }
    }

    func getSearchResults(term: String, page: Int) -> Observable<GiphyPage> {
        let path = "search"
        let parameters: [URLQueryItem]  = [
            URLQueryItem(name:"q", value: term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "random"),
            URLQueryItem(name:"offset", value: (GiphyService.pageSize * page).description),
            URLQueryItem(name:"limit", value: GiphyService.pageSize.description)
        ]
        return get(GiphyPage.self, from: path, parameters: parameters)
    }
}

class MockAPIService {
    let giphies: [Giphy]?
    init(giphies: [Giphy]?) {
        self.giphies = giphies
    }

    func getSearchResults(term: String, page: Int) -> Observable<GiphyPage> {
        guard let giphies = giphies else {
            return  .error(APIError.invalidRequest)
        }
        return .just(GiphyPage(data: giphies))
    }
}


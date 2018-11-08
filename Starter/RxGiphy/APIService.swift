//
//  APIService.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/16/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


enum APIResult<T> {
    case success(T)
    case failure(Error)
}
enum APIError: Error {
    case invalidRequest
}

class APIService {
    static let baseUrl = "https://api.giphy.com/v1/gifs/"
    static let requiredQueryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: "dc6zaTOxFJmzC")]
    static let pageSize = 25

    private static func getCodable<Decoded: Decodable>(from path: String, parameters: [URLQueryItem] = [], completion: @escaping (APIResult<Decoded>) -> ()) {
        guard var components = URLComponents(string: "\(baseUrl)\(path)") else {
            return completion(.failure(APIError.invalidRequest))
        }
        components.queryItems = requiredQueryItems + parameters
        guard let request = components.url.flatMap({ URLRequest(url: $0) }) else {
            return completion(.failure(APIError.invalidRequest))
        }
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                return completion(.failure(error ?? APIError.invalidRequest))
            }
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(Decoded.self, from: data)
                completion(.success(decoded))
            } catch (let error) {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    static func getSearchResults(term: String, page: Int, completion: @escaping (APIResult<GiphyPage>) -> ()) {
        let path = "search"
        let parameters: [URLQueryItem]  = [
            URLQueryItem(name:"q", value: term.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "random"),
            URLQueryItem(name:"offset", value: (APIService.pageSize * page).description),
            URLQueryItem(name:"limit", value: APIService.pageSize.description)
        ]
        APIService.getCodable(from: path, parameters: parameters, completion: completion)
    }
}

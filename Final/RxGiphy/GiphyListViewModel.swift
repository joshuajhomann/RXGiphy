//
//  GiphyListViewModel.swift
//  RxGiphy
//
//  Created by Joshua Homann on 11/3/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct GiphyListViewModel {
    let searchText = BehaviorRelay<String>(value: "")
    let cellViewModels: Driver<[GiphyCellViewModel]>
    init(coordinator: CoordinatorProtocol, giphyService: GiphyServiceProtocol, giphyCacheService: GifCacheServiceProtocol) {
        cellViewModels = searchText.flatMapLatest { (term: String) ->  Observable<[GiphyCellViewModel]> in
            guard term.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
                return .just([])
            }
            return giphyService
                .getSearchResults(term: term, page: 0)
                .map { $0.data.map { GiphyCellViewModel(coordinator: coordinator, gifCacheService: giphyCacheService, giphy: $0) } }
            }.asDriver(onErrorJustReturn: [])
    }

}

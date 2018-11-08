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

}

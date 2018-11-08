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

}


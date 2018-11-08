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

}

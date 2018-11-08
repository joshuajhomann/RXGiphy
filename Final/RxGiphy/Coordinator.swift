//
//  Coordinator.swift
//  RxGiphy
//
//  Created by Joshua Homann on 10/9/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

enum CoordinatorAction {
    case showSearch, showDetail(Giphy), closeDetail
}

final class Coordinator {
    
    let navigationController: UINavigationController
    init(initialAction: CoordinatorAction) {
        navigationController = UINavigationController()
        navigationController.definesPresentationContext = true
        handle(initialAction)
    }

    func handle(_ action: CoordinatorAction) {
        switch action {
        case .showSearch:
            navigationController.pushViewController(GiphyListViewController(coordinator: self), animated: true)
        case .showDetail(let giphy):
            let detailViewController = GiphyDetailViewController(coordinator: self)
            detailViewController.giphy =  giphy
            navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
            navigationController.present(detailViewController, animated: true, completion: nil)
            return
        case .closeDetail:
             navigationController.dismiss(animated: true, completion: nil)
            return
        }
    }
}

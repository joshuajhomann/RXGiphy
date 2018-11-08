//
//  Coordinator.swift
//  RxGiphy
//
//  Created by Joshua Homann on 10/9/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    func handle(_ action: CoordinatorAction)
}

enum CoordinatorAction {
    case showSearch, showDetail(Giphy), closeDetail
}


final class Coordinator: CoordinatorProtocol {
    let dependencies: Dependencies
    let navigationController: UINavigationController
    init(initialAction: CoordinatorAction, dependencies: Dependencies) {
        self.dependencies = dependencies
        navigationController = UINavigationController()
        navigationController.definesPresentationContext = true
        handle(initialAction)
    }

    func handle(_ action: CoordinatorAction) {
        switch action {
        case .showSearch:
            let viewModel = GiphyListViewModel(coordinator: self,
                                               giphyService: dependencies.giphyService,
                                               giphyCacheService: dependencies.gifCacheService)
            let viewController = GiphyListViewController(viewModel: viewModel)

            navigationController.pushViewController(viewController, animated: true)
        case .showDetail(let giphy):
            let viewModel = GiphyDetailViewModel(coordinator: self,
                                                 gifCacheService: dependencies.gifCacheService,
                                                 giphy: giphy)
            let detailViewController = GiphyDetailViewController(viewModel: viewModel)
            navigationController.presentedViewController?.dismiss(animated: false, completion: nil)
            navigationController.present(detailViewController, animated: true, completion: nil)
            return
        case .closeDetail:
            navigationController.dismiss(animated: true, completion: nil)
            return
        }
    }
}

final class MockCoordinator: CoordinatorProtocol {
    var lastAction: CoordinatorAction?
    func handle(_ action: CoordinatorAction) {
        self.lastAction = action
    }
}

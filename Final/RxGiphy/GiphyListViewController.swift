//
//  GiphyListViewController.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

class GiphyListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private static let numberOfItemsAcross: CGFloat = 2
    private var searchResults: [Giphy] = []
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for new giphies..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    private let viewModel: GiphyListViewModel
    private let disposeBag = DisposeBag()
    init(viewModel: GiphyListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: GiphyListViewController.self), bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Giphy Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        collectionView.register(UINib(nibName: GiphyCollectionViewCell.name, bundle: nil),
                                forCellWithReuseIdentifier: GiphyCollectionViewCell.name)
        viewModel
            .cellViewModels
            .drive(collectionView
                .rx
                .items(cellIdentifier: GiphyCollectionViewCell.name, cellType: GiphyCollectionViewCell.self)) { indexPath, viewModel, cell in
                    cell.configure(with: viewModel)
            }.disposed(by: disposeBag)

        collectionView
            .rx
            .modelSelected(GiphyCellViewModel.self)
            .observeOn(MainScheduler())
            .subscribe(onNext: { (cellViewModel: GiphyCellViewModel) in
                let action = cellViewModel.selectAction
                action.execute(())
            }).disposed(by: disposeBag)

        searchController
        .searchBar
        .rx
        .text
        .orEmpty
        .debounce(0.25, scheduler: MainScheduler())
        .distinctUntilChanged()
        .bind(to: viewModel.searchText)
        .disposed(by: disposeBag)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        let remainingSpace = collectionView.bounds.width
                            - flowLayout.sectionInset.left
                            - flowLayout.sectionInset.right
                            - flowLayout.minimumInteritemSpacing * (GiphyListViewController.numberOfItemsAcross - 1)
        let dimension = remainingSpace / GiphyListViewController.numberOfItemsAcross
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
}


//
//  GiphyListViewController.swift
//  GiphyBrowser
//
//  Created by Joshua Homann on 7/15/18.
//  Copyright © 2018 com.josh. All rights reserved.
//

import UIKit

class GiphyListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private static let numberOfItemsAcross: CGFloat = 2
    private var searchResults: [Giphy] = []
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for new giphies..."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    private let coordinator: Coordinator
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
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

extension GiphyListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiphyCollectionViewCell.reuseIdentifier, for: indexPath)
        (cell as? GiphyCollectionViewCell)?.configure(with: searchResults[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
}

extension GiphyListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.handle(.showDetail(searchResults[indexPath.row]))
    }
}

extension GiphyListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.collectionView.reloadData()
        APIService.getSearchResults(term: searchBar.text ?? "", page: 0) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let page):
                    self.searchResults.removeAll()
                    self.searchResults.append(contentsOf: page.data)
                    self.collectionView.reloadData()
                    self.collectionView.contentOffset = .zero
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

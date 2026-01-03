//
//  FollowerListViewController.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import UIKit

final class FollowerListViewController: UIViewController {
    
    enum Section { case main }
    
    private let viewModel: FollowerListViewModel
    private let username: String
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(viewModel: FollowerListViewModel, username: String) {
        self.viewModel = viewModel
        self.username = username
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearch()
        configureDataSource()
        setupViewModelBindings()
        loadFollowers()
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        title = username
    }
    
    private func configureSearch() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowersCollectionViewCell.self, forCellWithReuseIdentifier: FollowersCollectionViewCell.reuseID)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FollowersCollectionViewCell.reuseID,
                    for: indexPath
                ) as! FollowersCollectionViewCell
                cell.set(follower: follower)
                return cell
            }
        )
    }
    
    private func setupViewModelBindings() {
        viewModel.onFollowersUpdated = { [weak self] in
            self?.updateData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.pressGFAlertOnMainThread(title: "Bad Stuff", message: errorMessage, buttonTitle: "OK")
        }
        
        viewModel.onShowEmptyState = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showEmptyStateView(with: message, in: self.view)
            }
        }
    }
    
    private func loadFollowers() {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            viewModel.followers = [Follower(login: "sample", avatarUrl: "https://via.placeholder.com/150")]
            viewModel.filteredFollowers = viewModel.followers
            updateData()
            return
        }
        
        shouldShowLoadingView()
        Task {
            await viewModel.loadFollowers(username: username, page: 1)
            dismissLoading()
        }
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.filteredFollowers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FollowerListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            Task {
                await viewModel.loadMoreFollowers(username: username)
            }
        }
    }
}

// MARK: - UISearchResultsUpdating
extension FollowerListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterFollowers(query: searchController.searchBar.text)
    }
}






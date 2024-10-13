//
//  FollowersListViewController.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 26/08/2024.
//

import UIKit
import SwiftUI

// Your original UIKit view controller
class FollowersListViewController: UIViewController {
    enum Section { case main }
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers: Bool = true
    
    var username: String = "sample_user"
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        configureSearch()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearch() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowersCollectionViewCell.self, forCellWithReuseIdentifier: FollowersCollectionViewCell.reuseID)
    }
    
    func getFollowers(username: String,page: Int){
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            self.followers = [Follower(login: "sample", avatarUrl: "https://via.placeholder.com/150")]
            self.updateData()
            return
        }
        shouldShowLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoading()
            
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false}
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty {
                    let message = "This User doesn't have follower. Go follow them"
                    DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view)}
                    return
                }
                self.updateData()
            
            case .failure(let error):
                self.pressGFAlertOnMainThread(title: "Bad Staff", message: error.rawValue ,buttuonTitle: "OK")
            }
        }
    }
    


    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowersCollectionViewCell.reuseID, for: indexPath) as! FollowersCollectionViewCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}

extension FollowersListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height  = scrollView.frame.size.height
        
        if offSetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page  += 1
            getFollowers(username: username, page: page)
        }
    }
}

extension FollowersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("updating")
    }
}

// Step 1: Create a UIViewControllerRepresentable to wrap the UIKit view controller
struct FollowersListViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FollowersListViewController {
        return FollowersListViewController()
    }

    func updateUIViewController(_ uiViewController: FollowersListViewController, context: Context) {
        // Handle updates if needed
    }
}

// Step 2: Add a SwiftUI Preview
struct FollowersListViewController_Previews: PreviewProvider {
    static var previews: some View {
        FollowersListViewControllerRepresentable()
            .edgesIgnoringSafeArea(.all) // Optional: Ignore safe area for full preview
            .previewDisplayName("Follower List View Controller")
    }
}


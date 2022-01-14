//
//  ExploreViewController.swift
//  Instagram-Clone
//
//  Created by Pedro Gomes Rubbo Pacheco on 27/03/21.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchVC = UISearchController(searchResultsController: SearchResultsViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Explore"
        view.backgroundColor = .systemBackground
        searchVC.searchBar.placeholder = "Search..."
        searchVC.searchResultsUpdater = self
        (searchVC.searchResultsController as? SearchResultsViewController)?.delegate = self
        navigationItem.searchController = searchVC
    }

}

extension ExploreViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let resultsVC = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }
        
        DatabaseManager.shared.findUsers(with: query) { result in
            DispatchQueue.main.async {
                resultsVC.update(with: result)
            }
        }
    }
}

extension ExploreViewController: SearchResultsViewControllerDelegate {
    func searchResultsViewController(_ vc: SearchResultsViewController, didSelectResultWith user: User) {
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

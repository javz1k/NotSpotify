//
//  SearchViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private var categories = [Category]()
    
    
    private lazy var searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 8,
                bottom: 2,
                trailing: 8
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                    widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .absolute(170)),
                                                                    subitem: item,
                                                                    count: 2)
            
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 8,
                leading: 2,
                bottom: 8,
                trailing: 2
            )
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }))
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        resultsController.delegate = self
        
        APICaller.shared.searchFromInput(with: query) { result in
            DispatchQueue.main.async{
                switch result{
                case .success(let searchResults):
                    resultsController.update(with: searchResults)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        
        APICaller.shared.getCategory {[weak self] result in
            DispatchQueue.main.async{
                switch result{
                case .success(let model):
                    self?.categories = model
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
    
   
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResults(_ result: SearchResult) {
        switch result{
        case .artist(model: let model):
            guard let url = URL(string: model.external_urls["spotify"] ?? "") else {return}
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        case .album(model: let model):
            let vc = AlbumViewController(album: model)
            navigationController?.pushViewController(vc, animated: true)
        case .track(model: let model):
            break
        case .playlist(model: let model):
            let vc = PlaylistViewController(playlist: model)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CategoryCollectionViewCell.identifier,
            for: indexPath
        ) as? CategoryCollectionViewCell else {return UICollectionViewCell()}
        let category = categories[indexPath.row]
        cell.configure(with: CategoryCollectionViewCellViewModel(
            title: category.name,
            artworkUrl: URL(string: category.icons.first?.url ?? "")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let vc = CategoryViewController(category: category)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

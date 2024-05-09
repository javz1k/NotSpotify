//
//  ViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

enum SectionType{
    case newReleases // 1
    case featuredPlaylists // 2
    case recommendedTracks // 3
}

class HomeViewController: UIViewController {
    
    private lazy var collectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection in
            return HomeViewController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        configureCollectionView()
        view.addSubview(spinner)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        switch section{
        case 0:
            // Item
               let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               // Spacing between items
               item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
               
               // Vertical group containing items
               let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                       widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(390)),
                                                                       subitem: item,
                                                                       count: 3)
               
               // Horizontal group containing vertical groups
               let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                           widthDimension: .fractionalWidth(0.9),
                                                                           heightDimension: .absolute(390)),
                                                                           subitem: verticalGroup,
                                                                           count: 1)
               
               // Section
               let section = NSCollectionLayoutSection(group: horizontalGroup)
               section.orthogonalScrollingBehavior = .groupPaging // Enable horizontal paging
               
               return section
            
        case 1:
            // Item
               let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               // Spacing between items
               item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
               
               // Vertical group containing items
               let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                       widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(390)),
                                                                       subitem: item,
                                                                       count: 3)
               
               // Horizontal group containing vertical groups
               let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                           widthDimension: .fractionalWidth(0.9),
                                                                           heightDimension: .absolute(390)),
                                                                           subitem: verticalGroup,
                                                                           count: 1)
               
               // Section
               let section = NSCollectionLayoutSection(group: horizontalGroup)
               section.orthogonalScrollingBehavior = .groupPaging // Enable horizontal paging
               
               return section
            
        case 2:
            // Item
               let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               // Spacing between items
               item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
               
               // Vertical group containing items
               let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                       widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(390)),
                                                                       subitem: item,
                                                                       count: 3)
               
               // Horizontal group containing vertical groups
               let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                           widthDimension: .fractionalWidth(0.9),
                                                                           heightDimension: .absolute(390)),
                                                                           subitem: verticalGroup,
                                                                           count: 1)
               
               // Section
               let section = NSCollectionLayoutSection(group: horizontalGroup)
               section.orthogonalScrollingBehavior = .groupPaging // Enable horizontal paging
               
               return section
            
        default:
            //Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            //Group
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                                            widthDimension: .fractionalWidth(0.9),
                                                                                            heightDimension: .absolute(390)),
                                                                                            repeatingSubitem: item,
                                                                                            count: 1
            )

            
            //Section
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    

    private func fetchData(){
        APICaller.shared.getRecommendedGenre { result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5{
                    seeds.insert(genres.randomElement() ?? "phonk")
                }
                APICaller.shared.getRecommendations(genres: seeds) { _ in
                    
                }
            case .failure(let error):
                break
            }
        }
     }

    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}







extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
        if indexPath.section == 0{
            cell.backgroundColor = .systemRed
        }else if indexPath.section == 1{
            cell.backgroundColor = .systemBlue
        }else if indexPath.section == 2{
            cell.backgroundColor = .systemBrown
        }
        return cell
    }
    
    
}

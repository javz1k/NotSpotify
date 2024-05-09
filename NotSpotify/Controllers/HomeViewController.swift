//
//  ViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

enum SectionType{
    case newReleases(viewModels:[NewReleaseCellViewModel]) // 1
    case featuredPlaylists(viewModels:[NewReleaseCellViewModel]) // 2
    case recommendedTracks(viewModels:[NewReleaseCellViewModel]) // 3
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
    
    private var sections = [SectionType]()

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
        collectionView.register(NewReleaseCollectionViewCell.self,
                                forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        collectionView.register(FeaturedPlaylistCollectionViewCell.self,
                                forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        collectionView.register(RecommendedTrackCollectionViewCell.self,
                                forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    

    private func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponseModel?
        var featuredPlaylist: FeaturedPlaylistResponseModel?
        var recomendations: Recomendations?
        //New releases
        APICaller.shared.getNewReleases { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        //Featured Playlists
        APICaller.shared.getFeaturedPlaylists { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        //Recommended tracks
        APICaller.shared.getRecommendedGenre { result in
            switch result{
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5{
                    seeds.insert(genres.randomElement() ?? "phonk")
                }
                APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
                    defer{
                        group.leave()
                    }
                    switch recommendedResult{
                    case .success(let model):
                        recomendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)            }
        }
        
        group.notify(queue: .main){
            guard let releases = newReleases?.albums.items,
                  let playlists = featuredPlaylist?.playlists.items,
                  let tracks = recomendations?.tracks else {
                print("models are nil")
                return
            }
            print("configuring view models")
            self.configureModels(
                newAlbums: releases,
                playlists: playlists,
                tracks: tracks)
        }
     }
    
    private func configureModels(
        newAlbums:[Album],
        playlists:[PlaylistModel],
        tracks:[Track]
    ){
        print(newAlbums.count)
        print(playlists.count)
        print(tracks.count)
        // Configure models
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            return NewReleaseCellViewModel(name: $0.name,
                                           artWorkUrl: URL(string: $0.images.first?.url ?? ""),
                                           numberOfTracks: $0.total_tracks,
                                           artistName:$0.artists.first?.name ?? "-"
            )
        })))
        sections.append(.featuredPlaylists(viewModels: []))
        sections.append(.recommendedTracks(viewModels: []))
        collectionView.reloadData()
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
        let type = sections[section]
        switch type {
        case .newReleases(viewModels: let viewModels):
            return viewModels.count
        case .featuredPlaylists(viewModels: let viewModels):
            return viewModels.count
        case .recommendedTracks(viewModels: let viewModels):
            return viewModels.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = sections[indexPath.section]
        switch type {
        case .newReleases(viewModels: let viewModels):
           guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NewReleaseCollectionViewCell.identifier,
                for: indexPath) as? NewReleaseCollectionViewCell else {
               return UICollectionViewCell()
           }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
            
        case .featuredPlaylists(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
                 for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
                return UICollectionViewCell()
            }
             cell.backgroundColor = .yellow
             return cell
            
        case .recommendedTracks(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
                 for: indexPath) as? RecommendedTrackCollectionViewCell else {
                return UICollectionViewCell()
            }
             cell.backgroundColor = .blue
             return cell
        }

        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .systemGreen
//        if indexPath.section == 0{
//            cell.backgroundColor = .systemRed
//        }else if indexPath.section == 1{
//            cell.backgroundColor = .systemBlue
//        }else if indexPath.section == 2{
//            cell.backgroundColor = .systemBrown
//        }
//        return cell
    }
    
    static func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
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
               let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               // Spacing between items
               item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
               
               // Vertical group containing items
               let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                       widthDimension: .absolute(200),
                                                                       heightDimension: .absolute(400)),
                                                                       subitem: item,
                                                                       count: 3)
               
               // Horizontal group containing vertical groups
               let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
                                                                           widthDimension: .absolute(200),
                                                                           heightDimension: .absolute(400)),
                                                                           subitem: verticalGroup,
                                                                           count: 1)
               
               // Section
               let section = NSCollectionLayoutSection(group: horizontalGroup)
               section.orthogonalScrollingBehavior = .continuous // Enable horizontal paging
               
               return section
            
        case 2:
            // Item
               let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               // Spacing between items
               item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
               
               // Vertical group containing items
               let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                       widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(80)),
                                                                       subitem: item,
                                                                       count: 1)
               
              
               
               // Section
               let section = NSCollectionLayoutSection(group: group)
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
    
}

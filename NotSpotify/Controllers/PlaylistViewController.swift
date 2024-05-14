//
//  PlaylistViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist: PlaylistModel
    private var viewModels = [RecommendedTrackCellViewModel]()
    
    private var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _ ,_ -> NSCollectionLayoutSection? in
            // Item
               let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
            
               let item = NSCollectionLayoutItem(layoutSize: itemSize)
               
               // Spacing between items
               item.contentInsets = NSDirectionalEdgeInsets(
                top: 2,
                leading: 2,
                bottom: 2,
                trailing: 2)
               
               // Vertical group containing items
               let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                                                                       widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .absolute(60)),
                                                                       subitem: item,
                                                                       count: 1)
               
              
               
               // Section
               let section = NSCollectionLayoutSection(group: group)
            
            section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.6)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            ]
               return section
    })
    )
    
    
    init(playlist:PlaylistModel){
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(
            RecommendedTrackCollectionViewCell.self,
            forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
        
        collectionView.register(
            PlaylistHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        
        
        
        APICaller.shared.getPlaylistDetails(for: playlist) {[weak self] result in
            DispatchQueue.main.async{
                switch result{
                case .success(let model):
                    self?.viewModels = model.tracks.items.compactMap({
                        RecommendedTrackCellViewModel(
                            name: $0.track.name,
                            artistName: $0.track.artists.first?.name ?? "-",
                            artWorkUrl: URL(string: $0.track.album?.images.first?.url ?? "")
                            )
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    @objc func didTapShare(){
        print("external urls\(playlist.external_urls)")
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {
            return
        }
        let vc = UIActivityViewController(
            activityItems: ["Check out this playlist!", url],
            applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated:true)
    }
    

}


extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier,
            for: indexPath) as? RecommendedTrackCollectionViewCell else {
           return UICollectionViewCell()
       }
        cell.backgroundColor = .red
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //play song
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
            for: indexPath)  as? PlaylistHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        let headerViewModel = PlaylistHeaderViewModel(
            playlistName: playlist.name,
            ownerName: playlist.owner.display_name,
            description: playlist.description,
            artWorkUrl: URL(string: playlist.images.first?.url ?? "")
            )
            
        header.configure(with:headerViewModel)
        header.delegate = self
        return header
    }
    
    
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate{
    func PlaylistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        print("playing all")
    }
    
    
}

//
//  SearchResultsViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.


import UIKit

struct SearchSection {
    let title: String
    let results: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResults(_ result: SearchResult)
}

class SearchResultsViewController: UIViewController {
    private var sections : [SearchSection] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func update(with results:[SearchResult]){
        let artist = results.filter({
            switch $0{
            case .artist:
                return true
            default:
                return false
            }
        })
        
        let albums = results.filter({
            switch $0{
            case .album:
                return true
            default:
                return false
            }
        })

        let tracks = results.filter({
            switch $0{
            case .track:
                return true
            default:
                return false
            }
        })

        let playlists = results.filter({
            switch $0{
            case .playlist:
                return true
            default:
                return false
            }
        })

        
        
        self.sections = [
            SearchSection(title: "Artist", results: artist),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Tracks", results: tracks),
            SearchSection(title: "Playlists", results: playlists)
        ]
        
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
    
        switch result{
        case .artist(model: let artistModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else {return UITableViewCell()}
            
            let vmodel = SearchResultDefaultTableViewCellViewModel(
                title: artistModel.name,
                imageURL: URL(string: artistModel.images?.first?.url ?? "")
            )
            cell.configure(with: vmodel)
            return cell
        case .album(model: let albumModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {return UITableViewCell()}
            
            let vmodel = SearchResultSubtitleTableViewCellViewModel(
                title: albumModel.name,
                subtitle: albumModel.artists.first?.name ?? "",
                imageURL: URL(string: albumModel.images.first?.url ?? "")
            )
            cell.configure(with: vmodel)
            return cell
        case .track(model: let trackModel):
             guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identifier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {return UITableViewCell()}
            
            let vmodel = SearchResultSubtitleTableViewCellViewModel(
                title: trackModel.name,
                subtitle: trackModel.artists.first?.name ?? "",
                imageURL: URL(string: trackModel.album?.images.first?.url ?? "")
            )
            cell.configure(with: vmodel)
            return cell
        case .playlist(model: let playlistModel):
            guard let cell = tableView.dequeueReusableCell(
               withIdentifier: SearchResultSubtitleTableViewCell.identifier,
               for: indexPath
           ) as? SearchResultSubtitleTableViewCell else {return UITableViewCell()}
           
           let vmodel = SearchResultSubtitleTableViewCellViewModel(
               title: playlistModel.name,
               subtitle: playlistModel.owner.display_name,
               imageURL: URL(string: playlistModel.images.first?.url ?? "")
           )
           cell.configure(with: vmodel)
           return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResults(result)
    }
    
    
}

//
//  ViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettings))
        
        fetchData()
    }
    
//   private func fetchData(){
//       APICaller.shared.getNewReleases { result in
//           switch result{
//           case .success(let model):
//               break
//           case .failure(let error):
//               break
//           }
//       }
//    }
    private func fetchData(){
        APICaller.shared.getFeaturedPlaylists { _ in
            
        }
     }

    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


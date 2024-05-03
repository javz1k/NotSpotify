//
//  ProfileViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        fetchProfile()
       
    }
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with:model)
                case .failure(let error):
                    self?.failedToGetProfile()
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(with: UserProfileModel){
        
    }
    
    private func failedToGetProfile(){
        let label = UILabel()
        label.text = "Failed to load profile..."
        label.textColor = .secondaryLabel
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.center = view.center
        label.numberOfLines = 0
        view.addSubview(label)
        label.centerInSuperview()
    }
   

}

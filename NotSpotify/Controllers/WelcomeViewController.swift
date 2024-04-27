//
//  WelcomeViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private lazy var signInButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        print(AuthManager.shared.signInURL)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(x: 50, y: 700, width: 280, height: 30)
    }
    
    @objc func didTapSignIn(){
        let vc = AuthViewController()
        vc.completitionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleSignIn(success: Bool){
        
    }
  

}

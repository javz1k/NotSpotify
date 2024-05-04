//
//  ProfileViewController.swift
//  NotSpotify
//
//  Created by Cavidan Mustafayev on 25.04.24.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        fetchProfile()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private lazy var tableView:UITableView = {
        let t = UITableView()
        t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        t.isHidden = true
        return t
    }()
    
    private func fetchProfile(){
        APICaller.shared.getCurrentUserProfile {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with:model)
                case .failure(let error):
                    self?.failedToGetProfile()
                    print("Profile error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateUI(with model: UserProfileModel){
        tableView.isHidden = false
        //configure table models
        models.append("Full name: \(model.display_name)")
        models.append("Country: \(model.country)")
        models.append("Email adress: \(model.email)")
        models.append("Plan: \(model.product)")
        models.append("User ID: \(model.id)")
        createTableHeader(url:model.images.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(url:String?){
        guard let urlString = url, let url = URL(string: urlString) else {return}
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2))
        let imageSize:CGFloat = headerView.frame.height/2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize/2
        imageView.sd_setImage(with: url)
        tableView.tableHeaderView = headerView
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = models[indexPath.row]
        return cell
    }
   

}

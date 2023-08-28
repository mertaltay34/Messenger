//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Mert Altay on 15.08.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

private let reuseIdentifier = "ProfileCell"
class ProfileViewController: UIViewController {
    //MARK: - Properties
    private let tableView = UITableView()
    let data = ["Log Out"]
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        // Do any additional setup after loading the view.
        style()
        addSubviews()
        layout()
    }

}

    //MARK: - Helpers
extension ProfileViewController{
    private func style(){
        tableView.rowHeight = 40
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    private func addSubviews(){
        view.addSubview(tableView)
    }
    private func layout(){
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

//MARK: - TableviewDataSource and Delegate
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
            }
            catch{
                print("Failed to log out")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}

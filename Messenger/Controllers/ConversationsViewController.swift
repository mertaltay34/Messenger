//
//  ViewController.swift
//  Messenger
//
//  Created by Mert Altay on 15.08.2023.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    //MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true // konuşma geçmişi yoksa tableView gösterilmeyecek
        table.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        return table
    }()
    private let noConversationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations!"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    //MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        style()
        addSubviews()
        layout()
        fetchConversations()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
}
    //MARK: - Selectors
extension ConversationsViewController{
    @objc private func didTapComposeButton(){
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
}

    //MARK: - Helpers
extension ConversationsViewController{
    private func style(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(noConversationsLabel)
    }
    private func layout(){
        
    }
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }
    private func fetchConversations(){
        tableView.isHidden = false
    }
}
    //MARK: - UITableViewDataSource
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator // sağ tarafta ">" gösterir.
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Efe TAV"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

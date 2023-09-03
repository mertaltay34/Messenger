//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Mert Altay on 15.08.2023.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    //MARK: - Properties
    private let spinner = JGProgressHUD(style: .dark)
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }()
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true // konuşma geçmişi yoksa tableView gösterilmeyecek
        table.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        return table
    }()
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        addSubviews()
        layout()
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        view.backgroundColor = .white
    }
}
    //MARK: - Selector
extension NewConversationViewController{
    @objc private func dismissSelf(){
        dismiss(animated: true)
    }
}
    //MARK: - Helpers
extension NewConversationViewController{
    private func style(){
        searchBar.delegate = self
        searchBar.becomeFirstResponder() // tıklandığında klavye otomatik olarak görüntülenecektir
    }
    private func addSubviews(){
        
    }
    private func layout(){
        
    }
    
}
    //MARK: - UISearchBarDelegate
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

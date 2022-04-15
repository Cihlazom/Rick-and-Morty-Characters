//
//  ViewController.swift
//  Rick and Morty Library
//
//  Created by Vladislav on 14.04.2022.
//

import UIKit

class LibraryOfCharactersViewController: UIViewController {
    
    var model = MainRequest()
    private var pageNumber = 1
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: CharactersTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Library"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        newPage()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
        
    private func newPage() {
        //update model
        NetworkManager.shared.requestAllInfo(page: pageNumber) { [weak self] result in
            switch result {
            case .success(let allCharacters):
                self?.model.results.append(contentsOf: allCharacters.results)
                self?.model.info = allCharacters.info
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        pageNumber += 1
    }
}

extension LibraryOfCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model.results[indexPath.row].id == model.results.last?.id,
           model.info.next != nil {
            newPage()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifier, for: indexPath) as! CharactersTableViewCell
        cell.configure(with: model.results[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = CharacterViewController(with: model.results[indexPath.row].id)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}


//
//  CharacterViewController.swift
//  Rick and Morty Library
//
//  Created by Vladislav on 14.04.2022.
//

import UIKit

class CharacterViewController: UIViewController {
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let raceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let lastKnownLocationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfEpisodesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let id: Int
    private var model: CharacterInfo?
    
    init(with id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        NetworkManager.shared.getCharacterById(id: id) { [weak self] result in
            switch result {
            case .success(let charInfo):
                self?.model = charInfo
                DispatchQueue.main.async {
                    self?.configure()
                }
            case .failure(let error):
                print(error)
            }
        }
        view.addSubview(characterImageView)
        view.addSubview(nameLabel)
        view.addSubview(raceLabel)
        view.addSubview(genderLabel)
        view.addSubview(statusLabel)
        view.addSubview(lastKnownLocationLabel)
        view.addSubview(numberOfEpisodesLabel)
    }
    
    override func viewDidLayoutSubviews() {
        characterImageView.frame = CGRect(x: 10, y: view.safeAreaInsets.top+20, width: view.width-20, height: view.height/2.3)
        nameLabel.frame = CGRect(x: 20, y: characterImageView.bottom+10, width: view.width-20, height: 80)
        raceLabel.frame = CGRect(x: 20, y: nameLabel.bottom+10, width: (view.width-45)/3, height: 60)
        statusLabel.frame = CGRect(x: raceLabel.right+5, y: nameLabel.bottom+10, width: (view.width-45)/3, height: 60)
        genderLabel.frame = CGRect(x: statusLabel.right+5, y: nameLabel.bottom+10, width: (view.width-45)/3, height: 60)
        numberOfEpisodesLabel.frame = CGRect(x: 20, y: genderLabel.bottom+10, width: view.width-40, height: 50)
        lastKnownLocationLabel.frame = CGRect(x: 20, y: numberOfEpisodesLabel.bottom+10, width: view.width-40, height: 50)
    }
    
    private func configure(){
        guard let url = model?.image,
              let episodes = model?.episode.count,
              let species = model?.species,
              let status = model?.status,
              let gender = model?.gender,
              let location = model?.location.name else {
            return
        }
        nameLabel.text = model?.name
        raceLabel.text = "Раса: \(species)"
        statusLabel.text = "Статус: \(status)"
        genderLabel.text = "Пол: \(gender)"
        numberOfEpisodesLabel.text = "Кол-во эпизодов, в которых упоминался персонаж: \(episodes)"
        characterImageView.downloaded(from: url)
        lastKnownLocationLabel.text = "Последнее известное местоположение: \(location)"
    }
}


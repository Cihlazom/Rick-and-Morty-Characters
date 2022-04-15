//
//  CharactersTableViewCell.swift
//  Rick and Morty Library
//
//  Created by Vladislav on 14.04.2022.
//

import UIKit

class CharactersTableViewCell: UITableViewCell {
    
    static let identifier = "CharactersTableViewCell"
    
    private let charImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let raceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(charImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(raceLabel)
        contentView.addSubview(genderLabel)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        charImageView.frame = CGRect(x: 10, y: 10, width: contentView.height-20, height: contentView.height-20)
        nameLabel.frame = CGRect(x: charImageView.right+5, y: 10, width: contentView.width-charImageView.width-25, height: 50)
        raceLabel.frame = CGRect(x: charImageView.right+5, y: nameLabel.bottom, width: (contentView.width-charImageView.width)/2, height: 40)
        genderLabel.frame = CGRect(x: raceLabel.right+5, y: nameLabel.bottom, width: (contentView.width-charImageView.width-60)/2, height: 40)
        charImageView.layer.cornerRadius = charImageView.height/2
    }
    
    public func configure(with model: MainInfo) {
        nameLabel.text = "Имя: \(model.name)"
        raceLabel.text = "Раса: \(model.species)"
        genderLabel.text = "Пол: \(model.gender)"
        charImageView.downloaded(from: model.image)
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}

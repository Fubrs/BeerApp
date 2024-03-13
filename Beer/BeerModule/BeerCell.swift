//
//  BeerCell.swift
//  Beer
//
//  Created by Nikita Chuklov on 10.03.2024.
//

import UIKit

class BeerCell: UITableViewCell {
    
    var imageCache: ImageCacheManager?
    
    //MARK: - Private properties
    
    private var stringBeerImage = "" {
        didSet {
            setupImage(stringBeerImage)
        }
    }
    
    private let beerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let nameBeerLable = {
       let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.font = .systemFont(ofSize: 15)
        return name
    }()
    
    private let abvBeerLable = {
       let abv = UILabel()
        abv.translatesAutoresizingMaskIntoConstraints = false
        abv.font = .systemFont(ofSize: 15)
        return abv
    }()
    
    private var beerImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.black.cgColor
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    //MARK: - Construction
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        applyConstraints()
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Private functions
    
    private func addSubviews() {
        contentView.addSubview(beerView)
        beerView.addSubview(beerImage)
        beerView.addSubview(nameBeerLable)
        beerView.addSubview(abvBeerLable)
        
    }
    private func applyConstraints() {
        NSLayoutConstraint.activate([
        
            beerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            beerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            beerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            beerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            beerImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
            beerImage.heightAnchor.constraint(equalToConstant: 200),
            beerImage.trailingAnchor.constraint(equalTo: beerView.trailingAnchor, constant: -8),
            beerImage.topAnchor.constraint(equalTo: beerView.topAnchor, constant: 8),
            beerImage.bottomAnchor.constraint(equalTo: beerView.bottomAnchor, constant: -8),
            
            nameBeerLable.leadingAnchor.constraint(equalTo: beerView.leadingAnchor, constant: 8),
            nameBeerLable.trailingAnchor.constraint(equalTo: beerImage.leadingAnchor, constant: -4),
            nameBeerLable.topAnchor.constraint(equalTo: beerImage.topAnchor, constant: 8),
            
            abvBeerLable.leadingAnchor.constraint(equalTo: beerView.leadingAnchor, constant: 8),
            abvBeerLable.trailingAnchor.constraint(equalTo: beerImage.leadingAnchor, constant: -4),
            abvBeerLable.topAnchor.constraint(equalTo: nameBeerLable.bottomAnchor, constant: 8)
            
        ])
    }
    
    //MARK: - Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        beerImage.image = nil
    }
   
    func setupUI(beer: Beer, currentMode: BeerViewController.SortingMode) {
        
        nameBeerLable.font = .systemFont(ofSize: currentMode == .name ? 18 : 15, weight: currentMode == .name ? .bold : .regular)
        abvBeerLable.font = .systemFont(ofSize: currentMode == .abv ? 18 : 15, weight: currentMode == .abv ? .bold : .regular)
        
        nameBeerLable.text = "Название пива: \(beer.name)"
        stringBeerImage = beer.imageURL ?? ""
        abvBeerLable.text = "Крепкость пива: \(String(beer.abv))"
        
    }
    
    func setupImage(_ urlString: String) {
        if let image = imageCache?.image(for: urlString as NSString) {
            beerImage.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self else { return }
            guard let data else {
                beerImage.image = nil
                return
            }
            
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.beerImage.image = image
                self.imageCache?.saveImage(image, forKey: urlString as NSString)
            }
        }.resume()
    }
}



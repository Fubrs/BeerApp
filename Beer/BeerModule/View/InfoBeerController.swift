//
//  InfoBeerController.swift
//  Beer
//
//  Created by Nikita Chuklov on 12.03.2024.
//

import UIKit
class InfoBeerController: UIViewController {
    //MARK: - Private properties
    
    private let beer: Beer
    private let appComponents: AppComponents
    
    private let infoBeerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private var imageBeerView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
       
        
        return image
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        
        
        return label
    }()
    
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        
        
        return label
    }()
    
    private var foodPairingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        
        
        return label
    }()
    
    //MARK: - Construction
    
    init(beer: Beer, appComponents: AppComponents) {
        self.beer = beer
        self.appComponents = appComponents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        applyConstraints()
        setupInfoUI()
        navigationController?.navigationBar.prefersLargeTitles = false
        title = beer.name
    }
    //MARK: - Private functions
    
    private func addSubviews() {
        view.addSubview(infoBeerView)
        infoBeerView.addSubview(imageBeerView)
        infoBeerView.addSubview(nameLabel)
        infoBeerView.addSubview(descriptionLabel)
        infoBeerView.addSubview(foodPairingLabel)
        
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            
            infoBeerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoBeerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoBeerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoBeerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageBeerView.topAnchor.constraint(equalTo: infoBeerView.topAnchor, constant: 50),
            imageBeerView.centerXAnchor.constraint(equalTo: infoBeerView.centerXAnchor),
            imageBeerView.heightAnchor.constraint(equalTo: infoBeerView.heightAnchor, multiplier: 0.3),
            imageBeerView.widthAnchor.constraint(equalTo: infoBeerView.widthAnchor, multiplier: 0.2),
            
            nameLabel.topAnchor.constraint(equalTo: imageBeerView.bottomAnchor,constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: infoBeerView.leadingAnchor,constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: infoBeerView.trailingAnchor,constant: -8),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoBeerView.leadingAnchor,constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoBeerView.trailingAnchor,constant: -8),
            
            foodPairingLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 50),
            foodPairingLabel.leadingAnchor.constraint(equalTo: infoBeerView.leadingAnchor,constant: 8),
            foodPairingLabel.trailingAnchor.constraint(equalTo: infoBeerView.trailingAnchor,constant: -8),
            
            
        ])
    }
    
    private func setupInfoUI(){
        self.nameLabel.text = beer.name
        self.descriptionLabel.text = beer.description
        let imageKey = (beer.imageURL ?? "") as NSString
        let image = appComponents.imageCache.image(for: imageKey)
        imageBeerView.image = image
        foodPairingLabel.text = beer.foodPairing.joined(separator: ", ")
    }
}



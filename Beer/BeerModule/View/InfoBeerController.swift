//
//  InfoBeerController.swift
//  Beer
//
//  Created by Nikita Chuklov on 12.03.2024.
//

import UIKit
class InfoBeerController: UIViewController {
    
    private let beer: Beer
    private let appComponents: AppComponents
    
    private var imageString = "" {
        didSet {
            configureImage(url: imageString)
        }
    }
    
    private let infoBeerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    private var imageBeerView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .gray

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
        
    }
    
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
            infoBeerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageBeerView.topAnchor.constraint(equalTo: infoBeerView.topAnchor, constant: 20),
            imageBeerView.centerXAnchor.constraint(equalTo: infoBeerView.centerXAnchor),
            imageBeerView.heightAnchor.constraint(equalTo: infoBeerView.heightAnchor, multiplier: 0.3),
            imageBeerView.widthAnchor.constraint(equalTo: infoBeerView.widthAnchor, multiplier: 0.2),
            
            nameLabel.topAnchor.constraint(equalTo: imageBeerView.bottomAnchor,constant: 50),
            nameLabel.leadingAnchor.constraint(equalTo: infoBeerView.leadingAnchor,constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: infoBeerView.trailingAnchor,constant: -8),
           
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor,constant: 50),
            descriptionLabel.leadingAnchor.constraint(equalTo: infoBeerView.leadingAnchor,constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoBeerView.trailingAnchor,constant: -8),
            
            foodPairingLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor,constant: 50),
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
        
//        for index in beer.foodPairing {
//            self.foodPairingLabel.text! += " \(index),"
//        }
    }
    
    private func configureImage(url: String){
        guard let urlString = URL(string: url) else {return}
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageBeerView.image = image
            }
        }.resume()
    }
    
}

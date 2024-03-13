//
//  Presenter.swift
//  Beer
//
//  Created by Nikita Chuklov on 10.03.2024.
//

import UIKit

protocol BeerPresenterProrotocol {
    func fetchBeer(page: Int)
    func fetchBeers(withName name: String)
}

protocol BeerPresenterDelegate: AnyObject {
    func assignBeer(beers: [Beer])
    func didFoundBeers(_ beers: [Beer])
    
}

class BeerPresenter: BeerPresenterProrotocol {
    
    //MARK: - Properties
    
    weak var delegate: BeerPresenterDelegate?
    
    private let apiManager: ApiManagerProtocol
    
    //MARK: - Construction
    
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    //MARK: - Functions
    
    func fetchBeer(page: Int) {
        
        //let stringUrl = "https://api.punkapi.com/v2/beers"
        guard let url = apiManager.url(for: .page(page))  else { return }
        //guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            let beers = try? JSONDecoder().decode([Beer].self, from: data)
            guard var beerSorted = beers else { return }
            beerSorted = beers!.sorted { $0.name < $1.name }
            DispatchQueue.main.async {
                self.delegate?.assignBeer(beers: beerSorted)
            }
        }.resume()
    }
    
    func fetchBeers(withName name: String) {
        guard let url = apiManager.url(for: .name(name)) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else { return }
            let beers = try? JSONDecoder().decode([Beer].self, from: data)
            guard let beerSearch = beers else { return }
            DispatchQueue.main.async {
                self.delegate?.didFoundBeers(beerSearch)
            }
        }.resume()
    }
}





//
//  ViewController.swift
//  Beer
//
//  Created by Nikita Chuklov on 10.03.2024.
//

import UIKit

class BeerViewController: UIViewController {
    
    //MARK: - Nested types
    
    enum SortingMode: Int, CaseIterable {
        case all
        case name
        case abv
        case firstBrewed
        
        var title: String {
            switch self {
            case .all:
                return "Все"
            case .name:
                return "По имени"
            case .abv:
                return "Крепость"
            case .firstBrewed:
                return "Дата"
            }
        }
    }
    
    //MARK: - Private properties
    
    private let beerPresenter: BeerPresenterProrotocol
    private let appComponents: AppComponents
    
    private var currentPage: Int = 1
    private let defaultCellHeight: CGFloat = 150.0
    private var isLoading: Bool = false
    private var currentMode: SortingMode = .name

    private var searchBeers = [Beer]() {
        didSet{
            self.beerTableView.reloadData()
        }
    }
    
    private var beers: [Beer] = [] {
        didSet {
            beerTableView.reloadData()
        }
    }
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: SortingMode.allCases.map {$0.title})
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = currentMode.rawValue
        segment.addTarget(self, action: #selector(segmentChange(_:)), for: .valueChanged)
        //segment.tintColor = .red
        segment.selectedSegmentTintColor = .darkGray
        segment.backgroundColor = .lightGray
        return segment
    }()
    
    private lazy var loadingView: UIView = {
        let image = UIView(frame: CGRect(origin: .zero,
                                         size: CGSize(width: UIScreen.main.bounds.width,
                                                      height: defaultCellHeight)))
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemOrange
        image.addSubview(indicator)
        indicator.center = image.center
        indicator.startAnimating()
        image.isHidden = true
        return image
    }()
    
    private lazy var beerTableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(BeerCell.self, forCellReuseIdentifier: BeerCell.reuseID)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = loadingView
        table.estimatedRowHeight = defaultCellHeight
        table.separatorStyle = .none
        
        return table
    }()
    
    private lazy var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Поиск"
        search.searchBar.delegate = self
        search.searchBar.tintColor = .darkGray
        search.searchBar.layer.cornerRadius = 20
        search.searchBar.searchTextField.backgroundColor = .lightGray
        return search
    }()
    
    private var searchIsEmpty: Bool{
        guard let text = searchBar.searchBar.text else {return true}
        return text.isEmpty
    }
    
    private var searchIsWorking: Bool {
        return searchBar.isActive && !searchIsEmpty
    }
    
    //MARK: Construction
    
    init(beerPresenter: BeerPresenterProrotocol, appComponents: AppComponents) {
        self.beerPresenter = beerPresenter
        self.appComponents = appComponents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
        
        addSubviews()
        applyConstraints()
        navigationItem.searchController = searchBar
        requestBeers()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - Private functions
    
    private func addSubviews() {
        view.addSubview(segmentedControl)
        view.addSubview(beerTableView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //segmentedControl.heightAnchor.constraint(equalToConstant: <#T##CGFloat#>),
        
            beerTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            beerTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            beerTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            beerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        
        ])
    }
    
    private func setupAppearance() {
        let apperance = UINavigationBarAppearance()
        apperance.backgroundColor = .systemGray
        navigationController?.navigationBar.standardAppearance = apperance
        navigationController?.navigationBar.scrollEdgeAppearance = apperance
    }
    
    // MARK: - Actions
    
    @objc private func segmentChange(_ segmentedControll: UISegmentedControl) {
        guard let mode = SortingMode(rawValue: segmentedControll.selectedSegmentIndex) else { return }
        guard currentMode != mode else { return }
        currentMode = mode
        beerTableView.reloadData()
    }
    
    @objc func requestBeers() {
        isLoading = true
        beerPresenter.fetchBeer(page: currentPage)
    }

}
//MARK: - BeerPresenterDelegate

extension BeerViewController: BeerPresenterDelegate {
    func didFoundBeers(_ beers: [Beer]) {
        searchBeers = beers
    }
    
    func assignBeer(beers: [Beer]) {
            self.beers.append(contentsOf: beers)
            self.loadingView.isHidden = true
            
            isLoading = false
        }
    
    }
    
//MARK: - TableView protocols

extension BeerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsWorking ? searchBeers.count : beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerCell.reuseID,
                                                       for: indexPath) as? BeerCell else { return UITableViewCell() }
        
        var beers = searchIsWorking ?  searchBeers : beers
        switch currentMode {
        case .all:
            break
        case .name:
            beers = beers.sorted(by: {$0.name < $1.name })
        case .abv:
            beers = beers.sorted(by: {$0.abv < $1.abv })
        case .firstBrewed:
            beers = beers.sorted(by: {$0.firstBrewed < $1.firstBrewed })
        }
        
        cell.imageCache = appComponents.imageCache
        let beer = beers[indexPath.row]
        cell.setupUI(beer: beer, currentMode: currentMode)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !searchIsWorking else { return }
        
            guard indexPath.row == beers.count - 1 && !isLoading else { return }
            isLoading = true
            currentPage += 1
            requestBeers()
            loadingView.isHidden = false
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var beers = searchIsWorking ?  searchBeers : beers
        switch currentMode {
        case .all:
            break
        case .name:
            beers = beers.sorted { $0.name < $1.name }
        case .abv:
            beers = beers.sorted { $0.abv < $1.abv }
        case .firstBrewed:
            beers = beers.sorted { $0.firstBrewed < $1.firstBrewed }
        }
        let beer = beers[indexPath.row]
        let infoBeerController = InfoBeerController(beer: beer, appComponents: appComponents)
        navigationController?.pushViewController(infoBeerController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension BeerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let text = text else { return }
        if !text .isEmpty {
            self.beerPresenter.fetchBeers(withName: text)
        } else {
            beerTableView.reloadData()
        }
    }
}



    
    
   

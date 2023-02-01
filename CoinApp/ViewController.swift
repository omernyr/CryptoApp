//
//  ViewController.swift
//  CoinApp
//
//  Created by macbook pro on 1.02.2023.
//

import UIKit
import SDWebImageSVGCoder

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var clickedCoinName = ""
    var clickedCoinPrice = ""
    var clickedCoinRise = ""
    var clickedCoinHighPrice = ""
    var clickedCoinLowPrice = ""
    var clickedCoinSymbol = ""
    
    @IBOutlet weak var tableView: UITableView!
    var filteredData : [CoinElement] = []
    var coinArray : [CoinElement] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var searchController: UISearchController!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //MARK: - search
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Fruits"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        //MARK: - search
        
        getData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredData = coinArray.filter({ (fruit: CoinElement) -> Bool in
            
            return fruit.name!.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    func getData() {
        let url = URL(string: "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins")!
        
        WebService().getCoins(url: url) { coins in
            
            DispatchQueue.main.async {
                self.coinArray = (coins.data?.coins)!
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isFiltering() {
            return filteredData.count
        }
        
        return coinArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoinViewCell
        
        if isFiltering() {
            // MARK: - Coin name
            cell.coinNameLabel.text = filteredData[indexPath.section].name
            // MARK: - Coin Symbol
            cell.coinSymbolLabel.text = filteredData[indexPath.section].symbol
            // MARK: - Coin Change
            if filteredData[indexPath.section].change?.first == "-" {
                cell.coinChangeLabel.textColor = .systemRed
            } else {
                cell.coinChangeLabel.textColor = .systemGreen
            }
            let coinChange = filteredData[indexPath.section].change!
            cell.coinChangeLabel.text = "%\(coinChange)"
            
            // MARK: - Coin Image
            let data = filteredData[indexPath.section].price!
            let newData = Double(round(Double(data)! * 1000) / 1000)
            cell.coinPriceLabel.text = "$\(newData)"
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
            cell.coinImageView.sd_setImage(with: URL(string: filteredData[indexPath.section].iconURL!)!)
            var rect = cell.coinImageView.frame
            rect.size.width = 22
            rect.size.height = 22
            cell.coinImageView.frame = rect
            return cell
        } else {
            
            // MARK: - Coin name
            cell.coinNameLabel.text = coinArray[indexPath.section].name
            // MARK: - Coin Symbol
            cell.coinSymbolLabel.text = coinArray[indexPath.section].symbol
            // MARK: - Coin Change
            if coinArray[indexPath.section].change?.first == "-" {
                cell.coinChangeLabel.textColor = .systemRed
            } else {
                cell.coinChangeLabel.textColor = .systemGreen
            }
            let coinChange = coinArray[indexPath.section].change!
            cell.coinChangeLabel.text = "%\(coinChange)"
            
            // MARK: - Coin Image
            let data = coinArray[indexPath.section].price!
            let newData = Double(round(Double(data)! * 1000) / 1000)
            cell.coinPriceLabel.text = "$\(newData)"
            let SVGCoder = SDImageSVGCoder.shared
            SDImageCodersManager.shared.addCoder(SVGCoder)
            cell.coinImageView.sd_setImage(with: URL(string: coinArray[indexPath.section].iconURL!)!)
            var rect = cell.coinImageView.frame
            rect.size.width = 22
            rect.size.height = 22
            cell.coinImageView.frame = rect
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedCoinName = coinArray[indexPath.section].name!
        clickedCoinPrice = coinArray[indexPath.section].price!
        clickedCoinRise = coinArray[indexPath.section].change!
        clickedCoinHighPrice = coinArray[indexPath.section].sparkline![0]
        clickedCoinLowPrice = coinArray[indexPath.section].sparkline![3]
        clickedCoinSymbol = coinArray[indexPath.section].symbol!
        
        
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.selectedCoinName = clickedCoinName
            destinationVC.selectedCoinPrice = clickedCoinPrice
            destinationVC.selectedCoinRise = clickedCoinRise
            destinationVC.selectedCoinHighPrice = clickedCoinHighPrice
            destinationVC.selectedCoinLowPrice = clickedCoinLowPrice
            destinationVC.selectedCoinSymbol = clickedCoinSymbol
        }
    }
}

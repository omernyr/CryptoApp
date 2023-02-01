//
//  DetailViewController.swift
//  CoinApp
//
//  Created by macbook pro on 1.02.2023.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedCoinName = ""
    var selectedCoinPrice = ""
    var selectedCoinRise = ""
    var selectedCoinHighPrice = ""
    var selectedCoinLowPrice = ""
    var selectedCoinSymbol = ""
    
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var coinRiseLabel: UILabel!
    @IBOutlet weak var coinHighPriceLabel: UILabel!
    @IBOutlet weak var coinLowRiseLAbel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = selectedCoinSymbol
        coinNameLabel.text = selectedCoinName
        coinPriceLabel.text = selectedCoinPrice
        coinRiseLabel.text = selectedCoinRise
        coinHighPriceLabel.text = selectedCoinHighPrice
        coinLowRiseLAbel.text = selectedCoinLowPrice
        
    }
}


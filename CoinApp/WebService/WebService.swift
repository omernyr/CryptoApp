//
//  WebService.swift
//  CoinApp
//
//  Created by macbook pro on 1.02.2023.
//

import Foundation


class WebService {
    
    func getCoins(url: URL, completion: @escaping (Coin) -> Void) {
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                
                do {
                    let coins = try JSONDecoder().decode(Coin.self, from: data)
                    completion(coins)
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

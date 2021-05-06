//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func updateExchangeRate(_ coinManager:CoinManager,bitcoinModel:BitcoinModel)
    func didFailWithError(_ coinManager:CoinManager, error: Error)
}
struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let apiKey = "770C71E4-4F50-4A05-AC86-ABE483B82E79"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate:CoinManagerDelegate?
    func getCurrencyArray()->[String]{
        return currencyArray
    }
    
    func getNumberOfCurrenciesAvailable()->Int{
        return currencyArray.count
    }
    
    func getCoinPrice(for currency:String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString:String){
        if let url = URL(string: urlString){
            let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(self, error: error!)
                    return
                }
                if let data = data {
                    self.parseJSON(data)
                }
                
            }
            task.resume()
        }else{
            print("error in url")
        }
        
    }
    
    func parseJSON(_ data:Data ){
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(BitcoinData.self, from: data)
            let currency = decodedData.asset_id_quote
            let rate = decodedData.rate
            let bitcoinModel = BitcoinModel(currency: currency, rate: rate)
            delegate?.updateExchangeRate(self,bitcoinModel:bitcoinModel)
            
        }catch {
            delegate?.didFailWithError(self, error: error)
        }
        
    }
    
    
    
    
}

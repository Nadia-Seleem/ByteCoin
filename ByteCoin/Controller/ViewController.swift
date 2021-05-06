//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
 
    

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }


    
}

extension ViewController:UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return coinManager.getNumberOfCurrenciesAvailable()
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.getCurrencyArray()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        coinManager.getCoinPrice(for:coinManager.getCurrencyArray()[row])
    }
    

}

extension ViewController:CoinManagerDelegate{
    func updateExchangeRate(_ coinManager: CoinManager, bitcoinModel: BitcoinModel) {
        DispatchQueue.main.async {
            self.currencyLabel.text = bitcoinModel.currency
            self.bitcoinLabel.text = String(format:"%0.2f",bitcoinModel.rate)
        }
    }
    
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print(error)
    }
}

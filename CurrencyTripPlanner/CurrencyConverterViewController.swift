//
//  ViewController.swift
//  CurrencyTripPlanner
//
//  Created by YiC Wang on 10/4/23.
//

import UIKit

class CurrencyConverterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var amountEntered: UITextField!
    @IBOutlet weak var pickFrom: UIPickerView!
    @IBOutlet weak var convertTo: UIPickerView!
    @IBOutlet weak var amountConverted: UITextView!
    
    let currencies = ["USD", "EUR", "CNY", "JPY", "CAD", "MYR", "VND", "SEK", "MXN"
    , "KRW", "INR", "AED"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPickers()
        loadPickerDefaults()
    }

    func setupPickers() {
        pickFrom.delegate = self
        pickFrom.dataSource = self
        convertTo.delegate = self
        convertTo.dataSource = self
    }

    func loadPickerDefaults() {
        let fromCurrencyIndex = UserDefaults.standard.integer(forKey: "fromCurrencyIndex")
        let toCurrencyIndex = UserDefaults.standard.integer(forKey: "toCurrencyIndex")
        pickFrom.selectRow(fromCurrencyIndex, inComponent: 0, animated: false)
        convertTo.selectRow(toCurrencyIndex, inComponent: 0, animated: false)
    }
    
    @IBAction func convertButtonPressed(_ sender: UIButton) {
        guard let amountText = amountEntered.text, let amount = Double(amountText) else {
            print("Invalid input!")
            return
        }
        
        let fromCurrency = currencies[pickFrom.selectedRow(inComponent: 0)]
        let toCurrency = currencies[convertTo.selectedRow(inComponent: 0)]
        
        fetchConversionRate(from: fromCurrency, to: toCurrency, amount: amount)
        
        saveSelectedCurrency(fromIndex: pickFrom.selectedRow(inComponent: 0), toIndex: convertTo.selectedRow(inComponent: 0))
        
        let numberOfMoneyImages = 10
        let screenSize = UIScreen.main.bounds.size

        for i in 0..<numberOfMoneyImages {
            let moneyImageView = UIImageView(image: UIImage(named: "MoneyIcon"))
            moneyImageView.frame = CGRect(x: CGFloat.random(in: 0..<screenSize.width), y: -100, width: 50, height: 50)
            self.view.addSubview(moneyImageView)
            
            let animationDuration: TimeInterval = 1.0 + TimeInterval(CGFloat.random(in: 0...2))
            
            let animationDelay: TimeInterval = TimeInterval(i) * 0.2

            UIView.animate(withDuration: animationDuration, delay: animationDelay, options: .curveLinear, animations: {
                moneyImageView.frame.origin.y = screenSize.height
            }, completion: { finished in
                moneyImageView.removeFromSuperview()
            })
        }
    }
    
    func fetchConversionRate(from: String, to: String, amount: Double) {
        let apiKey = "99ceae03b1d7ec4675bfc8a9b422d3c1"
        let urlString = "https://api.exchangeratesapi.io/v1/convert?access_key=\(apiKey)&from=\(from)&to=\(to)&amount=\(amount)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["result"] as? Double,
                   let info = json["info"] as? [String: Any],
                   let rate = info["rate"] as? Double { 
                    DispatchQueue.main.async {
                        self?.amountConverted.text = String(format: "%.2f", result)
                        self?.saveConversion(amount: amount, fromCurrency: from, toCurrency: to, rate: rate, result: result)
                    }
                } else {
                    print("JSON parsing error: conversion result not found")
                }
            } catch {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
        
    func saveSelectedCurrency(fromIndex: Int, toIndex: Int) {
        UserDefaults.standard.set(fromIndex, forKey: "fromCurrencyIndex")
        UserDefaults.standard.set(toIndex, forKey: "toCurrencyIndex")
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === pickFrom {
            UserDefaults.standard.set(row, forKey: "pickFromCurrencyIndex")
        } else if pickerView === convertTo {
            UserDefaults.standard.set(row, forKey: "convertToCurrencyIndex")
        }
    }

    
    func saveConversion(amount: Double, fromCurrency: String, toCurrency: String, rate: Double, result: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let conversionHistory = ConversionHistory(context: context)
        conversionHistory.amount = amount
        conversionHistory.fromCurrency = fromCurrency
        conversionHistory.toCurrency = toCurrency
        conversionHistory.rate = rate
        conversionHistory.result = result
        conversionHistory.date = Date()
        
        do {
            try context.save()
            print("Conversion saved successfully")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}


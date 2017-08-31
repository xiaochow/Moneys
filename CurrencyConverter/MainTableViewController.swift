//
//  MainTableViewController.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/15/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UITextFieldDelegate {
    
    //  MARK: Properties
    var currencies = [Currency]()
    
    // To store the two rates in this view.
    var rate1 : Double = 0
    var rate2 : Double = 0
    
    // To store the TapGesture to dismiss the keyboard when the amount is being edited.
    var tab = UITapGestureRecognizer()
    
    @IBOutlet weak var name1Label: UILabel!
    @IBOutlet weak var country1Label: UILabel!
    @IBOutlet weak var name2Label: UILabel!
    @IBOutlet weak var country2Label: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load currencies or sample currencies for the first time.
        if let savedCurrecncies = loadCurrencies() {
            
            currencies = savedCurrecncies
        }
        else {
            loadSampleCurrencies()
        }
        
        // Initialize the view when it is opened.
        resultLabel.text = "= 0.0000"
        amountTextField.text = ""
     
        amountTextField.delegate = self
        self.saveCurrencies()
        
        // Set up the two selected currencies
        settingUp()
        
    }

    // To load sample currencies.
    func loadSampleCurrencies(){
        
        let c1 = Currency(name: "US Dollar", country: "The US", rate: 1.00)!
        let c2 = Currency(name: "Chinese Yuan", country: "China", rate: 6.67)!
        let c3 = Currency(name: "Euro", country: "Europe", rate: 0.89)!
        let c4 = Currency(name: "Japanese Yen", country: "Japan", rate: 113.64)!
        let c5 = Currency(name: "Canadian Dollar", country: "Canada", rate: 1.32)!
        let c6 = Currency(name: "South Korean Won", country: "South Korea", rate: 1190.48)!
        let c7 = Currency(name: "Brazilian Real", country: "Brazil", rate: 3.57)!
        
        currencies += [c1, c2, c3, c4, c5, c6, c7]

    }
    
    // Set up two table cells based on the two selections.
    func settingUp() {
        
        // When selected currencies are deleted.
        if Currency.firstSelection >= currencies.count {
            Currency.firstSelection = 0
        }
        if Currency.secondSelection >= currencies.count {
            Currency.secondSelection = 0
        }
        
        name1Label.text = currencies[Currency.firstSelection].name
        country1Label.text = currencies[Currency.firstSelection].country
        rate1 = currencies[Currency.firstSelection].rate
            
        name2Label.text = currencies[Currency.secondSelection].name
        country2Label.text = currencies[Currency.secondSelection].country
        rate2 = currencies[Currency.secondSelection].rate
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // When text field is being edited, activate the tap recognizer, when a tap is detected
        //  anywhere on the screen, the keyborad will be dismissed.
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainTableViewController.dismissKeyboard))
        tab = tap
        view.addGestureRecognizer(tap)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Display the result on the screen.
        let amount = Double(textField.text!) ?? 0.0000
        let result = amount * (rate2 / rate1)
        resultLabel.text = "= " + String(format: "%.4f", result)

    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
        // Remove the tap recognizer so it does not affect other tap functions.
        view.removeGestureRecognizer(tab)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //  MARK: Actions
    
    @IBAction func unwindToMainTable(_ sender: UIStoryboardSegue) {
        
        // Update the latest version of currencies.
        currencies = loadCurrencies()!
        
        // Get the selection value from one of two senders.
        if let sourceViewController = sender.source as? SelectionTableViewController {
                Currency.firstSelection = sourceViewController.first
        }
        else if let SourceViewController = sender.source as? SecondSelectionTableViewController {
                Currency.secondSelection = SourceViewController.second
        }
        
        saveCurrencies()
        
        // Refresh the view.
        settingUp()
        textFieldDidEndEditing(amountTextField)
    }
    
    // When the swap button is tapped.
    @IBAction func swap(_ sender: UIButton) {
        
        let x = Currency.firstSelection
        Currency.firstSelection = Currency.secondSelection
        Currency.secondSelection = x
        
        settingUp()
        saveCurrencies()
        textFieldDidEndEditing(amountTextField)
    }
    
    // When the clear button is tapped.
    @IBAction func clear(_ sender: UIButton) {
    
        resultLabel.text = "= 0.0000"
        amountTextField.text = ""
        
    }
    
    // MARK: NSCoding
    
    func saveCurrencies() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(currencies, toFile: Currency.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save currencies...")
        }
    }
    
    func loadCurrencies() -> [Currency]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Currency.ArchiveURL.path) as? [Currency]
    }

}

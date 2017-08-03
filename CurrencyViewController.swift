//
//  CurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/13/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController, UITextFieldDelegate{

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var rateTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var currency: Currency?
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        countryTextField.delegate = self
        rateTextField.delegate = self
        
        // Enable the save button only when the input is valid.
        checkValidInput()
        
        // Look for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CurrencyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkValidInput()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        //  Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    // Check if the input information is valid.
    func checkValidInput() {
        
        let text1 = nameTextField.text ?? ""
        let text2 = countryTextField.text ?? ""
        let text3 = rateTextField.text ?? ""
        
        saveButton.isEnabled = !text1.isEmpty || !text2.isEmpty || !text3.isEmpty
    }
    
    // Call this function when the tap is recognized.
    func dismissKeyboard() {

        // Cause the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: Actions
    
    // When cancel button is tapped.
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as! UIBarButtonItem! {
            if saveButton === button {
                let name = nameTextField.text ?? ""
                let country = countryTextField.text ?? ""
                let rateString = rateTextField.text ?? ""
                let rate = Double(rateString) ?? 0.00
                
                // Set the currency to be passed to CurrencyTableViewController after the unwind segue.
                currency = Currency(name: name, country: country, rate: rate)
                
            }
        }
    }


    
}

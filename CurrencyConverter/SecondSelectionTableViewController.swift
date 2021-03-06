//
//  SelectionTableViewController.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/14/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class SecondSelectionTableViewController: UITableViewController {
    
    //  MARK: Properties
    var currencies = [Currency]()
    
    //  To store the second selection.
    var second = 1
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load currencies.
        currencies = LocalStorage.shared.currencies
        
        // When the selected currency is deleted.
        if Currency.secondSelection >= currencies.count {
            Currency.secondSelection = 0
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionTableViewCell", for: indexPath) as! SelectionTableViewCell
        
        // Configure the cell.
        let currency = currencies[indexPath.row]
        cell.nameLabel.text = currency.name
        cell.countryLabel.text = currency.country
        
        // Configure the checkmark.
        if Currency.secondSelection == indexPath.row {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set the selection value to the index of selected row.
        Currency.secondSelection = indexPath.row
        tableView.reloadData()
    }
    

    //  This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        LocalStorage.shared.currencies = self.currencies
    }
    
}

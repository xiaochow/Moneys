//
//  SelectionTableViewController.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/14/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class SelectionTableViewController: UITableViewController {

    //  MARK: Properties
    var currencies = [Currency]()
    
    //  To store the first selection.
    var first = 0
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load currencies.
        let savedCurrecncies = loadCurrencies()!
        currencies = savedCurrecncies
        
        //  When the selection was deleted in the list.
        if Currency.firstSelection >= currencies.count {
            Currency.firstSelection = 0
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source.
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
        
        //  Configure the checkmark.
        if Currency.firstSelection == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set the selection value to the index of selected row.
        Currency.firstSelection = indexPath.row
        tableView.reloadData()
        
    }
    
    //  This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as! UIBarButtonItem! {
            if self.backButton == button {
                first = Currency.firstSelection
            }
        }

    }
    
    // MARK: NSCoding
    
    func loadCurrencies() -> [Currency]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Currency.ArchiveURL.path) as? [Currency]
    }


}

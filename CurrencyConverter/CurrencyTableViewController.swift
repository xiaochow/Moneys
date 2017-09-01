//
//  CurrencyTableViewController.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/13/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class CurrencyTableViewController: UITableViewController {
    
    // MARK: Properties
    var currencies = [Currency]()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load currencies.
        let savedCurrecncies = loadCurrencies()!
        currencies = savedCurrecncies

        // Activate the edit button provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Set up the refresher.
        self.refresher = UIRefreshControl()
        self.tableView.addSubview(refresher)
        self.refresher.tintColor = UIColor.black
        let attributes = [NSForegroundColorAttributeName : UIColor.black] as [String: Any]
        self.refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        self.refresher.addTarget(self, action: #selector(fetchOnlineData), for: .valueChanged)
    }
    
    func fetchOnlineData() {
        
        let url = NSURL(string:"http://api.fixer.io/latest?base=USD")!
        let task = URLSession.shared.dataTask(with: url as URL, completionHandler: {(data, response, error) in
            
            if let sourceData = data {
                
                let dataStr = NSString(data: sourceData, encoding: String.Encoding.utf8.rawValue)! as String
                
                if let json = self.jsonToDict(dataStr) {
                    
                    let rates = json["rates"]!
                    
                    self.currencies[1].rate = rates["CNY"] as! Double
                    self.currencies[2].rate = rates["EUR"] as! Double
                    self.currencies[3].rate = rates["JPY"] as! Double
                    self.currencies[4].rate = rates["CAD"] as! Double
                    self.currencies[5].rate = rates["KRW"] as! Double
                    self.currencies[6].rate = rates["BRL"] as! Double
                    
                    self.saveCurrencies()
                }
            }
            else {
               // No Internet connection alert.
            }
        })
                
        task.resume()
        
        self.tableView.reloadData()
        self.refresher.endRefreshing()

    }
    
    // JSON to Dictionary.
    func jsonToDict(_ text: String) -> [String:AnyObject]? {
        
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            } catch _ as NSError {
                print("Failed to create dictionary for JSON.")
            }
        }
        return nil
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell

        // Configure the cell
        let currency = currencies[indexPath.row]
        cell.nameLabel.text = currency.name
        cell.countryLabel.text = currency.country
        cell.rateLabel.text = String(format: "%.2f", currency.rate)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        // Only customized currencies can be deleted.
        if indexPath.row < 7 {
            return false
        }
        return true
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // Only delete operation is allowed.
        if editingStyle == .delete {
            
            // Delete the row from the data source
            currencies.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        saveCurrencies()
    }


    // Function connected to the segue.
    @IBAction func unwindToCurrencyList(_ sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? CurrencyViewController, let currency = sourceViewController.currency {
            
            // Add a new currency.
            let newIndexPath = IndexPath(row: currencies.count, section: 0)
            currencies.append(currency)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            
        }
        
        saveCurrencies()
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

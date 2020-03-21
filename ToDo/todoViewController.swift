//
//  ViewController.swift
//  ToDo
//
//  Created by Rishabh on 21/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit

class todoViewController: UITableViewController{

    var baseArr = ["eggs", "rad" ,"sky"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        cell.textLabel?.text = baseArr[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(baseArr[indexPath.row])
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var str = UITextField()
        let alert = UIAlertController(title: "Add a New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.baseArr.append(str.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (textF) in
            textF.placeholder = "Create New Item"
            str = textF
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
}



//
//  categoryTableViewController.swift
//  ToDo
//
//  Created by Rishabh on 22/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class categoryTableViewController: swipeTableViewController {

    let realm = try! Realm()
    var catArr : Results<Category>!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        loaditems()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none

       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catArr?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = catArr?[indexPath.row].name ?? "No Categories Added"
        if let catColor = UIColor(hexString: catArr[indexPath.row].color){
        cell.backgroundColor = catColor
        cell.textLabel?.textColor = ContrastColorOf(catColor, returnFlat: true)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destVC = segue.destination as! todoViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destVC.selectCat = catArr[indexpath.row]
        }
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var text = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newit = Category()
            newit.name = text.text!
            newit.color = UIColor.randomFlat.hexValue()
            self.saveItems(cat: newit)
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (textF) in
            textF.placeholder = "Create a new category"
            text = textF
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems(cat : Category){
        do{
            try realm.write{
                realm.add(cat)
            }
            print(" cat data saved")
        }
        
        catch{
            print("error saving data \(error)")
        }
        self.tableView.reloadData()
    }
    
        func loaditems(){
        
            catArr = realm.objects(Category.self)
            
            tableView.reloadData()
    }
    
    override func updatemodel(at Indexpath :IndexPath) {
        if let curcat = self.catArr?[Indexpath.row]{
        do{
            try self.realm.write{
                self.realm.delete(curcat)
            }
        }
        catch{
            print(error)
        }
        }
        self.tableView.reloadData()
    }
}


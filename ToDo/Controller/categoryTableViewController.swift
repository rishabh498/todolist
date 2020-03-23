
//
//  categoryTableViewController.swift
//  ToDo
//
//  Created by Rishabh on 22/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit
import RealmSwift

class categoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var catArr : Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loaditems()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        
        
        cell.textLabel?.text = catArr![indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
        
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
}

//extension categoryTableViewController : UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let req : NSFetchRequest<Category> = Category.fetchRequest()
//
//        req.predicate = NSPredicate(format: "category CONTAINS[cd] %@", searchBar.text!)
//        req.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
//
//        loaditems(with: req)
//
//    }
//
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        if searchBar.text?.count == 0{
//            loaditems()
//        }
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
//    }
//
//}

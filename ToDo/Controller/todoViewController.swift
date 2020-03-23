//
//  ViewController.swift
//  ToDo
//
//  Created by Rishabh on 21/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit
import RealmSwift


class todoViewController: UITableViewController{

    var todoItems: Results<Item>?

    let realm = try! Realm()
    
    var selectCat : Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
          loadItems()

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
                    cell.textLabel?.text = item.title
            }
        else{
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
       // todoItems[indexPath.row].done = !todoItems[indexPath.row].done

        //self.saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            if let currentCategory = self.selectCat{
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        //newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manupulation Methods
    
    
    
    func loadItems() {
        
        todoItems = selectCat?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
}

//extension todoViewController : UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        let req : NSFetchRequest<Item> = Item.fetchRequest()
//       let predic = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        
//       req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//       loadItems(with: req, predicate: predic)
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//        
//        DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//        }
//    }
//}
//}


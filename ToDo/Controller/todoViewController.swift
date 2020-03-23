//
//  ViewController.swift
//  ToDo
//
//  Created by Rishabh on 21/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class todoViewController: swipeTableViewController{

    var todoItems: Results<Item>?

    let realm = try! Realm()
    
    var selectCat : Category?{
        didSet{
            loadItems()
        }
    }
    
    @IBOutlet weak var sea: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.separatorStyle = .none
        tableView.rowHeight = 70.0
     
    }
    override func viewWillAppear(_ animated: Bool) {
        title = selectCat!.name
        guard let colorHex = selectCat?.color else{fatalError()}
        updateNavbar(withhexString: colorHex)
        
    }
    
    func updateNavbar(withhexString colorHex : String){
        
        guard let navbar = navigationController?.navigationBar else {fatalError()
        }
        guard let navColor =  UIColor(hexString: colorHex) else {fatalError()}
        
        navbar.barTintColor = navColor
        navbar.tintColor = ContrastColorOf(navColor, returnFlat: true)
        sea.barTintColor = navColor
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
                    cell.textLabel?.text = item.title
                    cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: self.selectCat!.color)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf( color, returnFlat: true)
            }
            }
        else{
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
       if let item = todoItems?[indexPath.row]{
            
        do{
            try realm.write{
                
                item.done = !item.done
            }
        }
        catch{
            print(error)
            }
        }
        
        self.tableView.reloadData()
        
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
    
    override func updatemodel(at Indexpath: IndexPath) {
        
        if let curTodo = todoItems?[Indexpath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(curTodo)
                }
                self.tableView.reloadData()
            }
            catch{
                print(error)
            }
            
        }
    }
}

extension todoViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
       print("TRIED SEARCHING")
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
}


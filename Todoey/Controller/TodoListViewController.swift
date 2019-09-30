//
//  TodoListViewController.swift
//  Todoey
//
//  Created by george.dima on 25/09/2019.
//  Copyright © 2019 george.dima. All rights reserved.
//


import UIKit
import RealmSwift


class TodoListVewController: UITableViewController {
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
        
            cell.textLabel?.text = item.name
        
        cell.accessoryType = item.check ? .checkmark : .none 
        
        } else {
            cell.textLabel?.text = "No items added "
        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.check = !item.check
                }
                } catch {
                    print("Error saving check status, \(error)")
                }
            }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        }

        
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add items", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.name = textField.text!
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving items,\(error)")
                }
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
        alertTextField.placeholder = "Add new items in Todoey list"
        textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: -  Model Manipulation Methods
    
   

    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
       
        tableView.reloadData()
    }

  }

//// MARK: - Search bar methods

extension TodoListVewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    toDoItems = toDoItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }

}



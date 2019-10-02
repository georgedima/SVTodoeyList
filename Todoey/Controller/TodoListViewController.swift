//
//  TodoListViewController.swift
//  Todoey
//
//  Created by george.dima on 25/09/2019.
//  Copyright © 2019 george.dima. All rights reserved.
//


import UIKit
import RealmSwift
import ChameleonFramework


class TodoListVewController: SwipeTableViewController {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
             title = selectedCategory?.name

            guard let colourHex = selectedCategory?.color else {fatalError()}
            
            updateNavBar(withHexCode: colourHex)
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
       
        guard let navBar = navigationController?.navigationBar else {fatalError()}

        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
    
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)
        searchBar.barTintColor = navBarColour
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: navBarColour, returnFlat: true)]
        
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
        
            cell.textLabel?.text = item.name
        
            if let colour = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colour, returnFlat: true)
            }
            
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
    
    @IBOutlet weak var searchBar: UISearchBar!
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
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }catch {
                print(error)
            }
        }
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



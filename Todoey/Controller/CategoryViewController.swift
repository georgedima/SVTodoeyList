//
//  CategoryViewController.swift
//  Todoey
//
//  Created by george.dima on 27/09/2019.
//  Copyright © 2019 george.dima. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        guard let categoryColour = UIColor(hexString: categories?[indexPath.row].color) else {fatalError()}
        
        cell.backgroundColor = categoryColour
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: categoryColour, returnFlat: true)
        
        return cell
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category,\(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion.items)
                    realm.delete(categoryForDeletion)
                    
                }
            }
            catch {
                print(error)
            }
            
        }
    }
    
    //MARK: - Add New Categories
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        
        do{
            try realm.write {
                realm.deleteAll()
                tableView.reloadData()
            }
        } catch {
            print(error)
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat()?.hexValue() ?? "5AC8FA"
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category in Todoey category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
}



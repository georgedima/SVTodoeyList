//
//  CategoryViewController.swift
//  Todoey
//
//  Created by george.dima on 27/09/2019.
//  Copyright © 2019 george.dima. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
 
     var categoryArray = [Categorys]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategory () {
        
        do {
            try context.save()
        } catch {
            print("Error saving category,\(error)")
        }
        tableView.reloadData()
    }
    
    
    func loadCategory() {
        let request : NSFetchRequest<Categorys> = Categorys.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categorys,\(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories


    @IBAction func buttonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let newCategory = Categorys(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            self.saveCategory()
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }

}

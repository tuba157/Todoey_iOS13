//
//  CategoryViewController.swift
//  Todoey_iOS13
//
//  Created by Tuba  Yalcinoz on 14.10.21.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryItemArray = [Category]()
    
    // AppDelegate is a class we need the object (use singleton) of the class to use context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath)
        let item = categoryItemArray[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }
    

    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryItemArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    // What should happen when I click to a category
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: K.segueToItems, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create a reference
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Inside if because it is an optional
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryItemArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    // Save and load data to use "crud"
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving category \(error)")
        }
        self.tableView.reloadData()
    }
    
    // request to read data from the context
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryItemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

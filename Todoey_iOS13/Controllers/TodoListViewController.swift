//
//  ViewController.swift
//  Todoey_iOS13
//
//  Created by Tuba Yalcinoz based on App Brewery on 19.09.21.
//

// DELETE A NSManagedObject --> order is IMPORTANT
// context.delete(itemArray[indexPath.row])
// itemArray.remove (at: indexPath.row)]
// saveItems()

import UIKit
import CoreData
// We inherited from UITableViewController

// Alternatively we can keep the UIViewController then we have to add
// self.TableView.delegate
// and link up the UIOutlets and override functions
// But by changing to UITableViewController all of that is outamated from the Xcode.

// SUBCLASSING
// UISearchBarDelegate sees if there is a change on search bar
class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    // AppDelegate is a class we need the object (use singleton) of the class to use context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        loadItems()
    }
    
    //MARK: - Tableview Datasource Methods
    // DataSource is responsible for populating the TableView, telling it how many cells it needs and which cells to put in to the TableView.
    
    // What the cells should display
    // How many rows we want in our TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Function returns a UITableViewCell and called as many times as there are cells
    // indexPath shows us the position
    // cellForRowAt called initilly when the tableView is loaded up.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create and return a cell
        // Cast this ReusableCell as ToDoItemCell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        //        if item.done == false{
        //            cell.accessoryType = .none
        //        }else{
        //            cell.accessoryType = .checkmark
        //        }
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Give Checkmark as an accessory if it doesnt have it already
        // Remove the checkmark when selected if it is already selected.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Function saveItem also reload the data --> UPDATE fom CRUD
        saveItems()
        
        // The cell flashes grey but it goes back to being deselected and goes back to beig white
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // textField has the scope of the whole addButtonPressed IBAction
        // Store and read data from a local variable inside the IBAction
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (action) in
            // Closure
            // What will happen once the user clicks the Add Item button on our UIAlert
            // Get what is in alertTextField and save it to the itemArray
            // Unwrap it because it is an optional
            
            
            // Initialize CoreData Object --> NSManagedObject
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
            // Save updated itemArray
            self.saveItems()
            
        }
        
        // Adding a TextField or an Action to an alert is quite similar
        alert.addTextField {
            (alertTextField) in
            // Inside the closure
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
            // It doesnt work because this closure only gets triggered once the textField has been added to the alert
            // print(alertTextField.text)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems(){
        
        // Commit context to perminant storage inside our persistentContainer (lazy var persistentContainer)
        do {
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    // with is extternal parameter default patches all of the items from persistance store
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
            // Fetch request hols what is currently in the container.
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

//MARK: - SearchBar Delegate Methods

// Using extensions for specific segments and this way easy debugging
extension ToDoListViewController:  UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Create requset to read data from the context
        // requset returns an array of Item's.
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // Filtering  --> Predicate specifies how we want to query our database
        // Looking for the title attribute of each of our Items in Itemarray
        // %@ --> to look for the argument
        // [cd] --> case insensitive
        // Querylanguage
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        // Sortting alphabettically
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        
        // Array of multiple SortDescriptors but also can have one SortDescriptor
        request.sortDescriptors = [sortDescriptr]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // DispatchQueue manages the execution of work items. Update the UI
            DispatchQueue.main.async {
                // It should no longer be the thing, that is selected.
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
}

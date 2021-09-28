//
//  ViewController.swift
//  Todoey_iOS13
//
//  Created by Tuba Yalcinoz based on App Brewery on 19.09.21.
//

import UIKit
// We inherited from UITableViewController

// Alternatively we can keep the UIViewController then we have to add
// self.TableView.delegate
// and link up the UIOutlets and override functions
// But by changing to UITableViewController all of that is outamated from the Xcode.

// SUBCLASSING
class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // Using UserDefaults to Store PersistentLocal Data
    // An Interface to the User's defaults database, where you store key-value pairs persistently across launches of your app
    // UserDefault is going to be saved in .plist file --> KEY-VALUE PAIR
    // let defaults = UserDefaults.standard
    // We are going to create our own .plist instead of using user defaults to save our own Objects.
    
    // Create file path
    // File Manager provides an interface to the contents of the file system
    // Singleton --> .default it means that it is shared
    // We are getting the first item from the array
    // .appendingPathComponent(pathComponent: String)  TO CREATE OUR OWN .plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
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
        
        // Function saveItem also reload the data
        saveItems()
        
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }else{
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        }
        
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
            let newItem = Item()
            newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to:dataFilePath!)
        }catch{
            print("Error encoding item array,  \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        // try? to unwrap
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch { 
                print("Error decoding item array \(error)")
            }
        }
    }
}



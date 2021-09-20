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
// and link up the UIOutlets
// override functions
// But by changing to UITableViewController all of that is outamated from the Xcode.

// SUBCLASSING
class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create and return a cell
        // Cast this ReusableCell as ToDoItemCell
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Give Checkmark as an accessory if it doesnt have it already
        // Remove the checkmark when selected if it is already selected.
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
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
            self.itemArray.append(textField.text!)

            self.tableView.reloadData()
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
}




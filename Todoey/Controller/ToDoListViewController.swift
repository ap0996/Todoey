//
//  ViewController.swift
//  Todoey
//
//  Created by Aanchal Patial on 07/06/19.
//  Copyright © 2019 AP. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let newItem1 = Item()
        newItem1.title = "study spanish"
        itemArray.append(newItem1)
        
        let newItem3 = Item()
        newItem3.title = "look into ios dev"
        itemArray.append(newItem3)
        
        let newItem2 = Item()
        newItem2.title = "shopping for mom"
        itemArray.append(newItem2)
        
     
        
        // Do any additional setup after loading the view.
//        if let item = defaults.array(forKey: "itemArrayList") as? [Item] {
//            itemArray = item
//        }
        loadItems()
        
    }
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
       //Ternany Operator
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveNewItems()
        tableView.deselectRow(at: indexPath, animated: true)
    
    }
    
    //MARK - Add New Item
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveNewItems()
            
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write here ..."
            textField = alertTextField
        }
        present(alert,animated: true,completion: nil)
    }
    
    func saveNewItems() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error encoding items.")
        }
        
        self.tableView.reloadData()
    }
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error decoding data")
            }
        }
    }
    
}


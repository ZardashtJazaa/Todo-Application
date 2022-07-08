//
//  ViewController.swift
//  TaskTime
//
//  Created by Zardasht  on 27/05/2022.
//

import UIKit
//import SwipeCellKit
//import CoreData
import RealmSwift
import ChameleonFramework

class ItemContoller: SwipeTableViewController {

   // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   let realm = try! Realm()
    //var itemArray =  [Items]()
    var todoItems: Results<Items>?
    
    @IBOutlet weak var searchBarItems: UISearchBar!
    
    
    var selectedCategory: Category?{
        didSet{
            
            loadItems()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 50.0
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
       // navigationItem.
    }
  
    //MARK: Colors Navbar 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let  colorHex = selectedCategory?.Color{
            
            let MainColors =  UIColor(hexString: colorHex)
            
            searchBarItems.barTintColor = MainColors
            searchBarItems.searchTextField.backgroundColor = FlatWhite()
            searchBarItems.searchTextField.textColor = MainColors
            searchBarItems.tintColor = MainColors
            
            guard let navbar  = navigationController?.navigationBar else{fatalError("Navigation Controller does not Exist.")}
            
            navbar.standardAppearance.backgroundColor = UIColor(hexString: colorHex)
            navbar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: colorHex)
           
            

        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return itemArray.count
        return todoItems?.count ?? 1
    }
    
    
    //MARK: Modifying Text Of Cell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ItemIdentifier", for: indexPath) as! SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //cell.textLabel?.text = itemArray[indexPath.row].title
        //cell.accessoryType = itemArray?[indexPath.row].done ? .checkmark : .none
        
        if let item  = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            
            if let colors = selectedCategory?.Color{
                let MainColors =  UIColor(hexString: colors)
                if let color = MainColors!.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                    cell.tintColor = ContrastColorOf(color, returnFlat: true)
                }
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            
        }else{
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        //cell.delegate = self
        return cell

    }
    
    
    //MARK: Deleting Items From swipe
    override func Update(at indexPath: IndexPath) {
       // print("I get called in ItemController")
        if let ItemsDeletions = self.todoItems?[indexPath.row]{
            DispatchQueue.main.async {
                do{
                    try self.realm.write {
                        self.realm.delete(ItemsDeletions)
                        self.tableView.reloadData()
                    }
                }catch{
                    print("Error deleting Items \(error)")
                }
            }
            
            
        }

    }
        

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)
                }
                
            }catch{
                print("Error saving Check Mark Status \(error)")
            }
        }
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    
    // MARK: AddItemPressed
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Items", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { action in

            if textField.text!.isEmpty{

            }else{
                if let currentCategory = self.selectedCategory{
                    
                   
                    do{
                        try self.realm.write {
                            
                            let newItems = Items()
                            newItems.title = textField.text!
                            newItems.dateCreated = Date()
                            currentCategory.items.append(newItems)
                            
                        }
                        }catch{
                            print("Error to write data inside AddItem \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addTextField { UItextField in
            UItextField.placeholder = "Add Items"
            textField = UItextField
        }
        alert.addAction(action)
        present(alert, animated: true)


    }
    
//    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
//        var textField = UITextField()
//        let alert = UIAlertController(title: "Add Items", message: "", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Add", style: .default) { action in
//
//            if textField.text!.isEmpty{
//
//            }else{
//                let newItems  = Items(context: self.context)
//                newItems.parentCategory = self.selectedCategory
//                newItems.done = false
//                newItems.title = textField.text!
//                self.itemArray.append(newItems)
//                self.saveItems()
//                self.tableView.reloadData()
//            }
//
//        }
//
//        alert.addTextField { UItextField in
//            UItextField.placeholder = "Add Items"
//            textField = UItextField
//        }
//        alert.addAction(action)
//        present(alert, animated: true)
//
//
//    }
    
//    func saveItems(items:Items){
//        do{
//            try realm.write {
//               realm.add(items)
//           }
//        }catch{
//            print("Error to save Items \(error)")
//        }
//    }
        
    
//
//        do{
//            try context.save()
//
//        }catch{
//            print("Error to save Context \(error)")
//        }
//        tableView.reloadData()
//    }
    
    
//    func loadItems(with request: NSFetchRequest<Items> = Items.fetchRequest() , predicate:NSPredicate? = nil){
//
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",selectedCategory!.name!)
//
//
//        if let additionalPredicate = predicate{
//            request.predicate =  NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//
//        do{
//             itemArray = try context.fetch(request)
//        }catch{
//            print("error to loadItems \(error)")
//        }
//        tableView.reloadData()
//    }
    // MARK: loadItmes
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}



// MARK: Extentions Searchbar
extension ItemContoller: UISearchBarDelegate{
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "title", ascending: true)
        
        
//        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()


        if searchBar.text!.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//extension ItemContoller: UISearchBarDelegate{
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        let request : NSFetchRequest<Items> = Items.fetchRequest()
//        let searchPredicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: searchPredicate)
//
//        if searchBar.text!.count == 0{
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//
//}

// MARK: SwipeCell Items

//extension ItemContoller:SwipeTableViewCellDelegate{
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        //print("I am Edit")
//        guard orientation == .right else { return nil }
//
//        
//    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//
//        if let ItemsDletions = self.todoItems?[indexPath.row]{
//
//            do{
//                try self.realm.write {
//                    self.realm.delete(ItemsDletions)
//                    self.tableView.reloadData()
//                }
//            }catch{
//                print("Error deleting Items \(error)")
//            }
//        }
//
//    }
//
//           deleteAction.image = UIImage(systemName: "trash.fill")
//           return [deleteAction]
//
//        }
//
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive(automaticallyDelete: false, timing: .after)
//        //options.transitionStyle = .border
//        return options
//
//    }
//}
    





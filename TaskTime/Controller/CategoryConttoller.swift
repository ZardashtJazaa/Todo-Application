//
//  CategoryConttoller.swift
//  TaskTime
//
//  Created by Zardasht  on 27/05/2022.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryConttoller: SwipeTableViewController {
    
    
    
    let realm = try! Realm()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var Categories : Results<Category>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Category"
        
        guard let navbar = navigationController?.navigationBar else{fatalError("navigation bar dose not exist.")}
        
        navbar.standardAppearance.backgroundColor = UIColor(hexString: "F2D1D1")
        navbar.scrollEdgeAppearance?.backgroundColor = UIColor(hexString: "F2D1D1")
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        //tableView.rowHeight = 50.0
        //tableView.separatorStyle = .none
       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Categories?.count ?? 1
    }
    
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryIdenifier", for: indexPath) as! SwipeTableViewController
//        if let categories = Categories?[indexPath.row]{
//            cell.textLabel?.text = categories.name  ?? "No Categories Added Yet"
//            cell.backgroundColor = UIColor(hexString:categories.Color ?? "1D9BF6" )
//        }
        cell.textLabel?.text = Categories?[indexPath.row].name  ?? "No Categories Added Yet"
        cell.backgroundColor = UIColor(hexString:Categories?[indexPath.row].Color ?? "1D9BF6" )
        cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
        
        return cell
    }
    
   
    // MARK: deleteCategory Swipe
    override func Update(at indexPath: IndexPath) {
        //print("I get called in categoryController")
        if let categoryForDeletions = Categories?[indexPath.row]{
            if categoryForDeletions.items.isEmpty{
                    DispatchQueue.main.async {
                        do{
                             try self.realm.write({
                                 //self.realm.delete(categotyForDeletions.items)
                                 self.realm.delete(categoryForDeletions)
                             })

                         }catch{
                             print("Error to Delete Items Of Categories \(error)")
                         }
                        self.tableView.reloadData()
                    }
            
            }else{
                let alert = UIAlertController(title: "Warning", message: "All task will be Deleting to!", preferredStyle: .alert)
                        let actions = UIAlertAction(title: "Delete", style: .default) { action in
                            DispatchQueue.main.async {
                                do{
                                     try self.realm.write({
                                         self.realm.delete(categoryForDeletions.items)
                                         self.realm.delete(categoryForDeletions)
                                     })
        
                                 }catch{
                                     print("Error to Delete Items Of Categories \(error)")
                                 }
                                self.tableView.reloadData()
                            }
                    }
                        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                        alert.addAction(actions)
                        self.present(alert, animated: true)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC =  segue.destination as! ItemContoller
        
        if let indexPath = tableView.indexPathForSelectedRow{
            navigationItem.title = Categories?[indexPath.row].name
            destinationVC.selectedCategory = Categories?[indexPath.row]
      
        }
    }

    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "AddCategory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            if textField.text!.isEmpty{
                
            }else{
                let newCategory =  Category()
                //var newColor = UIColor.randomFlat().hexValue()
                newCategory.name = textField.text!
                newCategory.Color = UIColor.randomFlat().hexValue()
                //self.categoryArray.append(newCategory)
                self.save(category: newCategory)
                //self.tableView.reloadData()
            }
         
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add Category"
            textField = alertTextField
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(action)
        present(alert, animated: true)
       
    }
    
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error to  save the Context  \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory(){

        Categories =  realm.objects(Category.self) // pull out all the items

    }
  
//    @objc func backButton(){
//
//    }
  
}

// MARK: > SwipeCell Delegate

//extension  CategoryConttoller:SwipeTableViewCellDelegate{
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        print("I am Edit")
//        guard orientation == .right else { return nil }
//
//
//    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//        DispatchQueue.main.async {
//            self.showWarrning(for: indexPath)
//        }
//    }
//
//
//          // print("Items Deleted")
//           deleteAction.image = UIImage(named: "Trash-Icon")
//           return [deleteAction]
//
//        }
//
//    func showWarrning(for indexPath:IndexPath){
//
//        if let categotyForDeletions = self.Categories?[indexPath.row]{
//
//            if categotyForDeletions.items.isEmpty{
//                DispatchQueue.main.async {
//                    do{
//                         try self.realm.write({
//                             //self.realm.delete(categotyForDeletions.items)
//                             self.realm.delete(categotyForDeletions)
//                         })
//
//                     }catch{
//                         print("Error to Delete Items Of Categories \(error)")
//                     }
//                    self.tableView.reloadData()
//                }
//
//            }else{
//                let alert = UIAlertController(title: "Warning", message: "All task will be Deleting to!", preferredStyle: .alert)
//                let actions = UIAlertAction(title: "Delete", style: .default) { action in
//                    DispatchQueue.main.async {
//                        do{
//                             try self.realm.write({
//                                 self.realm.delete(categotyForDeletions.items)
//                                 self.realm.delete(categotyForDeletions)
//                             })
//
//                         }catch{
//                             print("Error to Delete Items Of Categories \(error)")
//                         }
//                        self.tableView.reloadData()
//                    }
//            }
//                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//                alert.addAction(actions)
//                self.present(alert, animated: true)
//
//
//        }
//    }
//}
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        print("i am callingOptions")
//
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive(automaticallyDelete: false, timing: .after)
//        //options.transitionStyle = .border
//        return options
//
//    }
//}

        // customize the action appearance
   


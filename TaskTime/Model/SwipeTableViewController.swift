//
//  SwipeTableViewController.swift
//  TaskTime
//
//  Created by Zardasht  on 06/06/2022.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 55.0
            
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate =  self
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
       
        guard orientation == .right else { return nil }
        
        
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        
        self.Update(at: indexPath)
        
    }
        
        
          
           deleteAction.image = UIImage(systemName: "trash.fill")
           return [deleteAction]
        
        }
       
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        //print("i am callingOptions")
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive(automaticallyDelete: false, timing: .after)
        //options.transitionStyle = .border
        return options
      
    }
    
    func Update(at indexPath:IndexPath){
        
        //Updating Category TableView
    }
   
    
    
}


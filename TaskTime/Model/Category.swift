//
//  Category.swift
//  TaskTime
//
//  Created by Zardasht  on 30/05/2022.
//

import Foundation
import RealmSwift

class Category:Object{
    
   @objc dynamic var name:String = ""
   @objc dynamic var Color:String = ""
   let items = List<Items>() //forward relationship
    
}

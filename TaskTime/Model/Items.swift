//
//  Items.swift
//  TaskTime
//
//  Created by Zardasht  on 30/05/2022.
//

import Foundation
import RealmSwift

class Items: Object{
    
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool    = false
    @objc dynamic var dateCreated:Date?
    var parentCategory = LinkingObjects(fromType: Category.self , property: "items")
    
}

//
//  item.swift
//  ToDo
//
//  Created by Rishabh on 22/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

//
//  category.swift
//  ToDo
//
//  Created by Rishabh on 22/03/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
    
}

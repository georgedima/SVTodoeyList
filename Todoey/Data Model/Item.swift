//
//  Item.swift
//  Todoey
//
//  Created by george.dima on 30/09/2019.
//  Copyright © 2019 george.dima. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var check : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}

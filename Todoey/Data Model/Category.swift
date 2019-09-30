//
//  Categorys.swift
//  Todoey
//
//  Created by george.dima on 30/09/2019.
//  Copyright © 2019 george.dima. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    
    @objc dynamic var name : String = ""
    let items = List<Item>()
    
}

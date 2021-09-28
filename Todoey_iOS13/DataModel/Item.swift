//
//  Item.swift
//  Todoey_iOS13
//
//  Created by Tuba  Yalcinoz on 22.09.21.
//

import Foundation

// To be Encodable all of its properties datatypes must have a STANDARD Datatype.
class Item : Codable {
    var title: String = ""
    var done: Bool = false
}

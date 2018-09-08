//
//  VMImageModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 26.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VMImageModel : Object, Mappable {
    @objc dynamic var size = ""
    @objc dynamic var text = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        text <- map["#text"]
        size <- map["size"]
    }
}

//
//  VMAlbumModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 24.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VMAlbumModel : Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var title = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ownerId <- map["owner_id"]
        title <- map["title"]
    }
    
}

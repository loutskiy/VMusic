//
//  VMUserModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 24.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VMUserModel : Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var secondName = ""
    @objc dynamic var photo = ""
    @objc dynamic var photoMedium = ""
    @objc dynamic var photoBig = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        firstName <- map["first_name"]
        secondName <- map["last_name"]
        photo <- map["photo"]
        photoMedium <- map["photo_medium"]
        photoBig <- map["photo_big"]
    }
    
}

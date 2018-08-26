//
//  VMSongModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 22.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VMSongModel : Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var artist = ""
    @objc dynamic var title = ""
    @objc dynamic var duration = 0
    @objc dynamic var date = 0
    @objc dynamic var url = ""
    @objc dynamic var isLicensed = true
    @objc dynamic var localPath = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        ownerId <- map["owner_id"]
        artist <- map["artist"]
        title <- map["title"]
        duration <- map["duration"]
        date <- map["date"]
        url <- map["url"]
        isLicensed <- map["is_licensed"]
    }
    
}

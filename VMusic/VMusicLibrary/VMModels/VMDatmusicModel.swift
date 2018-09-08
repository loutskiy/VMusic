//
//  VMDatmusicModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 22.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VMDatmusicModel : VMSongModel {
    @objc dynamic var sourceId = 0
//    @objc dynamic var artist = ""
//    @objc dynamic var title = ""
//    @objc dynamic var duration = 0
//    @objc dynamic var date = 0
    @objc dynamic var genreId = 0
//    @objc dynamic var url = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
//    override static func primaryKey() -> String? {
//        return "sourceId"
//    }
    
    override func mapping(map: Map) {
        sourceId <- map["source_id"]
        artist <- map["artist"]
        title <- map["title"]
        duration <- map["duration"]
        date <- map["date"]
        genreId <- map["genre_id"]
        url <- map["download"]
    }
    
}

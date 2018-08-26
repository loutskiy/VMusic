//
//  VMResponseModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
//import RealmSwift
import ObjectMapper

class VMResponseModel : Mappable {
    
    @objc dynamic var count = 0
    @objc dynamic var items = [VMSongModel]()
    @objc dynamic var status = "ok"
    @objc dynamic var error : VMErrorModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        items <- map["items"]
        status <- map["status"]
        error <- map["error"]
    }
    
}

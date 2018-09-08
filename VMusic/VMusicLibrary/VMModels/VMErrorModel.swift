//
//  VMErrorModel.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 25.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class VMErrorModel : Object, Mappable {
    @objc dynamic var captchaId = 0
    @objc dynamic var captchaImg = ""
    @objc dynamic var captchaIndex = 0
    @objc dynamic var code = 0
    @objc dynamic var message = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override static func primaryKey() -> String? {
        return "captchaId"
    }
    
    func mapping(map: Map) {
        captchaId <- map["captcha_id"]
        captchaImg <- map["captcha_img"]
        captchaIndex <- map["captcha_index"]
        code <- map["code"]
        message <- map["message"]
    }
}

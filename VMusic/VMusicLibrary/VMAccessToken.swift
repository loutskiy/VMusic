//
//  VMAccessToken.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 22.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

class VMAccessToken {
    
    fileprivate let kKEY_FOR_TOKEN = "VMUSIC_ACCESS_TOKEN"
    
    public func getToken () -> String {
        return UserDefaults.standard.string(forKey: kKEY_FOR_TOKEN) ?? ""
    }
    
    public func setToken (_ token: String) {
        UserDefaults.standard.set(token, forKey: kKEY_FOR_TOKEN)
    }
    
    
}

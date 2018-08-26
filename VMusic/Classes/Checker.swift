//
//  Checker.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
class Checker {
    
    /// This func check all fields for fill
    ///
    /// - Parameter fields: fields (only text)
    /// - Returns: fill or not
    static func checkFieldsForFill (_ fields:String..., success: @escaping()->Void) -> Void {
//        var fill = true
        for field: String in fields {
            if field == "" {
//                fill = false
                ViewManager.topViewController().showAlertMessage(text: "Заполните все поля", title: "Ошибка")
                return
            }
        }
        success()
//        return fill
    }
}

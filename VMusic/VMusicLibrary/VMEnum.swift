//
//  VMEnum.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

enum VMAuthState {
    case authComplete
    case tokenExp
}

enum VMCaptchaState {
    case none
    case captchaDatmusic
    case captchaVk
}

enum VMStoreState {
    case web
    case local
}

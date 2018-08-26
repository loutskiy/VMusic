//
//  VMDelegate.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 23.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

protocol VMDelegate {
    func sendStateFromVMusic (_ state: VMAuthState)
}

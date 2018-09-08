//
//  VMusic.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 22.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import Alamofire

class VMusic {
    
    static let shared = VMusic()
    
    let token = VMAccessToken().getToken()
    
    var delegate: VMDelegate?
    
    init() {
        checkPermissions { (isLogin) in
            if isLogin {
                self.delegate?.sendStateFromVMusic(VMAuthState.authComplete)
            } else {
                self.delegate?.sendStateFromVMusic(VMAuthState.tokenExp)
            }
        }
        
        if checkPermissions() {
            self.delegate?.sendStateFromVMusic(VMAuthState.authComplete)
        } else {
            self.delegate?.sendStateFromVMusic(VMAuthState.tokenExp)
        }
    }
    
    @discardableResult
    func checkPermissions (_ permissions: @escaping ( Bool ) -> Void = { _ in } ) -> Bool {
        if VMAccessToken().getToken() != "" {
            self.delegate?.sendStateFromVMusic(VMAuthState.authComplete)
            permissions(true)
            return true
        } else {
            self.delegate?.sendStateFromVMusic(VMAuthState.tokenExp)
            permissions(false)
            return false
        }
    }
    
    func makeAuth (login: String, password: String, fail: @escaping (_ error: NSError) -> Void) {
        VMServerManager.generateToken(login: login, password: password, success: { (token) in
            VMAccessToken().setToken(token)
            self.checkPermissions()
        }) { (error) in
            print(error)
            fail(error)
        }
    }
    
    func getSongs (query: String = "", offset: Int = 0, success: @escaping (_ songs: [VMDatmusicModel]) -> Void) {
        VMServerManager.sendRequestToDatmusic(query: query, offset: offset, success: { (data) in
            success(data)
        }) { (error) in
            success([VMDatmusicModel()])
            self.showErrorMessage(error: error)
            print(error)
        }
    }
    
    func getMySongs (offset: Int = 0, query : String = "", store: VMStoreState = .web, success: @escaping (_ songs: [VMSongModel]) -> Void) {
        switch store {
        case .web:
            let params : Parameters = ["offset":offset, "q":query]
            VMServerManager.sendRequestToVk(method: query == "" ? VMApiStruct.getMyAudio : VMApiStruct.searchAudio, parameters: params, success: { (data) in
                success(data)
            }) { (error) in
                print(error)
            }
        case .local:
            success(VMCache.shared.getSongs(query: query))
        }
    }
    
    func getTrackArtwork (artist: String, track: String,success: @escaping (_ imagePath: String) -> Void) {
        VMServerManager.sendRequestToLastFM(artist: artist, track: track, success: { (path) in
            success(path)
        }) { (error) in
            print(error)
        }
    }
    
    func getUserInfo (_ user: @escaping (_ user: VMUserModel) -> Void) {
        VMServerManager.sendRequestToVk(success: { (userModel) in
            user(userModel)
        }) { (error) in
            print(error)
        }
    }
    
    func deauth () {
        VMAccessToken().setToken("")
        VMCache.shared.clearAll()
        delegate?.sendStateFromVMusic(.tokenExp)
    }
    
    func showErrorMessage (error: NSError) {
        ViewManager.topViewController().showAlertMessage(text: error.localizedDescription, title: "Ошибка")
    }
}

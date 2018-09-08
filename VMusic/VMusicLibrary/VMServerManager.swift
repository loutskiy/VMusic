//
//  VMServerManager.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 22.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class VMServerManager {
    
    fileprivate static let userAgentForVkAPI = "KateMobileAndroid/48.2 lite-433 (Android 8.1.0; SDK 27; arm64-v8a; Google Pixel 2 XL; en)"
    static let userAgentForDatmusic = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.2 Safari/605.1.15"
    
    static func sendRequestToDatmusic (query: String, offset: Int, success: @escaping (_ songs: [VMDatmusicModel]) -> Void, fail: @escaping (_ error: NSError ) -> Void) {
        var params: Parameters = ["q": query, "page": offset]
        params = params.merging(VMCaptcha.shared.checkForCaptchaProtection(method: .captchaDatmusic)) { (_, new) in
            new
        }
        let headers: HTTPHeaders = ["User-Agent": userAgentForDatmusic, "Referer": "https://datmusic.xyz"]
        Alamofire.request(VMApiStruct.datmusicSearch, method: .get, parameters: params, headers:headers).responseJSON { (response) in
            print(response.result.value)
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
                    if JSON["status"] as! String == "ok" {
                        let data = Mapper<VMDatmusicModel>().mapArray(JSONObject: JSON["data"])
                        success(data ?? [VMDatmusicModel]())
                    } else if JSON["status"] as! String == "error" {
                        let data = Mapper<VMErrorModel>().map(JSONObject: JSON["error"])
                        if data?.code == 14 {
                            VMCaptcha.shared.openCaptchaView(captchaIndex: (data?.captchaIndex)!, captchaId: (data?.captchaId)!, captchaImg: (data?.captchaImg)!)
                        }
                    } else {
                        fail(NSError(domain: "ru.lwts.VMusic", code: 2, userInfo: nil))
                    }
                }
            case .failure(let error):
                fail(error as NSError)
            }
        }
    }
    
    static func sendRequestToVk (method: String, parameters: Parameters = Parameters(), success:@escaping (_ songs: [VMSongModel]) -> Void, fail: @escaping (_ error: NSError ) -> Void) {
        var parameters = parameters
        parameters["v"] = 5.64
        parameters["access_token"] = VMAccessToken().getToken()
        parameters["count"] = 100
        parameters["sort"] = 2
        parameters["auto_complete"] = 1
        
        let headers: HTTPHeaders = ["User-Agent": userAgentForVkAPI]
        Alamofire.request(method, method: .get, parameters: parameters, headers:headers).responseJSON { (response) in
            print(response.result.value)
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
                    let data = Mapper<VMResponseModel>().map(JSONObject: JSON["response"])
                    success(data?.items ?? [VMSongModel()])
//                    if JSON["status"] as! String == "ok" {
//                        let data = Mapper<VMusicSongModel>().mapArray(JSONObject: JSON["data"])
//                        success(data ?? [VMusicSongModel]())
//                    } else {
//                        fail(NSError(domain: "ru.lwts.VMusic", code: 2, userInfo: nil))
//                    }
                }
            case .failure(let error):
                fail(error as NSError)
            }
        }
    }
    
    static func sendRequestToVk (success: @escaping (_ user: VMUserModel) -> Void, fail: @escaping(_ error: NSError) -> Void) {
        let parameters: Parameters = ["v": 5.64, "access_token": VMAccessToken().getToken(), "fields": "photo,photo_medium,photo_big"]
        let headers: HTTPHeaders = ["User-Agent": userAgentForVkAPI]
        Alamofire.request(VMApiStruct.getUser, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success:
                 if let JSON = response.result.value as? [String:AnyObject] {
                    let data = Mapper<VMUserModel>().mapArray(JSONObject: JSON["response"])
                    success(data?.first ?? VMUserModel())
                 }
            case .failure(let error):
                fail(error as NSError)
            }
        }
    }
    
    static func generateToken (login: String, password: String, success:@escaping (_ token: String) -> Void, fail: @escaping (_ error: NSError ) -> Void) {
        let params: Parameters = ["login": login, "pass": password]
        Alamofire.request(VMApiStruct.getToken, method: .post, parameters: params).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
                    if JSON["status"] as! String == "ok" {
                        success(JSON["token"] as! String)
                    } else {
                        fail(NSError(domain: "ru.lwts.VMusic", code: 1, userInfo: nil))
                    }
                }
            case .failure(let error):
                fail(error as NSError)
            }
        }
    }
    
    static func sendRequestToLastFM (artist: String, track: String, success:@escaping (_ path: String) -> Void, fail: @escaping (_ error: NSError ) -> Void) {
        let params: Parameters = ["artist": artist, "track": track]
        Alamofire.request(VMApiStruct.getAlbumArtwork, method: .get, parameters: params).responseJSON { (response) in
            //print(response.result.value)
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
                    if let trackObject = JSON["track"] as? [String : AnyObject ] {
                        if let album = trackObject["album"] as? [String : AnyObject] {
                            let data = Mapper<VMImageModel>().mapArray(JSONObject: album["image"]) ?? [VMImageModel]()
//                            print(data)
                            for image in data {
                                if image.size == "extralarge" {
                                    success(image.text)
                                }
                            }
                        }
                    }
                }
                break
            case .failure(let error):
                fail(error as NSError)
            }
        }
    }
}

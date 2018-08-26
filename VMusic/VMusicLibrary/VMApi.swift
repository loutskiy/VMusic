//
//  VMApi.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 22.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation

struct VMApiStruct {
    
    fileprivate struct Domains {
        static let VkUrl = "https://api.vk.com/method/"
        static let DatmusicUrl = "https://api-2.datmusic.xyz/"
        static let TokenUrl = "https://audio.bigbadbird.ru/"
        static let LastFMUrl = "http://ws.audioscrobbler.com/2.0/?format=json&method="
    }
    
    fileprivate static let VkUrl = Domains.VkUrl
    fileprivate static let TokenUrl = Domains.TokenUrl
    fileprivate static let DatmusicUrl = Domains.DatmusicUrl
    fileprivate static let LastFMUrl = Domains.LastFMUrl
    
    static var getToken: String {
        return TokenUrl + "src/examples/example_microg.php"
    }
    
    static var searchAudio: String {
        return VkUrl + "audio.search"
    }
    
    static var getMyAudio: String {
        return VkUrl + "audio.get"
    }
    
    static var datmusicSearch: String {
        return DatmusicUrl + "search"
    }
    
    static var getAlbumArtwork: String {
        return LastFMUrl + "track.getInfo"
    }
    
    static var getAlbums: String {
        return VkUrl + "audio.getAlbums"
    }
    
    static var getUser: String {
        return VkUrl + "users.get?fields=photo,photo_medium,photo_big"
    }
}

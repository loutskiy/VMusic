//
//  VMCache.swift
//  VMusic
//
//  Created by Mikhail Lutskiy on 24.08.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import Foundation
import RealmSwift
import SDWebImage

class VMCache {
    
    static let shared = VMCache()
    
    var songs : Results<VMSongModel>?
    
    let fileManager = FileManager.default
    
    let myDocuments = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    fileprivate init() {
        songs = realm.objects(VMSongModel.self)
    }
    
    func getSongs (query : String = "") -> [VMSongModel] {
        if query == "" {
            return songs?.toArray(ofType: VMSongModel.self) ?? [VMSongModel]()
        } else {
            return songs?.filter("title CONTAINS[cd] '\(query)' || artist CONTAINS[cd] '\(query)'").toArray(ofType: VMSongModel.self) ?? [VMSongModel]()
        }
    }
    
    func insertSong (_ song : VMSongModel) {
        if song.localPath != "" {
            try! realm.write {
                realm.add(song, update: true)
            }
        }
    }
    
    func deleteSong (_ song : VMSongModel) {
        try! realm.write {
            realm.delete(realm.objects(VMSongModel.self).filter("id == \(song.id)"))
        }
        
        let file = myDocuments.appendingPathComponent("\(song.id)_\(song.ownerId).mp3")
        try? fileManager.removeItem(at: file)
        
    }
    
    func clearAll () {
        try! realm.write {
            realm.deleteAll()
        }
        
        guard let filePaths = try? fileManager.contentsOfDirectory(at: myDocuments, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk(onCompletion: nil)
    }
    
    func getLocalPathForSong (id : Int) -> String{
        let song = realm.objects(VMSongModel.self).filter("id = \(id)").first
        return song?.localPath ?? ""
    }
    
}
